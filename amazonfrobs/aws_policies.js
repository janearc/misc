// Load the AWS SDK for Node.js
var AWS = require('aws-sdk');
AWS.config.region = 'us-east-1';

var iam = new AWS.IAM();

// just give me all the things pls
var params = { };

iam.listGroups( params, function( err, data ) {
	if (err) console.log(err, err.stack); // oops
	else console.log(data); // great success
} );
