// test case for nopt-usage concatenation
//
var nopt = require('nopt')
	, noptUsage = require('nopt-usage')
	, Stream    = require('stream').Stream
	, path      = require('path')
	, knownOpts = {
			'column_a'   : [ Boolean, null ],
			'column_b'   : [ Boolean, null ]
		}
	, description = {
			'column_a'   : 'A column about a',
			'column_b'   : 'A column about b'
		}
	, defaults = {
			'column_a'   : true,
			'column_a'   : true
		}
	, shortHands = {
			'a'          : [ '--column_a' ],
			'ca'         : [ '--column_a' ]
		}
	, parsed = nopt(knownOpts, process.argv)
	, usage = noptUsage(knownOpts, shortHands, description, defaults)

if (parsed['help']) {
	// Be halpful
	//
	console.log( 'Usage: ' );
	console.log( usage );
	process.exit(0); // success
}
