I find that I am often programming in several languages at once. That shell is good for some things, node is more presentable than perl, python is more used than both (and taught in school, so&hellip;), sql has great referential integrity and things that are complex to do in other languages by virtue of it being in a database, web people tend to like ruby a lot, and so forth.

Because I do a lot of devops type stuff, I get to interact with all these different languages pretty much daily. And when I am asked to write a tool to support dev and ops, or even when I write a tool for myself, I usually write the parts of that tool in the language that is most suitable to that task.

This is in stark contrast to my early career when pretty much everything was done in perl or shell (with some sql, but mostly rather than sql, I did elaborate transformations with deeply-nested `map` calls).

I think, really, this is the best way to do things. 

What really kicks my ass on a day-to-day basis doing this, though, is that all these languages have analogous structures or ideas, and they are all just *slightly* different.

Python has dictionaries and they are mostly the same as perl's hashes and mostly the same as json's hashes, mostly the same as ruby's hashes, and so forth. The same can be said for closures and anonymous functions (mostly), and all the other trappings of modern programming languages.

The invocation and the syntax are different, even if the underlying structure or function is the same or close to the same. So what happens is I get this harsh cognitive thrashing when I am trying to "switch" from one language to another. It takes me a while to remember how functions in bash work. Or how referring to keys of a hash works in javascript. Even going back to YAML after weeks and weeks in json is difficult.

While I appreciate diversity in programming, I can't help but feel my life would be a little easier if I could write in some meta-language that understood how to "interpret down" into these other languages so that I could write "stub code" that accomplished what I want. And then, for the parts that really do require language specificity (interacting with a library that's only available for one language; referential integrity or DBMS specific calls; regular expressions, and so on), write *those specific parts* in that language.

It seems kind of obvious to me that we as programmers look at the world in a particular way; because of this we continue to create languages that have broad similarities because they describe the way the thinking works in our own heads. I know that I find myself looking for patterns in daily life that I can ascribe a certain reason or algorithm to. My guess is that programming languages are the way they are because people have a certain similarity of cognition.

Would that even be possible? Instead of writing a new programming language (there are new languages every day, right), map out the way we as people, as programmers specifically, perceive the world, and the structures that are organic and specific to human cognition. And from that, work towards logic structures upon which all subsequent constructs can be derived.