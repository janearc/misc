// Load the AWS SDK for Node.js
var AWS = require('aws-sdk');
AWS.config.region = 'us-east-1';

var iam = new AWS.IAM();

// just give me all the things pls
var params = { };

iam.listGroups( params, function( err, groups ) {
	if (err) console.log(err, err.stack); // oops
	else {
		// console.log(data); // great success

		/* so data looks like this:
	
	   [ { Path: '/',
	       GroupName: 'NNN',
	       GroupId: 'AXXXXXXXXXXXXXXXXXXXI',
	       Arn: 'arn:aws:iam::1NNNNNNNNNN3:group/NNN',
	       CreateDate: Mon Sep 30 2013 13:35:02 GMT-0400 (EDT) }, ]
	
		*/	

		for (group in groups) {
			// at this point we ask it to 
			//     aws iam list-group-policies --group-name
			// which should return to us:
			/*
				{
				    "PolicyNames": [
				        "NNNNNNNN", 
				        "NNNNNNNN", 
				        "NNNNNNNN", 
				        "NNNNNNNN"
				    ]
				}
			*/
			for (policy in policies) {
				// and then we need to ask it to
				//     aws iam get-group-policy --policy-name beeboop --group-name blarp
				/* 
					{
					    "GroupName": "NNNN", 
					    "PolicyDocument": {
					        "Version": "2012-10-17", 
					        "Statement": [
					            {
					                "NotAction": "iam:*", 
					                "Resource": "*", 
					                "Effect": "Allow"
					            }
					        ]
					    }, 
					    "PolicyName": "NNNN"
					}
				*/
			}
		} 
} );
