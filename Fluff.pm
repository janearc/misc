# $Id: Fluff.pm,v 1.5 2004/03/01 15:18:18 jane Exp $

# POE::Component::LaDBI::Fluff
# Provides superclass for LaDBI that reduces the amount of 'clutter'
# in applications using the LaDBI class.

# TODO: differentiate between dispatch_store and dispatch_retrieve
# TODO: check $h->{handle_id} for pingness, toss a failure if it isn't
#       connected.
# TODO: check statement handles?

package POE::Component::LaDBI::Fluff;

use POE qw{ Component::LaDBI Session };
use warnings;
use strict;
use Carp qw{ cluck carp };

sub create {
	my $class = shift;
	my $alias = shift;

	POE::Session->create( 
		inline_states => {
			_start => sub { $_[KERNEL]->alias_set( $alias ) },
	
			# client support
			'connect'       => \&dispatch_connect,
			'disconnect'    => \&dispatch_disconnect,
			'retrieve'      => \&dispatch_retrieve,
			'store'         => \&dispatch_store,
			'alarm_handler' => \&dispatch_alarm_handler,

			# user configuration
			'set_statement_caching' => \&set_statement_caching,
			'set_alarm_state'       => \&set_alarm_state,

	
			# our stuff
			good_connect    => \&good_connect,
			bad_connect     => \&bad_connect, # connect needs a special fail state
			good_prepare    => \&good_prepare,
			good_execute    => \&good_execute,
			good_fetchall   => \&good_fetchall,

			# the one general failure state
			failure         => \&failure,

		},
		heap => {
			ladbi                   => '',
			alarm_state             => 'fluff_error',
			alarm_session           => '',
			cache_statement_handles => 0,
			cached_handles          => { },
			fetch_hashes            => 0,
		},
	);

}

