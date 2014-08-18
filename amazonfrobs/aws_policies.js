// Load the AWS SDK for Node.js
var AWS = require('aws-sdk');
AWS.config.region = 'us-east-1';

var iam = new AWS.IAM();

// just give me all the things pls
var ls_group_params = { };

iam.listGroups( ls_group_params, function( err, groups ) {
	if (err) console.log(err, err.stack); // oops
	else {
		for (groupindex in groups.Groups) {
			// at this point we ask it to 
			//     aws iam list-group-policies --group-name
			// http://docs.aws.amazon.com/AWSJavaScriptSDK/latest/AWS/IAM.html#listGroupPolicies-property
			//
			// without additional limits (marker, maxitems), this is just going to ask for 
			// all the things.
			//
			var ls_group_policy_params = {
				GroupName: groups.Groups[groupindex].GroupName
			};

			// console.log( "checking group policies for " + params.GroupName );
			iam.listGroupPolicies(ls_group_policy_params, function( err, policies ) {
				if (err) console.log(err, err.stack); // oops
				else {
					for (policynameindex in policies.PolicyNames) {
						// and then we need to ask it to
						//     aws iam get-group-policy --policy-name beeboop --group-name blarp
						// http://docs.aws.amazon.com/AWSJavaScriptSDK/latest/AWS/IAM.html#getGroupPolicy-property
						//
						// so elsewhere the data returned is a dictionary or an array. but what they give
						// us from listGroupPolicies is an object, which has methods: PolicyNames IsTruncated Marker
						// because amazon loves us so.
						//
						var enumerate_policy_params = { // nomenclature here is tricky with the API re-using list_group_noun
							GroupName: groups.Groups[groupindex].GroupName,
							PolicyName: policies.PolicyNames[policynameindex]
						};
						iam.getGroupPolicy( enumerate_policy_params, function( err, policydata ) {
							// So the return here is a uri-encoded string. If we unescape() this, we get [object Object]. Okay, then.
							data = unescape( policydata );
							decoded_data = decodeURIComponent( policydata );
							console.log( "the object: " + decoded_data );
							this_group  = data.GroupName;
							this_policy = data.PolicyName;
							this_doc    = data.PolicyDocument;
							console.log( "request id: " + data.ResponseMetadata );
							console.log( "group name: " + this_group );
							console.log( "policy name: " + this_policy );
							console.log( "- - -" );
							console.log( this_doc );
							console.log( "- - -" );
						} ); // getGroupPolicy (group name, policy name)
					} // policy index iterator (for)
				} // else
			} ); // list group policies
		} // group index iterator (for)
	} // else
} ); // list groups callback
