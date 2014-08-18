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

		for (groupnum in groups.Groups) {
			// at this point we ask it to 
			//     aws iam list-group-policies --group-name
			// http://docs.aws.amazon.com/AWSJavaScriptSDK/latest/AWS/IAM.html#listGroupPolicies-property
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
			// without additional limits (marker, maxitems), this is just going to ask for 
			// all the things.
			var params = {
				GroupName: groups.Groups[groupnum].GroupName
			};
			// console.log( group );
			// console.log("frobbing " + groups.Groups[groupnum]);
			iam.listGroupPolicies(params, function( err, policies ) {
				if (err) console.log(err, err.stack); // oops
				else {
					for (thispolicyname in policies.PolicyNames) {
						// and then we need to ask it to
						//     aws iam get-group-policy --policy-name beeboop --group-name blarp
						// http://docs.aws.amazon.com/AWSJavaScriptSDK/latest/AWS/IAM.html#getGroupPolicy-property
						//
						// so elsewhere the data returned is a dictionary or an array. but what they give
						// us from listGroupPolicies is an object, which has methods: PolicyNames IsTruncated Marker
						// because amazon loves us so.
						//
						console.log( "oh look at dis " + policies.PolicyNames );
						var params = {
							GroupName: groups.Groups[groupnum].GroupName
							// GroupName: groups.Groups[groupnum].GroupName,
							// PolicyName: policies[policynum].PolicyName
						};
						console.log( params );
						iam.getGroupPolicy( params, function( err, thesepolicies ) {
							// console.log(thesepolicies); // XXX: this is null. probably we need to check where we get this value.
						} ); // getGroupPolicy (groups, policies)

					} // policies
				}
			} );

		} // groups
	}
} );
