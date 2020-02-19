var BCSLA = artifacts.require("BCSLA");

function randomIntInc (low, high) {
    return Math.floor(Math.random() * (high - low + 1) + low);
}

var iterations = 100;
var metrics = [];
for(var i=0;i<iterations;i++) {
    var m1 = randomIntInc(92,98);
    var m2 = randomIntInc(82,98);
    if ( i > 20 && i < 80 ) {
	m1 = m1-20;
	m2 = m2-20;
    }
    if ( i > 60 && i < 80 ) {
	m2 = m2-20;
    }
    metrics.push([m1, m2, 1, 1]);
}
var current_metric = 0;

function postMetrics(instance, operator, customer) {
    if ( current_metric <= 999 ) {
	var log = current_metric + "\t" + metrics[current_metric][0] + "\t" + metrics[current_metric][1] + "\t";
	log += web3.eth.getBalance(operator)/1.0e18 + "\t" + web3.eth.getBalance(customer)/1.0e18;
	console.log(log);
	instance.postMetrics(
	    metrics[current_metric][0],
	    {from: operator,
	     value: web3.toWei(metrics[current_metric][2], "ether")}).then(
		 function() {
		     instance.postMetrics(
			 metrics[current_metric][1],
			 {from: customer,
			  value: web3.toWei(metrics[current_metric][2], "ether")}).then(
			      function() {
				  current_metric = current_metric+1;
				  postMetrics(instance, operator, customer);
			      });
		 });
    }
}

module.exports = function(callback) {
    var operator = web3.eth.accounts[0];
    var customer = web3.eth.accounts[1];
    var bcsla = BCSLA.deployed().then(
	function(instance) {
	    console.log(instance.address);
	    instance.registerAsACustomer({from: customer}).then(
		function(value) {
		    postMetrics(instance, operator, customer);
		});
	});
}