# Let the user configure some variables
sub set_statement_caching {
	my ($k, $h) = (@_[ KERNEL, HEAP ]);
	my ($new_value, $return_state) = (@_[ ARG0, ARG1 ]);
	return unless defined $new_value;
	$heap->{cache_statement_handles} = $new_value;
	if ($return_state) { $k->post( $_[SENDER], $return_state, $new_value );
}

sub set_alarm_state {
	my ($kernel, $heap) = (@_[ KERNEL, HEAP ]);
	my ($session, $state, $return_state) = (@_[ ARG0, ARG1, ARG2 ]);
	$h->{alarm_session} = $session;
	$h->{alarm_state} = $state;
	if ($return_state) { $k->post( $_[SENDER], $return_state, $session, $state );
}


# Send the connect request to ladbi. Let it figure out whether it was
# successful or not.
sub dispatch_connect {
	my ($k, $h, $s) = (@_[ KERNEL, HEAP, SESSION ]);
	my ($dbinfo, $return_state, @args) = (@_[ ARG0, ARG1, ARG2 .. $#_ ]);

	my ($sender) = (@_[SENDER]);

	$h->{ladbi} = POE::Component::LaDBI->create( Alias => 'fluff_ladbi' );
	$k->post( fluff_ladbi => 
		'connect',
		SuccessEvent    => 'good_connect',
		FailureEvent    => 'bad_connect',
		Args            => $dbinfo,
		UserData =>
			{
				Sender      => $sender,
				Destination => $return_state,
				Error       => 'Failed database connection',
				Args        => \@args,
			}
	);
}

# Ladbi tells us we have connected. This means we can tell the user that we 
# have a connection by posting the event they supplied, and pass their data
# back to them.
sub good_connect {
	my ($k, $h, $s) = (@_[ KERNEL, HEAP, SESSION ]);
	my ($handle_id, $datatype, $data, $userdata) = (@_[ ARG0 .. ARG3 ]);
	my ($return_session, $return_state) = 
		@{ $userdata }{qw{ Sender Destination }};
	my $their_data = $userdata->{Args}; # what they gave us

	# Let's put this away for later use.
	unless ($h->{handle_id}) { $h->{handle_id} = $handle_id }

	# Here you go, user.
	$k->post( $return_session, $return_state, $their_data );
}

# Woe is us, Ladbi failed to connect. Inform the user that they do not have
# a database connection by posting to their error state.
sub bad_connect {
	my ($k, $h, $s) = (@_[ KERNEL, HEAP, SESSION ]);
	my $errstr      = @_[ARG2];
	my $userdata    = $_[ARG4];

	my ($return_session, $local_error) = 
		@{ $userdata }{qw{ Sender Error }};
	
	# Inform the user.
	$k->post( 
		$h->{alarm_session} || $return_session, 
		$h->{alarm_state}, 
		"$local_error [ $errstr ]" 
	);
}

# The user has requested we stuff something into the database, and they don't
# care what happens (except the implicit error). So, try to do that.
sub dispatch_store {
	my ($k, $h, $s, $sender) = (@_[ KERNEL, HEAP, SESSION, SENDER ]);
	my ($sql, $bindvals, $destination, @args) = (@_[ ARG0 .. $#_ ]);
	my $their_data = \@args;
	if (my $cached_handle = $h->{cached_handles}->{$sql} 
	    and $h->{cache_statement_handles}               ) {
		$k->post( fluff_ladbi =>
			'execute',
			SuccessEvent    => 'good_execute',
			FailureEvent    => 'failure',
			HandleId        => $cached_handle,
			Args            => $bindvals,
			UserData =>
				{
					Sender      => $sender,
					Destination => $destination,
					Error       => "Execution failed of '$sql' via cached handle failed.",
					Args        => $their_data,
					Mode        => 'store'
					sql         => $sql,
				}
		);
	}	
	else {
		$k->post( fluff_ladbi =>
			'prepare',
			SuccessEvent    => 'good_prepare',
			FailureEvent    => 'failure',
			HandleId        => $h->{handle_id},
			Args            => $sql,
			UserData =>
				{
					Sender      => $sender,
					Destination => $destination,
					Error       => "Prepare of '$sql' failed",
					BindVals    => $bindvals,
					Args        => $their_data,
					Mode        => 'store',
					sql         => $sql,
				}
		);
	}
}

# This is a retrieve request. Check for cachedness, prepare or execute
# accordingly, and send off a request to ladbi for data.
sub dispatch_retrieve {
	my ($k, $h, $s, $sender) = (@_[ KERNEL, HEAP, SESSION, SENDER ]);
	my ($sql, $bindvals, $destination, @args) = (@_[ ARG0 .. $#_ ]);
	my $their_data = \@args;
	if (my $cached_handle = $h->{cached_handles}->{$sql}
	    and $h->{cache_statement_handles}               ) {
		$k->post( fluff_ladbi =>
			'execute', 
			SuccessEvent     => 'good_execute',
			FailureEvent     => 'failure',
			HandleId         => $cached_handle,
			Args             => $bindvals,
			UserData =>
				{
					Sender       => $sender,
					Destination  => $destination,
					Error        => 'Execution failed of '$sql' via cached handle.',
					Args         => $their_data,
					Mode         => 'retrieve',
					sql          => $sql,
				}
		);
	}
	else {
		$k->post( fluff_ladbi =>
			'execute', 
			SuccessEvent     => 'good_prepare',
			FailureEvent     => 'failure',
			HandleId         => $h->{handle_id},
			Args             => $sql,
			UserData =>
				{
					Sender       => $sender,
					Destination  => $destination,
					Error        => 'Prepare of '$sql' failed.',
					BindVals     => $bindvals,
					Args         => $their_data,
					Mode         => 'retrieve',
					sql          => $sql,
				}
		);
	}
}

# This is one of our calls. In general, this should be called from
# dispatch_store.
sub good_prepare {
	my ($k, $h, $s, $sender) = (@_[ KERNEL, HEAP, SESSION, SENDER ]);
	my ($handle_id, $datatype, $data, $userdata) = (@_[ ARG0 .. ARG3 ]);
	my ($return_session, $return_state) = 
		@{ $userdata }{qw{ Sender Destination }};
	my $their_data = $userdata->{Args}; # what they gave us
	my $sql = $userdata->{sql};

	if ($h->{cache_statement_handles}) {
		$h->{cached_handles}->{$sql} = $handle_id;
	}

	# Now, we've got a prepared statement, and we have our bindvals, so let's
	# execute the statement, and get ready to give the user their data. We lose
	# the bindvals variables here, but we don't need it since the statement
	# either tanked or succeeded, and the user will give it to us 
	# when called upon to execute again.
	$k->post( fluff_ladbi =>
		'execute',
		SuccessEvent    => 'good_execute',
		FailureEvent    => 'failure',
		HandleId        => $handle_id,
		Args            => $userdata->{BindVals},
		UserData =>
			{
				Sender      => $sender,
				Destination => $destination,
				Error       => "Execution failed of '$sql' failed.",
				Args        => $their_data,
				Mode        => $userdata->{Mode},
				sql         => $sql,
			}
	);
}

# Another state which should only be called internally. Basically, we've
# prepared a statement, and we've executed it. This means that we can snarf the
# data out of it if the user requested it.
sub good_execute {
	my ($k, $h, $s, $sender) = (@_[ KERNEL, HEAP, SESSION, SENDER ]);
	my ($handle_id, $datatype, $data, $userdata) = (@_[ ARG0 .. ARG3 ]);
	my ($return_session, $return_state) = 
		@{ $userdata }{qw{ Sender Destination }};
	my $their_data = $userdata->{Args}; # what they gave us

	my $mode = $userdata->{Mode};

	if ($mode eq 'store') {
		return;
	}
	elsif ($mode eq 'retrieve') {
		$k->post( fluff_ladbi =>
			# Make sure we return what the user wanted
			$h->{fetch_hashes} ? 'fetchall_hash' : 'fetchall',
			SuccessEvent    => 'good_fetchall',
			FailureEvent    => 'failure',
			HandleId        => $handle_id,
			# Not including Args.
			UserData =>
				{
					Sender      => $sender,
					Destination => $destination,
					Error       => "Fetchall failed for '$sql'."
					Args        => $their_data,
					sql         => $sql,
				}
		);
	}
	else {
		$userdata->{Error} = 'Unspecified logic error.';
		# ARG4 here is our userdata structure
		$k->yield( 'failure', undef, undef, undef, undef, $userdata ); 
	}
}

# So, we've prepared and executed, and the data has come back to us.
# At this point, we package the data up for them and post it back to
# them.
sub good_fetchall {
	my ($k, $h, $s, $sender) = (@_[ KERNEL, HEAP, SESSION, SENDER ]);
	my ($handle_id, $datatype, $data, $userdata) = (@_[ ARG0 .. ARG3 ]);
	my ($return_session, $return_state) = 
		@{ $userdata }{qw{ Sender Destination }};
	my $their_data = $userdata->{Args}; # what they gave us

	# Here you go, user. Bye..
	$k->post( $return_session, $return_state => $datatype, $data, $their_data );
}

# The general failure state.
sub failure {
	my ($k, $h, $s, $sender) = (@_[ KERNEL, HEAP, SESSION, SENDER ]);
	my $message = $_[ARG0];
	my ($handle_id, $errtype, $errstr, $errnum, $userdata) = (@_[ ARG0 .. ARG4 ]);

	my ($return_session, $local_error) = 
		@{ $userdata }{qw{ Sender Error }};

	$k->post($h->{alarm_session} || $return_session, 
		$h->{alarm_state},
		"$local_errstr [ $errstr ]"
	);
}

1;

=pod

=head1 NAME

  POE::Component::LaDBI::Fluff

=head1 ABSTRACT

  POE::Component::LaDBI::Fluff - it's teh fluff.

=head1 SYNOPSIS

  POE::Component::LaDBI::Fluff->create( 'fluff' );
  
  $k->post( 'fluff', 'alarm_handler', 'failure_state' );

  $k->post( 'fluff' =>  'connect', 
    [ qw/ dsn user pass /, { Args } ], 
    'return_state'
    @args,
  );
  $k->post( 'fluff', 'retrieve', $sql, \@bindvals, 'return_state', @args );
  $k->post( 'fluff', 'store', $sql, \@bindvals, 'return_state', @args );

=head1 GENERAL PRINCIPLE

=over 2

B<Why another database module?>

=back

In a nutshell, POE::Component::LaDBI::Fluff is intended to be a layer
of abstraction around POE::Component::LaDBI.

For many applications which use the POE framework, the choice for non-blocking
database operations is an unpleasant one: either a vastly more complicated
"state machine" must be created, or database operations will be blocking. The
reason for this is the interface to the various POE Database API's is very
complicated. This is out of necessity.

However, for many applications, it is not necessary to even know the results of
what happened during a database operation, other than whether it failed. As
such, if we can endeavor to simplify all database operations to one of two
methods (store and retrieve), we can retain a non-blocking approach, and yet
only have to issue store and retrieve quests, rather than setting up an entire
database layer.

This module is not going to be right for everybody, and will not be right for
programs that extend beyond a small level of complexity. However, it should be
helpful to add a non-blocking database component to small programs without
adversely affecting their readability, debugging, or maintenance.

=head1 METHODS

I<Of course, there are no real "methods", but it may be helpful to think of the
states herein as methods.>

=over 4

=item B<create>

=over 2

  POE::Component::LaDBI::Fluff->create( 'fluff' );

The simplest method, create takes one argument, and one argument only. The name
of the alias with which you will refer to the LaDBI::Fluff session.

=back

=item B<connect>

=over 2

  $k->post( 'fluff' =>  'connect', 
    [ qw/ dsn user pass /, { Args } ], 
    'return_state'
    @args,
  );

This method will be familiar to all users of both C<DBI> and
C<POE::Component::LaDBI>. The first argument should be an arrayref containing
the standard connect arguments, followed by any args you wish to be passed
directly to DBI.

The second argument should be the state you would like to be called when the
connect comes back.

Any arguments afterwhich will be passed along to the state you specify.

Please read below regarding failures in this module for information on what
happens when the connect method fails.

=back

=item B<retrieve>

=over 2
  
  my $sql      = 'select col1, col2 from tablename where foo = ?';
  my @bindvals = ($foo);
  my @args     = qw{ more stuff here };
  $k->post( 'fluff', 'retrieve', $sql, \@bindvals, 'return_state', @args );

  # Or, without bindvals or args:

  my $sql = 'select col1 from tablename';
  $k->post( 'fluff', 'retrieve', $sql, [ ], 'return_state' );

B<retrieve> is a simple method for requesting data through LaDBI. The basic
assumption here is that you don't really care how it gets the data. Posting sql
and (optionally) bind values to it will simply come back to the state you
specify with the data as it would be returned from DBI. The exact arguments
which will be passed to you are the "datatype", the data itself, and then the
arguments which you specified (C<@args> in the above example) in the initial
request.

For more information on the datatype value, please see the
C<POE::Component::LaDBI> documentation.

=back

=item B<store>

=over 2

  $k->post( 'fluff', 'store', $sql, \@bindvals, 'return_state', @args );

This state is much simpler than retrieve, in that it never attempts to actually
gain any data from the database. This would be used for example with updates and
inserts, and other queries which return no data. The same generic failure rules
apply here.

=back

=back

=head1 CONFIGURING FLUFF

=over 4

=item B<set_statement_caching>

=over 2

  $k->post( 'fluff', 'set_statement_caching', 1, 'return_state' );

This method turns on statement handle caching in Fluff. This basically
means that if you issue the same store or retrieve query many times,
Fluff will attempt to re-use the statement handle, theoretically saving
prepare time. In general, this should not be problematic. However, if
there are problems with the statement handle, you may have problems. Fluff
is not smart enough to know when this happens, so use with caution.

If you provide a second argument, Fluff will post back to that state with the
value you issued to it.

=back

=item B<set_alarm_state>

=over 2

  $k->post( 'fluff', 'set_alarm_state', => 
            'mysession', 'my_alarm_handler'
            'return_state'                  );

See B<GOTCHAS> below for information on what's really going on here.

This allows you to set who Fluff calls when something bad happens to
it. B<If you DO NOT SET THIS, FLUFF WILL POST TO A NON-EXTANT STATE,
AND YOU WILL NOT KNOW WHEN YOU HAVE AN ERROR!>

If you pass a return state, it will post back to you the values that
you gave it.

=back

=back

=head1 GOTCHAS

=over 2

=item B<THE FAILURE STATE>

Users familiar with C<LaDBI> will know that it requires a separate failure state
for each type of transaction. This can cause clutter. To reduce this, Fluff has
only one, generic, failure handler. Each possible failure within Fluff trickles
down to its internal failure state, at which point an error message (hopefully
useful, but not guaranteed to be so) is generated, and passed to the user's own
error handler. This can be set with the C<set_alarm_state> method.

Not setting this means that Fluff will post your errors to a state that doesn't
exist. This doesn't particularly bother POE, so you will not get any
notification. As such it is recommended (but not required) to set this variable
to something useful.

=back

=back

=head1 AUTHOR

  Jane Arc
  <useperl@aol.net>

=cut

# // vim:tw=80:ts=2:noet:syntax=perl
