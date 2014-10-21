#!/bin/bash

SOURCE=$(curl -qq http://www.geobytes.com/iplocator.htm | grep 'IpAddress=' | cut -d= -f 4 | cut -d\" -f 1 | grep -E '^[0-9.]+$')

echo "adding ${SOURCE}/32 to sg-5ca8f939 <3"

aws ec2 authorize-security-group-ingress --group-id sg-5ca8f939 --protocol tcp --port 22 --cidr "${SOURCE}/32"
