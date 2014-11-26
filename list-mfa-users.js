#!/usr/bin/env node 

var github = require( 'github' )
	, g      = new github( {
		version  : '3.0.0',
		// debug    : true,
		protocol : 'https',
		timeout  : 5000,

		headers  : {
			'user-agent': 'jane-prefers-the-shell-over-the-webz-thx'
		}
	} );

if (process.env.GH_TOKEN) {
	g.authenticate( {
		type    : 'oauth',
		token   : process.env.GH_TOKEN
	} )
}
else if (process.env.GH_SECRET) {
	g.authenticate( {
		type    : 'oauth',
		key     : process.env.GH_KEY,
		secret  : process.env.GH_SECRET
	} )
}


g.orgs.getMembers( {
	org: '18F',
	filter: '2fa_disabled',
} , function (e, m) {
		m.forEach( function (user) {
			results.push( ' [' + rpad( user.id, longest_id + 1) + ']  ' + user.login );
		} );

		console.log( results.join( "\n" ) );
} );


// Stolen from sendak-usage
//
// Get the longest string from a list
//
function longest (l) { // {{{
	var maxlen = 0;
	l.shift().forEach( function (s) { if (s.length > maxlen) { maxlen = s.length } } );
	return maxlen;
} // }}}

// String right padding helper
//
function rpad(str, length) { // {{{
	str = '' + str;
	while (str.length < length) { str = str + ' ' }
	return str;
} // }}}
