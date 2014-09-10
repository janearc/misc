/* 

	test case to demonstrate difference between shell's version of `describeInstances` and javascript's.

*/

// Load the AWS SDK for Node.js & grab an ec2 interface
//
var AWS = require('aws-sdk');
var ec2 = new AWS.EC2(
	{
		region: 'us-east-1'  // per @mhart at https://github.com/aws/aws-sdk-js/issues/350
	}
);

// This is just used to generate a noncely thing for nodename
//
var launch_params = {
	KeyName                           : 'jane-fetch-aws-root',
	ImageId                           : 'ami-020bc76a',
	DisableApiTermination             : false,
	InstanceType                      : 't1.micro',
	EbsOptimized                      : false,
	InstanceInitiatedShutdownBehavior : 'terminate',
	Monitoring                        : { Enabled : false },
	MinCount                          : 1,
	MaxCount                          : 1,
	Placement                         : { AvailabilityZone : 'us-east-1a' },
	DryRun                            : false,

	NetworkInterfaces : [
		{
			Groups                          : [ 'sg-d5f1a7b0', 'sg-5ca8f939' ],
			SubnetId                        : 'subnet-bd4d85ca',
			AssociatePublicIpAddress        : true,
			DeleteOnTermination             : true,
			Description                     : 'describeInstances-test',
			DeviceIndex                     : 0,
			SecondaryPrivateIpAddressCount  : 1
		},
	], // NetworkInterfaces

}; // params for runInstances


ec2.runInstances( launch_params, function(ri_err, data) {
	if (ri_err) {
		callback( ri_err, ri_err.stack );
	}
	else { 
		ec2.describeInstances( { InstanceIds : [ data.Instances[0].InstanceId ] }, function ( di_err, di_data ) {
			if (di_err) {
				console.log( di_err, di_err.stack );
			}
			else {
				var reservation_zero = di_data.Reservations[0];
				var instance_zero    = reservation_zero.Instances[0];

				console.log( instance_zero );
				console.log( 'please execute ' + 'aws ec2 describe-instances --instance-ids ' + instance_zero.InstanceId );
			}
		} ); // describeInstances
	} // if runInstances error
} ); // runInstances
