# Thou Shall Not Covet thy Object's Internals

Source: https://www.perlmonks.org/?node_id=75578 (Meditations)

---

## Ovid (Cardinal) — Apr 25, 2001 at 23:36 UTC

We've heard it time and time again: messing with the internal data that an object carries around with it voids the warranty, isn't guaranteed to work and makes your milk go sour. Objects have interfaces and *that's* how you use them. Period. Don't mess with the internals unless you really, really know what you are doing and why. Then, if you do, still don't mess with them. If the object doesn't do what you want, write a new method. Better yet, write a package that inherits from that object and has the methods. Tell the boss it can't be done if you have to. Just don't mess with those darned internals!

I told him not to do it. I told him he was gaining short-term pleasure at the expense of long-term pain (I realize that I make myself seem so wise in my posts -- what a crock). My ex-boss (he since quit :), who only started using CGI.pm after it became painfully apparent that his hand-rolled version wasn't cutting it, decided that he needed to access the internals of the CGI object to do some "deep" file handling voodoo. I don't know which programs he did this to or how extensive the damage was.

Current scenario: tight deadline to upload a series of scripts that I have written to handle press releases being managed on a company's Web site. The owner promised it would be working today. I uploaded the scripts and they all died a horrible death. Seems I was using a much newer version of CGI.pm than we have on the production server. Can we upgrade safely? Dunno. I've backed up all of the files and in about 1/2 hour, I push the button to install the new version of the CGI module and hopefully my stuff will then run.

I don't have enough time to rewrite my code. No one else here knows exactly where the previous boss put his CGI-diddling code, we just know it's out there. He was bragging about it. Now we're on pins and needles because a large client is demanding my programs, but if I get them running, who knows what else will break?

How could we have avoided all of this "will it break" stress? Reread the title.

Until next time!

Cheers,
Ovid

> Join the Perlmonks Setiathome Group or just click on the the link and check out our stats.

