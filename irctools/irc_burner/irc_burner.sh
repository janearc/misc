#!/bin/sh

# Spin up disposable node in ec2 for IRC usage. Destroyed upon exit
# of irssi.
#
# Jane Avriette 2014. Please don't use this for evil.

DEBUG=1

export SERVER=$1
export NICK=$2

# pick a region, any region
export AWS_DEFAULT_REGION=$(perl -MList::Util=shuffle -e 'print pop @{ [ shuffle @ARGV ] }, qq/\n/' `aws ec2 describe-regions | grep RegionName | awk '{ print $2 }' | sed 's/"//g'`)
export AMAZON_DERP_DELAY=15
export UBUNTU_DERP_DELAY=30
export MY_NAME=`whoami` # not portable to everywhere

# You'd change these to reflect the subnet and mask you would use for you.
export MY_HOME=173.8.15.238
export MY_MASK=32

# You would change this to the location of your key (I only have the public
# key, and have used my key so I can verify my work)
SSH_KEY=~/.ssh/id_rsa

# Debugging utility
log () {
	# If this annoys, just swap this to logger(1)
	[[ $DEBUG ]] && print_stderr $*
}
print_stderr () {
	# works on the darwins and linuxes. not sure about the other bsds or solaris.
	echo $0[$$]: $* > /dev/stderr
}

# Shouldn't really be necessary.
# set -x
UBUNTU_LTS_AMI_ID=$(aws ec2 describe-images --filters "Name=name,Values=ubuntu/images/ebs/ubuntu-trusty-14.04-i386-server-20140416.1" | grep ImageId | awk '{ print $2 }' | sed 's/"//g' | cut -d, -f 1)

log "creating keypair"
aws ec2 import-key-pair \
	--key-name ${MY_NAME}_key \
	--public-key-material "$(cat ${SSH_KEY}.pub)"

log "creating security group"
aws ec2 create-security-group \
	--group-name ssh_22_inbound_irc_burner \
	--description "port 22 inbound is open"

log "creating security group port 22 inbound rule"
aws ec2 authorize-security-group-ingress \
	--group-name ssh_22_inbound_irc_burner \
	--protocol tcp \
	--port 22 \
	--cidr ${MY_HOME}/${MY_MASK}

log "spinning up new instance ($UBUNTU_LTS_AMI_ID, $AWS_DEFAULT_REGION)"
aws ec2 run-instances \
	--image-id $UBUNTU_LTS_AMI_ID \
	--key-name ${MY_NAME}_key \
	--instance-type t1.micro \
	--region $AWS_DEFAULT_REGION \
	--security-groups ssh_22_inbound_irc_burner | grep InstanceId | awk '{ print $2 }' | cut -d \" -f 2 | while read instance_id ; do
		log "sleeping ${AMAZON_DERP_DELAY}s to let amazon settle a bit"
		sleep $AMAZON_DERP_DELAY
		log "pulling public dns info from instance id ${instance_id} in $AWS_DEFAULT_REGION..."
		aws ec2 describe-instances --instance-ids $instance_id | grep PublicDnsName | awk '{ print $2 }' | cut -d \" -f 2 | while read public_hostname ; do
			log "sleeping ${UBUNTU_DERP_DELAY}s to let ubuntu settle a bit"
			sleep $UBUNTU_DERP_DELAY
			log "shelling into ${public_hostname} to install irssi & vim"
			THIS_SSH="ssh -ti $SSH_KEY -o StrictHostKeyChecking=no -o UserKnownHostsFile=/dev/null"
			$THIS_SSH ubuntu@${public_hostname} 'sudo apt-get -y install irssi irssi-scripts vim-scripts'
			log "shelling into ${public_hostname} to run irssi against $SERVER ($NICK)"
			tmux -2uc "$THIS_SSH ubuntu@${public_hostname} \"irssi -c ${SERVER} -n ${NICK}\""
		done # public_hostname
		log "looks like instance-id ${instance_id} is done. cleaning up."
		aws ec2 terminate-instances --instance-ids $instance_id
	done # instance_id

### END
##
#
# log https://www.youtube.com/watch?v=gBzJGckMYO4
exit 0;

# jane@cpan.org // vim:tw=78:ts=2:noet
