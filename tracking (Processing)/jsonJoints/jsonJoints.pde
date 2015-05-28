/*
Send joints data as JSON via WebSockets

2015/05/26 by Tobias F. Wolf
tobiaswolf.me / github.com/tobiasfabian/
*/


import muthesius.net.*;
import org.webbitserver.*;

WebSocketP5 socket;
boolean     isServerStarted = false;


JSONObject json = new JSONObject();

void setup()
{

  // setup WebSocketP5
  if (!isServerStarted) {
    socket = new WebSocketP5(this, 8080);
    isServerStarted = true;
  }


  // setup SimpleOpenNI
  size(1024, 768, P3D);  // strange, get drawing error in the cameraFrustum if i use P3D, in opengl there is no problem
  context = new SimpleOpenNI(this);
  if (context.isInit() == false)
  {
    println("Can't init SimpleOpenNI, maybe the camera is not connected!"); 
    exit();
    return;
  }

  // disable mirror
  context.setMirror(false);

  // enable depthMap generation 
  context.enableDepth();

  // enable skeleton generation for all joints
  context.enableUser();

  stroke(255, 255, 255);
  smooth();  
  perspective(radians(45), 
  float(width)/float(height), 
  10, 150000);

}


float[] getPos(int userId, int jointType) {
  PVector jointPos = new PVector();
  float confidence;
  float[] result = new float[3];

  confidence = context.getJointPositionSkeleton(userId, jointType, jointPos);
  result[0] = jointPos.x;
  result[1] = jointPos.y;
  result[2] = jointPos.z;
  return result;
}

