#!/bin/sh

export AWS_DEFAULT_REGION=us-east-1 # maybe change this later to -1d if there's a way.
DEBUG=1

# Debugging utility
log () {
	[[ $DEBUG ]] && print_stderr $*
}
print_stderr () {
	echo warn $0[$$] \"$*\" | perl
}

set -x

## Task 1
# determine latest ubuntu lts ami id

#  So, as it happens, the schema returned by aws ec2 describe-images doesn't
#  actually include the date the ami was created, any specific keys re the OS
#  version, and the naming ontology is really poor (it's all freeform rather
#  than organised in any way). Therefore it would seem to not be
#  programmatically possible to 'ascertain' the latest-n-greatest e.g., ubuntu
#  LTS image. So we hard-code this here.
UBUNTU_LTS_AMI_ID="ami-358c955c" # note this is 32-bit
aws ec2 describe-images --image-ids $UBUNTU_LTS_AMI_ID


## Task 2
# use public key from:
#  https://s3.amazonaws.com/optoro-corp/opsrsrc/id_rsa.pub
# for 'ubuntu' user

# launch an m1.small instance

# install this file:
#   https://s3.amazonaws.com/optoro-corp/opsrsrc/optoro
# into /usr/local/bin/optoro

# execute that file


### END
##
#
exit 0;

# This is basically just a multiline comment.
NOTES=<<NOTES

# For some reason awscli will not allow me to use us-east-1d, but us-east
# works. I assume that this throws it into one of us-east-1{a,b,c,d}, but
# that's mildly annoying if it doesn't allow me to specify a specifici
# sub-region for the node.
haram:joshsz jane$ aws ec2 describe-images
Service ec2 not available in region us-east-1d
haram:joshsz jane$ AWS_DEFAULT_REGION=us-east-1 aws ec2 describe-regions
{
    "Regions": [
        {
            "Endpoint": "ec2.eu-west-1.amazonaws.com", 
            "RegionName": "eu-west-1"
        }, 
        {
            "Endpoint": "ec2.sa-east-1.amazonaws.com", 
            "RegionName": "sa-east-1"
        }, 
        {
            "Endpoint": "ec2.us-east-1.amazonaws.com", 
            "RegionName": "us-east-1"
        }, 
        {
            "Endpoint": "ec2.ap-northeast-1.amazonaws.com", 
            "RegionName": "ap-northeast-1"
        }, 
        {
            "Endpoint": "ec2.us-west-2.amazonaws.com", 
            "RegionName": "us-west-2"
        }, 
        {
            "Endpoint": "ec2.us-west-1.amazonaws.com", 
            "RegionName": "us-west-1"
        }, 
        {
            "Endpoint": "ec2.ap-southeast-1.amazonaws.com", 
            "RegionName": "ap-southeast-1"
        }, 
        {
            "Endpoint": "ec2.ap-southeast-2.amazonaws.com", 
            "RegionName": "ap-southeast-2"
        }
    ]
}

# It takes about one minute, fifteen seconds to pull down the list of images
# from ec2.
EXPECTED_FINISH=$(date -r `perl -le 'print time() + 75'`)
log "Grabbing list of AMIs, expecting to finish at ${EXPECTED_FINISH}"
aws ec2 describe-images | # your json parsing goes here.
NOTES
# back to executing, but this is the end.
# jane@cpan.org // vim:tw=78:ts=2:noet