> This node brought to you by the letter 'F'. (If you have to ask, don't)

---

## (dws)Re: — dws (Chancellor) — Apr 25, 2001 at 23:51 UTC

*Objects have interfaces and* that's *how you use them.*

Hence the old object saying:

> You can pick your friends,
> And you can pick your privates,
> But you shouldn't pick your friends' privates.

---

## Re: — Sherlock (Deacon) — Apr 26, 2001 at 08:30 UTC

As a firm believer in object-oriented programming, I feel that this is an excellent post. The idea is that you create a module to encapsulate some piece of data and then "hide it" from the user of that module. That module will then be able to maintain and modify that data as per your request through the use of its interface.

I like to think of it this way:

Imagine you go to a bakery and there are three doughnuts and you'd like to take two. You have two options:

1. Reach into the display, grab two, and run. (Praying that the baker doesn't have a gun and a military background...)
2. Ask the baker politely for the two doughnuts.

The results are much as you'd expect, if you simply grab the doughnuts and run, the baker might lose track of how many doughnuts he was supposed to have...or did have..or will have...or...or...and just shoot himself. Of course, if you ask the baker politely, he can calmly give you the two doughnuts, modify his internal counter, and go on with his baking-filled life.

In case you haven't figured it out yet, this sad attempt at an allgory depicts a module (the baker) and a user (you). You can either use the module's interface and ask nicely for what you want, or you can just grab it on your own and pray that the module doesn't crumble before you. Messing with data that's "hidden" is only asking for trouble - just like what Ovid ran into. After all, the data must be hidden for a reason.

If the baker doesn't understand your questions (doesn't have the proper interface), you'll just have to build a better baker. ;-)

I sure do hope my ramblings make sense to someone...

- Sherlock

---

## Re: — princepawn (Parson) — Apr 26, 2001 at 01:31 UTC

I was asked to expand on my comments about ties as being good ways of hiding an object's implementation. I will use Tie::Cycle.

here is a normal usage of this module:

```perl
use Tie::Cycle;

tie my $cycle, 'Tie::Cycle', [ qw( FFFFFF 000000 FFFF00 ) ];

print $cycle; # FFFFFF
print $cycle; # 000000
print $cycle; # FFFF00
print $cycle; # FFFFFF  back to the beginning
```

From the standpoint of a person who is used to getting at object internals, he has no hope here. In fact, higher management could install the Tie::Cycle module, and the programmers would be free to use the module, making use of normal Perl syntax but with Tie::Cycle semantics.

But in no case could they use their tied scalar to access their "object" in this case, `$cycle`.

It's funny that I wrote this post, because I used to hate Perl ties. My way of describing them was:

> They take a perfectly obvious piece of Perl code and make it so you have no idea what it might do anymore.

But after reading Ovid's post, I guess I have to say

> They take a Perl module whose privates might have been violated using OOP availability and allow Perl to do the `FETCH`ing and `STORE`ing for the programmer, with a large variety of available semantics.

### (tye)Re: — tye (Sage) — Apr 26, 2001 at 02:33 UTC

To truely protect your object internals, you need to use closures.

**Update:** Note that I find doing such to be not only overkill but a bad idea in Perl (except perhaps within large Perl projects where the temptation to peek at another class's implementation, *your* motivation to protect other team members from themselves, and the interdependence of classes may all be higher). And with new modules for getting at lexicals other than your own, the extra 'protection' provided now isn't much anyway.

- tye (but my friends call me "Tye")

### Re: Re: — merlyn (Sage) — Apr 26, 2001 at 01:55 UTC

> *But in no case could they use their tied scalar to access their "object" in this case, $cycle.*

Wrong. See `perldoc -f tied`.

-- Randal L. Schwartz, Perl hacker

### Re: Re: — hdp (Beadle) — Apr 26, 2001 at 01:57 UTC

You seem to be forgetting `tied`.

hdp.

### Re^2: — brian_d_foy (Abbot) — Jan 16, 2006 at 04:19 UTC

You forgot the next line in the synopsis for Tie::Cycle, which shows you how to get to the underlying object. I supplied other methods besides those for the tie interface.

```perl
(tied $cycle)->reset;  # back to the beginning
```

Farther down in the docs I list a couple other object methods you can use.

-- brian d foy &lt;brian@stonehenge.com&gt;
Subscribe to The Perl Review

---

## Re: — princepawn (Parson) — Apr 25, 2001 at 23:39 UTC

This why Perl ties are so nice. All you can do is use normal Perl data structrures --- the getting and setting of the actual fields in necessarily hidden.

### Re^2: — brian_d_foy (Abbot) — Jan 16, 2006 at 04:15 UTC

Perl ties don't prevent you from accessing the object data. You can get the object back with `tied`, or say the return value from `tie`.

```perl
my $object = tie my $scalar, 'Tie::Scalar::SomethingCool';
my $object2 = tied( $scalar );
```

Of course, people have to do a little more work to do that, but the people that want to mess with your internals won't mind the work.

-- brian d foy &lt;brian@stonehenge.com&gt;
Subscribe to The Perl Review

---

## Re: — Anonymous Monk — Apr 26, 2001 at 01:02 UTC

Isn't accessing the inside of an object faster than calling methods on it?

### Re: Re: — turnstep (Parson) — Apr 26, 2001 at 01:04 UTC

Yes, in the same way that leaving through the nearest wall is "faster" than using the door. :)

#### Re: Re: Re: — Lexicon (Chaplain) — Apr 26, 2001 at 05:46 UTC

Perl is like the Japanese Culture of languages. All the walls are built of paper, so you can peer in and get an idea of the shape of things.

Unfortuantly, paper tears easily.

And then you discover what you thought were the Emperor's concubines were actually a hoard of samurai. Oops.

-Lexicon

#### Re: Re: Re: — merlyn (Sage) — Apr 26, 2001 at 01:53 UTC

Or coding in assembly is faster than using a high-level language.

-- Randal L. Schwartz, Perl hacker

---

## Re: — jdhedden (Deacon) — Jan 16, 2006 at 00:27 UTC

This is another example of why inside-out objects are so nice: You can't 'covet' their internals.

> Remember: There's always one more bug.

### Re^2: — dragonchild (Archbishop) — Jan 16, 2006 at 15:42 UTC

I believe what AnonyMonk was saying is that modules like Padwalker allow you to do nasty things.

Basically, the rule is Perl will never prevent you from doing something. It's just that you should be aware of the consequences if you end up using things like Padwalker or B::Generate to do what you want.

> My criteria for good software:
> 1. Does it work?
> 2. Can someone else come in, make a change, and be reasonably certain no bugs were introduced?

### Re^2: — Anonymous Monk — Jan 16, 2006 at 03:03 UTC

Sure you can :)
