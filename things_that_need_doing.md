* google voice pumped into bitlbee
	* google says they're ending scraping and that an API is available, but they have not published the API.
	* it may just be better to use (extant) skype support (which sadly costs money...)

* un-fuck cp/tar/ditto/etc on mavericks from time machine 
  * a command that can take a filename as argument and either create a copy of that file or create a directory without the 'chattr' flags that TM creates.
		```dd if="`./olddir.sh`/Documents/Avriette, Jane (public).pdf" of=Documents/Avriette,_Jane_\(public\).pdf```
	* where `olddir.sh` is
```
#!/bin/sh
echo /Volumes/BACK-Sniffles/Backups.backupdb/haram/Latest/Macintosh\ HD/Users/alex/
```
	* ...but probably do this in perl as shell is breaky and macos likes to leave shitty chars/charsets hanging about.

* mudra
	* encapsulator
		* command-line tool that creates json for pushing to the mudra consumer [e.g., this goes to SQS]:
			* `$ encapsulator --privmsg=samantha --network freenode --content "this is a private message to samantha"`
			* `$ encapsulator --channel '##linux-offtopic' --network freenode --content "hallo there offtopic!"`
		* would also be nice if it supported heredocs
		* what does a return to the shell look like from this? in theory the server moans if something is bork. need to display to user.
			* or maybe not, just use a `--verbose` if you care?
	* using encapsulator, it should be possible to push to twitter via bitlbee from the shell
	* publisher
		* obviously, this is the part of mudra that interfaces with the server
		* this should be a daemon with very little interaction with the user
		* should have something like `pubctl --connect hostname`, `pubctl --list-networks`, `pubctl --change-nick foo --network`, and so on
			* probably, pubctl should use the message queue

* a tool to email arbitrary files from the shell
	* `$ mailfile --comment 'hi rod, here's the resume you asked for' --subject 'resume, jane avriette' --file Documents/Resume.pdf`

* a tiny window with a quick reference of key shortcuts
	* tmux
	* emacs
	* the idea here being it would hover around the edge or bottom of the screen, unobtrusive, like a minimized sticky and be e.g., 9pt or smaller monaco
		* [Doing this right now instead. :(](http://puu.sh/5V6wt.png)

* command line tool to paste to puu.sh or to push images
	* `$ puu.sh file.txt`
		* returns uri
	* `$ puu.sh << EOF`
		* creates a new (ostensibly hashish?) filename, pushes, returns uri
	* `$ puu.sh ls`
		* shows 'galleries' on puu.sh such that one can find the uris for items in puu.sh

* a tmux config that connects to all the little remote processes in their own special windows
	* separate windows for asuka, katsuragi, irssi, etc
	* probably use mosh but ostensibly could also borrow the persistent ssh connection from ControlMaster/ControlPath ssh config
	* this allows me to reboot haram as often as i like and not have to rejigger the terminal windows i'm using

* does facebook have an RSS feed or similar that i can pull those notifies from so that i don't have to keep a window open in chrome?
	* easy enough to put this in tmux and/or irssi with encapsulator
