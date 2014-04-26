#!/bin/sh

export AWS_DEFAULT_REGION=us-east-1
export AWS_AVAILABILITY_ZONE=us-east-1d
export AMAZON_DERP_DELAY=15
export UBUNTU_DERP_DELAY=60
DEBUG=1
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

# set -x

## Task 1
# determine latest ubuntu lts ami id

#  So, as it happens, the schema returned by aws ec2 describe-images doesn't
#  actually include the date the ami was created, any specific keys re the OS
#  version, and the naming ontology is really poor (it's all freeform rather
#  than organised in any way). Therefore it would seem to not be
#  programmatically possible to 'ascertain' the latest-n-greatest e.g., ubuntu
#  LTS image. So we hard-code this here.
UBUNTU_LTS_AMI_ID="ami-358c955c" # note this is 32-bit

## Task 3
# launch an m1.small instance

log "creating keypair"
aws ec2 import-key-pair \
	--key-name jane_key \
	--public-key-material "$(cat ${SSH_KEY}.pub)"

log "creating security group"
aws ec2 create-security-group \
	--group-name optoro_ssh_22_inbound \
	--description "port 22 inbound is open"

log "creating security group port 22 inbound rule"
aws ec2 authorize-security-group-ingress \
	--group-name optoro_ssh_22_inbound \
	--protocol tcp \
	--port 22 \
	--cidr 173.8.15.238/32  # that's home

log "spinning up new instance"
aws ec2 run-instances \
	--image-id ami-358c955c \
	--key-name jane_key \
	--instance-type m1.small \
	--placement AvailabilityZone=$AWS_AVAILABILITY_ZONE \
	--security-groups optoro_ssh_22_inbound | grep InstanceId | awk '{ print $2 }' | cut -d \" -f 2 | while read instance_id ; do
		log "sleeping ${AMAZON_DERP_DELAY}s to let amazon settle a bit"
		sleep $AMAZON_DERP_DELAY
		log "pulling public dns info from instance id ${instance_id}"
		aws ec2 describe-instances --instance-ids $instance_id | grep PublicDnsName | awk '{ print $2 }' | cut -d \" -f 2 | while read public_hostname ; do
			log "sleeping ${UBUNTU_DERP_DELAY}s to let ubuntu settle a bit"
			sleep $UBUNTU_DERP_DELAY
			log "shelling into ${public_hostname} to frob, chmod, and execute"
			THIS_SSH="ssh -ti $SSH_KEY -o StrictHostKeyChecking=no -o UserKnownHostsFile=/dev/null"
			$THIS_SSH ubuntu@${public_hostname} 'curl https://s3.amazonaws.com/optoro-corp/opsrsrc/optoro | sudo dd of=/usr/local/bin/optoro'
			$THIS_SSH ubuntu@${public_hostname} 'sudo chmod 755 /usr/local/bin/optoro'
			# we assume this is safe to run as root. seems kinda necessary, right?
			$THIS_SSH ubuntu@${public_hostname} 'sudo /usr/local/bin/optoro'
		done # public_hostname
	done # instance_id


### END
##
#
# log https://www.youtube.com/watch?v=gBzJGckMYO4
exit 0;

# jane@cpan.org // vim:tw=78:ts=2:noet
