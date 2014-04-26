#!/bin/sh

set -x

# determine latest ubuntu lts ami id

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
NOTES
# back to executing, but this is the end.
