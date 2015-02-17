#!/bin/bash

# SOURCE=$(curl -qq http://www.geobytes.com/iplocator.htm | grep 'IpAddress=' | cut -d= -f 4 | cut -d\" -f 1 | grep -E '^[0-9.]+$')
SOURCE=$(curl ifconfig.me)
# Nick Muerdter: @jane: http://httpbin.org/ip or http://icanhazip.com (there are some differences in how they handle X-Forwarded-For headers, I believe.. httpbin acknowledges the header, icanhazip does not. But if you're just looking for your own IP, either should work)
# 14:11] Aidan Feldman: @jane: you can try http://ip.jsontest.com/ or http://fugal.net/ip.cgi or http://curlmyip.com/ (edited)

echo "adding ${SOURCE}/32 to sg-5ca8f939 <3"

aws ec2 authorize-security-group-ingress --group-id sg-5ca8f939 --protocol tcp --port 22 --cidr "${SOURCE}/32"
