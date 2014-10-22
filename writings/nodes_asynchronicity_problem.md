I think I first started getting really into asynchronous programming in 2002 or 2003 when I was spending a lot of time on IRC and [`NET::IRC`](http://search.cpan.org/dist/Net-IRC/IRC.pm) had been deprecated for a while. The new hotness was [`POE`](http://search.cpan.org/~bingos/POE-Component-IRC-6.88/lib/POE/Component/IRC.pm) and if I wanted to build tools for myself, I needed to use POE, which is, was, kinda-sorta, an event-driven kernel for perl. More accurately, it's a [state machine](http://www.shopify.com/technology/3383012-why-developers-should-be-force-fed-state-machines). I immediately fell in love with the way state machines run because it thoroughly suited the patterns of my own cognition.

It allowed me to make very complicated code, and to segment and compartmentalise it where and how I wanted to. Instead of just spewing big blocks of perl code into packages, I had discrete workers that did very tiny tasks and all had uniform inputs. This was my very first foray into APIs (I never took any meaningful CS in college; the most complicated thing I ever wrote was a hamming code checksum in C, and I failed that class).

In order to write software this way, you have to have sort of [design-by-contract](http://c2.com/cgi/wiki?DesignByContract); since you aren't really keeping state *between* states/events, you have to have an understanding of what your input will look like because you could be invoked at any time to do whatever.

You had to tolerate getting stupid input gracefully (because otherwise the whole thing collapses), and write your code agnostically such that you could be called from anywhere and counted upon to do what was expected of you given a varying set of inputs.

I digress a little bit.

The point here is that this really formed who I am as a programmer and informed my style of software development henceforth evermore and etcetera. It is interesting to note that I took to this sort of programming the way I took to Unix; lots and lots of tiny little tasks broken out and named and given more-or-less similar interfaces (we all, for example, expect `-h` and `--help` to work, we expect `STDIN` to have things we operate on, and we expect to be able to `fopen` anything we want to read or write to).

[Sungo](https://twitter.com/sungo) and I worked on some pretty intense code in 2004, about 15klock in perl as I recall, and it was all written atop this big state machine. It was asynchronous in the way that a single-threaded perl process can be asynchronous. Callbacks were passed around, events were triggered, and so on. You wrote your code that way.

He said to me one day, "there are two kinds of code I write &mdash; ten or fifteen line one-off scripts and POE code." Which is to say, anything that was going to be more than a very quick interface or top-down imperative "go do this" script, you wrote it properly asynchronously, on top of a state machine. I agreed with him then, and mostly agree with him today. As recently as 2012, I was given a task at work of (perhaps strangely) writing an IRC client in perl, and I again used POE. It worked reasonably well and the design did not differ substantially from the code we wrote in 2004.

### Sometimes asynchronous programming is stupid.

The problem with this is that those ten-or-fifteen line pieces of code you write, they're important, too. And you don't want to write sixty lines of code to flesh out a state machine when you want to just make an eighty-byte HTTP request. I mean, if I want something as simple as this:

```
GET /riak/food/favorite HTTP/1.1
User-Agent: curl/7.30.0
Host: localhost:8998
Accept: */*

``` 

spat to a socket, why on earth would I want to create a state machine? Create callbacks? Deal with every single HTTP error on earth? Prepare for chunked output from the server? I mean, for crying out loud, the content of that tuple is `unagi`.

And yet, to do this in [Node](http://nodejs.org/), there are perhaps a half-dozen different libraries to pull down HTTP, in various ways. Because everyone seems to agree that the API's for HTTP requests in Node and other Javascripts are a huge pain in the ass, there are *libraries that wrap those libraries*. But they all boil down to one big problem: **asynchronous programming is sometimes more trouble than it's worth**.

You cannot just say `echo "require('http-sync').get('http://www.google.com/').body.print" | node`. And why? What is so offensive about this? In fact, we see repeated often throughout the documentation things like:

> In particular, checking if a file exists before opening it is an anti-pattern that leaves you vulnerable to race conditions: another process may remove the file between the calls to fs.exists() and fs.open(). Just open the file and handle the error when it's not there.

and [similar](http://stackoverflow.com/a/9884496) on stackoverflow:

> You should avoid synchronous requests. If you want something like synchronous control flow, you can use [async](https://github.com/caolan/async).

The problem with all this passing callbacks to callbacks to callbacks is we get things like the [Pyramid of Fail](http://sequelizejs.com/articles/getting-started#block-15-line-0). It's impossible to tell where in the scope of your code you are, what variables are available to you, how many curlies, squares, or parens you need. The interpreter is also not real helpful, merely telling you that it did not expect to find a ';' there when you get them mis-numbered.

There are ways around the horrifyingly-nested scopes, such as [naming each scope close](https://github.com/18F/Sendak/blob/ba68e99442b9c06eeb5d6b713834630a2f76cb8d/components/common/js/aws/run_instance.js#L147) with a comment (and indeed this is what we did with deeply-nested structures in the state machines I mention above), but generally these sorts of things make me want to claw my eyes out and I just lose any enthusiasm I had for the project at all.

I have to stop doing the actual creating of putting code together and start tracking down little omissions of single characters with an interpreter that doesn't have any real interest in helping me.

This kills productivity and morale.

### I guess what I am saying is node offends me.

The glib presumption that everything that's going on in Nodeville is actually being run in a browser, where blocking code is problematic. That if you are doing something synchronously, it's because you are *too stupid* to do it asynchronously. That *anything* worth doing is worth doing "right," which is to say, with tons of engineering around failure conditions and so forth.

But I am a shell programmer. I am a perl programmer. I do devops, not webdev. I hardly even do anything with a database anymore, and when I need to talk to a database, I generally only want one row from it, and of course I will wait until it's found me that row. I mean, what else am I going to do?

I guess these things would not bother me if the attitude weren't so consistently AVOID SYNCHRONOUS CODE and YOURE DOING IT WRONG. This is just as bad as people coming along and saying "why would you do that in this complicated way when you can just do it synchronously and block until you hear back from the webserver?"

It is as if these people admonishing me to write this complicated code have never actually encountered a situation where their environment is stateless, is by definition blocking, is not a huge block of code, and doesn't need to be maintained by fifteen people of varying degrees of skill.

Node utterly fails at doing simple tasks because it is so incredibly eager to do things in this very complicated (sometimes useful) way.

I'm reminded of, back in the old days, when somebody would come to IRC in `#perl` and ask us questions about web stuff. We would always say "rule 1 of `#perl` is NO WEB." I think back then we were kind of jerks about this, because web programming is heinously complicated and involves lots of things none of us ever wanted to work with &mdash; as perl hackers, most of us were sysadmins who *also* wrote code, rather than coders who *sometimes* ran a thing in the shell.

And so those folks, who were `+b`'d from the channel for asking, for the third time, how to use `cgi-lib.pl`, are now the designers of a language that insists on doing everything the web way, and that *I* am now the one who is doing things wrong, in an environment that they don't understand or care for.

It's really bitter.