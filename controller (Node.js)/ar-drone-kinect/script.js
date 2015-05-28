var arDrone = require('ar-drone');
var client  = arDrone.createClient();
var WebSocket = require('ws');




// VARIABLES

var isFlying = false;
var scaleFactor = 100; // depends on the distance between kinect and user

// end of VARIABLES





// SIMPLE DRONE FUNCTIONS

function takeOff() {
	client.takeoff(function(){
		isFlying = true;
		console.log('3, 2, 1, take off!');
	});
}

function land() {
	client.land(function(){
		isFlying = false;
		console.log('Eagle has landed.');
	});
}

// end of SIMPLE DRONE FUNCTIONS





// MOVE DRONE

function moveDrone(data) {

	var leftHip = data.leftHip;
	var rightHip = data.rightHip;
	var torso = data.torso;
	var leftShoulder = data.leftShoulder;
	var rightShoulder = data.rightShoulder;
	var leftHand = data.leftHand;
	var rightHand = data.rightHand;

	if (isFlying) {

		// x
		if ((leftShoulder.x + rightShoulder.x) / 2 > torso.x) {
			var speed = Math.abs((leftShoulder.x + rightShoulder.x) / 2 - torso.x) / scaleFactor;
			console.log('fly left: '+speed);
			client.left(speed);
		} else {
			var speed = Math.abs((leftShoulder.x + rightShoulder.x) / 2 - torso.x) / scaleFactor;
			console.log('fly right: '+speed);
			client.right(speed);
		}

		// y
		if ((leftHand.y + rightHand.y) / 2 > (leftShoulder.y + rightShoulder.y)) {
			var speed = Math.abs((leftHand.y + rightHand.y) / 2 - (leftShoulder.y + rightShoulder.y) / 2) / scaleFactor / 5;
			console.log('fly up: '+speed);
			client.up(speed);
		} else {
			var speed = Math.abs((leftHand.y + rightHand.y) / 2 - (leftShoulder.y + rightShoulder.y) / 2) / scaleFactor / 5;
			console.log('fly down: '+speed);
			client.down(speed);
		}

		// z
		if ((leftShoulder.z + rightShoulder.z) / 2 < torso.z) {
			var speed = Math.abs((leftShoulder.z + rightShoulder.z) / 2 - torso.z) / scaleFactor;
			client.front(speed);
			console.log('fly front: '+speed);
		} else {
			var speed = Math.abs((leftShoulder.z + rightShoulder.z) / 2 - torso.z) / scaleFactor;
			console.log('fly back: '+speed);
			client.back(speed);
		}

		if (leftHand.y < leftHip.y && rightHand.y < rightHip.y) {
			console.log('land drone!');
			land();
			isFlying = false;
		}

	} else { // take off

		if (leftHand.y > leftShoulder.y && rightHand.y > rightShoulder.y) {
			console.log('fly drone, fly!');
			takeOff();
		}

	}

}

// end of MOVE DRONE





// SOCKET

var ws = new WebSocket('ws://localhost:8080/p5websocket');
ws.on('message', function(data, flags) {
	if (data == 'user lost') {
		console.error('user lost -> emergency landing');
		land();
	} else if (data === 'new user') {
		console.info('new user');
	}
	else {
		var data = JSON.parse(data);
		moveDrone(data);
	}
});

// end of SOCKET





// DONE DATA

// client.on('navdata', console.log);

// end of DRONE DATA





// REPL (read–eval–print loop)

// client.createRepl();

// end of REPL





// DEBUGGING

// moveDrone({ "rightElbow": { "z": 845.9404907226562, "y": 332.1710510253906, "x": -432.98834228515625 }, "torso": { "z": 797.891845703125, "y": 371.8575744628906, "x": -458.5136413574219 }, "rightHand": { "z": 661.3878173828125, "y": 142.01609802246094, "x": -370.4496765136719 }, "leftFoot": { "z": 968.909423828125, "y": -504.53826904296875, "x": -609.001220703125 }, "neck": { "z": 789.4895629882812, "y": 526.2343139648438, "x": -328.4405517578125 }, "leftHand": { "z": 710.9053344726562, "y": 264.0702819824219, "x": -721.0201416015625 }, "leftKnee": { "z": 876.4747924804688, "y": -94.77410888671875, "x": -534.026123046875 }, "rightFoot": { "z": 953.0105590820312, "y": -618.7796630859375, "x": -331.250732421875 }, "leftElbow": { "z": 843.4883422851562, "y": 500.36737060546875, "x": -694.2785034179688 }, "rightFingertip": { "z": 795.3709716796875, "y": 763.57470703125, "x": -272.5212097167969 }, "leftHip": { "z": 835.6397094726562, "y": 283.09954833984375, "x": -664.570068359375 }, "rightHip": { "z": 776.9485473632812, "y": 151.8621368408203, "x": -512.6033935546875 }, "leftFingertip": { "z": 795.3709716796875, "y": 763.57470703125, "x": -272.5212097167969 }, "leftShoulder": { "z": 840.6744995117188, "y": 640.687255859375, "x": -460.9716491699219 }, "rightKnee": { "z": 913.9183959960938, "y": -230.17686462402344, "x": -419.4249267578125 }, "rightShoulder": { "z": 738.3046264648438, "y": 411.7813720703125, "x": -195.90945434570312 }, "head": { "z": 795.3709716796875, "y": 763.57470703125, "x": -272.5212097167969 } });

// end of DEBUGGING


