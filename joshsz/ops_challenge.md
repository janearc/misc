# Optoro Ops Project

Hello!

To get a better understanding of your automation ability, I'd like you to write a script that will build and configure a server in Amazon's EC2.

You can write this script using any language or tools you like. We somewhat prefer Chef or Puppet, but we'll accept anything that gets the job done.

The script should:
* launch a m1.small instance in the us-east-1d zone using the latest Ubuntu LTS AMI. 
* automatically provision this new instance with [my public key](https://s3.amazonaws.com/optoro-corp/opsrsrc/id_rsa.pub) on the 'ubuntu' user account
* install [this file](https://s3.amazonaws.com/optoro-corp/opsrsrc/optoro) to `/usr/local/bin/optoro`
* execute that `optoro` file

Contact me (jszmajda@optoro.com) for credentials to use to create the EC2 instances.

Please email me the script and leave the instance running when you're finished.

For bonus points, tell me what that `optoro` binary does!