void getJoints(int userId) {
  JSONObject head = new JSONObject();
  head.setFloat("x", getPos(userId, SimpleOpenNI.SKEL_HEAD)[0]);
  head.setFloat("y", getPos(userId, SimpleOpenNI.SKEL_HEAD)[1]);
  head.setFloat("z", getPos(userId, SimpleOpenNI.SKEL_HEAD)[2]);
  json.setJSONObject("head", head);

  JSONObject leftElbow = new JSONObject();
  leftElbow.setFloat("x", getPos(userId, SimpleOpenNI.SKEL_LEFT_ELBOW)[0]);
  leftElbow.setFloat("y", getPos(userId, SimpleOpenNI.SKEL_LEFT_ELBOW)[1]);
  leftElbow.setFloat("z", getPos(userId, SimpleOpenNI.SKEL_LEFT_ELBOW)[2]);
  json.setJSONObject("leftElbow", leftElbow);

  JSONObject leftFingertip = new JSONObject();
  leftFingertip.setFloat("x", getPos(userId, SimpleOpenNI.SKEL_LEFT_FINGERTIP)[0]);
  leftFingertip.setFloat("y", getPos(userId, SimpleOpenNI.SKEL_LEFT_FINGERTIP)[1]);
  leftFingertip.setFloat("z", getPos(userId, SimpleOpenNI.SKEL_LEFT_FINGERTIP)[2]);
  json.setJSONObject("leftFingertip", leftFingertip);

  JSONObject leftFoot = new JSONObject();
  leftFoot.setFloat("x", getPos(userId, SimpleOpenNI.SKEL_LEFT_FOOT)[0]);
  leftFoot.setFloat("y", getPos(userId, SimpleOpenNI.SKEL_LEFT_FOOT)[1]);
  leftFoot.setFloat("z", getPos(userId, SimpleOpenNI.SKEL_LEFT_FOOT)[2]);
  json.setJSONObject("leftFoot", leftFoot);

  JSONObject leftHand = new JSONObject();
  leftHand.setFloat("x", getPos(userId, SimpleOpenNI.SKEL_LEFT_HAND)[0]);
  leftHand.setFloat("y", getPos(userId, SimpleOpenNI.SKEL_LEFT_HAND)[1]);
  leftHand.setFloat("z", getPos(userId, SimpleOpenNI.SKEL_LEFT_HAND)[2]);
  json.setJSONObject("leftHand", leftHand);

  JSONObject leftHip = new JSONObject();
  leftHip.setFloat("x", getPos(userId, SimpleOpenNI.SKEL_LEFT_HIP)[0]);
  leftHip.setFloat("y", getPos(userId, SimpleOpenNI.SKEL_LEFT_HIP)[1]);
  leftHip.setFloat("z", getPos(userId, SimpleOpenNI.SKEL_LEFT_HIP)[2]);
  json.setJSONObject("leftHip", leftHip);

  JSONObject leftKnee = new JSONObject();
  leftKnee.setFloat("x", getPos(userId, SimpleOpenNI.SKEL_LEFT_KNEE)[0]);
  leftKnee.setFloat("y", getPos(userId, SimpleOpenNI.SKEL_LEFT_KNEE)[1]);
  leftKnee.setFloat("z", getPos(userId, SimpleOpenNI.SKEL_LEFT_KNEE)[2]);
  json.setJSONObject("leftKnee", leftKnee);

  JSONObject leftShoulder = new JSONObject();
  leftShoulder.setFloat("x", getPos(userId, SimpleOpenNI.SKEL_LEFT_SHOULDER)[0]);
  leftShoulder.setFloat("y", getPos(userId, SimpleOpenNI.SKEL_LEFT_SHOULDER)[1]);
  leftShoulder.setFloat("z", getPos(userId, SimpleOpenNI.SKEL_LEFT_SHOULDER)[2]);
  json.setJSONObject("leftShoulder", leftShoulder);

  JSONObject neck = new JSONObject();
  neck.setFloat("x", getPos(userId, SimpleOpenNI.SKEL_NECK)[0]);
  neck.setFloat("y", getPos(userId, SimpleOpenNI.SKEL_NECK)[1]);
  neck.setFloat("z", getPos(userId, SimpleOpenNI.SKEL_NECK)[2]);
  json.setJSONObject("neck", neck);

  JSONObject rightElbow = new JSONObject();
  rightElbow.setFloat("x", getPos(userId, SimpleOpenNI.SKEL_RIGHT_ELBOW)[0]);
  rightElbow.setFloat("y", getPos(userId, SimpleOpenNI.SKEL_RIGHT_ELBOW)[1]);
  rightElbow.setFloat("z", getPos(userId, SimpleOpenNI.SKEL_RIGHT_ELBOW)[2]);
  json.setJSONObject("rightElbow", rightElbow);

  JSONObject rightFingertip = new JSONObject();
  rightFingertip.setFloat("x", getPos(userId, SimpleOpenNI.SKEL_RIGHT_FINGERTIP)[0]);
  rightFingertip.setFloat("y", getPos(userId, SimpleOpenNI.SKEL_RIGHT_FINGERTIP)[1]);
  rightFingertip.setFloat("z", getPos(userId, SimpleOpenNI.SKEL_RIGHT_FINGERTIP)[2]);
  json.setJSONObject("rightFingertip", rightFingertip);

  JSONObject rightFoot = new JSONObject();
  rightFoot.setFloat("x", getPos(userId, SimpleOpenNI.SKEL_RIGHT_FOOT)[0]);
  rightFoot.setFloat("y", getPos(userId, SimpleOpenNI.SKEL_RIGHT_FOOT)[1]);
  rightFoot.setFloat("z", getPos(userId, SimpleOpenNI.SKEL_RIGHT_FOOT)[2]);
  json.setJSONObject("rightFoot", rightFoot);

  JSONObject rightHand = new JSONObject();
  rightHand.setFloat("x", getPos(userId, SimpleOpenNI.SKEL_RIGHT_HAND)[0]);
  rightHand.setFloat("y", getPos(userId, SimpleOpenNI.SKEL_RIGHT_HAND)[1]);
  rightHand.setFloat("z", getPos(userId, SimpleOpenNI.SKEL_RIGHT_HAND)[2]);
  json.setJSONObject("rightHand", rightHand);

  JSONObject rightHip = new JSONObject();
  rightHip.setFloat("x", getPos(userId, SimpleOpenNI.SKEL_RIGHT_HIP)[0]);
  rightHip.setFloat("y", getPos(userId, SimpleOpenNI.SKEL_RIGHT_HIP)[1]);
  rightHip.setFloat("z", getPos(userId, SimpleOpenNI.SKEL_RIGHT_HIP)[2]);
  json.setJSONObject("rightHip", rightHip);

  JSONObject rightKnee = new JSONObject();
  rightKnee.setFloat("x", getPos(userId, SimpleOpenNI.SKEL_RIGHT_KNEE)[0]);
  rightKnee.setFloat("y", getPos(userId, SimpleOpenNI.SKEL_RIGHT_KNEE)[1]);
  rightKnee.setFloat("z", getPos(userId, SimpleOpenNI.SKEL_RIGHT_KNEE)[2]);
  json.setJSONObject("rightKnee", rightKnee);

  JSONObject rightShoulder = new JSONObject();
  rightShoulder.setFloat("x", getPos(userId, SimpleOpenNI.SKEL_RIGHT_SHOULDER)[0]);
  rightShoulder.setFloat("y", getPos(userId, SimpleOpenNI.SKEL_RIGHT_SHOULDER)[1]);
  rightShoulder.setFloat("z", getPos(userId, SimpleOpenNI.SKEL_RIGHT_SHOULDER)[2]);
  json.setJSONObject("rightShoulder", rightShoulder);

  JSONObject torso = new JSONObject();
  torso.setFloat("x", getPos(userId, SimpleOpenNI.SKEL_TORSO)[0]);
  torso.setFloat("y", getPos(userId, SimpleOpenNI.SKEL_TORSO)[1]);
  torso.setFloat("z", getPos(userId, SimpleOpenNI.SKEL_TORSO)[2]);
  json.setJSONObject("torso", torso);
}



// -----------------------------------------------------------------
// SimpleOpenNI user events

void onNewUser(SimpleOpenNI curContext, int userId)
{
  println("onNewUser - userId: " + userId);
  println("\tstart tracking skeleton");
  broadcastNewUser();

  context.startTrackingSkeleton(userId);
}

void onLostUser(SimpleOpenNI curContext, int userId)
{
  println("onLostUser - userId: " + userId);
  broadcastLostOfUser();
}

void onVisibleUser(SimpleOpenNI curContext, int userId)
{
  // println("onVisibleUser - userId: " + userId);
}




// WebSocketP5

void broadcastJSON () {
  socket.broadcast(json.toString());
}

void broadcastNewUser () {
  socket.broadcast("new user");
}

void broadcastLostOfUser () {
  socket.broadcast("user lost");
}

void websocketOnMessage(WebSocketConnection con, String msg) {
  println(msg);
}

void websocketOnOpen(WebSocketConnection con) {
  println("A client joined");
}

void websocketOnClosed(WebSocketConnection con) {
  println("A client left");
}

