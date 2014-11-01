// se importa la libreria de OPENNI
import SimpleOpenNI.*;

// Se declara un objeto del tipo SimpleOpenNI
SimpleOpenNI kinect;


/// Grados de libertad humanos

// Vectores de coordenadas del brazo izquierdo
//Coordenates vector for left arm
PVector lHand = new PVector();//para almacenar coordenadas x, y, z de la mano
PVector lElbow = new PVector();//para almacenar coordenadas x, y, z del codo
PVector lShoulder = new PVector();//para almacenar coordenadas x, y, z del hombro

// Vectores de coordenadas para la pierna izquierda
//Coordenates vector for left leg
PVector lFoot = new PVector(); //para almacenar coordenadas x, y, z para el pie
PVector lKnee = new PVector(); //para almacenar coordenadas x, y, z para la rodilla
PVector lHip = new PVector(); //para almacenar coordenadas x, y, z para la cadera

// Vectores de coordenadas para el brazo derecho
//Coordenates vector for right arm
PVector rHand = new PVector(); //para almacenar coordenadas x, y, z de la mano 
PVector rElbow = new PVector(); //para almacenar coordenadas x, y, z del codo
PVector rShoulder = new PVector(); //para almacenar coordenadas x, y, z del hombro

// Vectores de coordenadas para la pierna derecha
//Cordenates vector for right leg
PVector rFoot = new PVector(); //para almacenar coordenadas x, y, z para el pie
PVector rKnee = new PVector(); //para almacenar coordenadas x, y, z para la rodilla
PVector rHip = new PVector(); //para almacenar coordenadas x, y, z para la cadera


//Se declaran todos los grados de libertad  del usuario
//Declare all angles of human body
float[] angles= new float[9];

/////////////////////////////////////////////////////

public void setup() {
  // se inicializa el objeto kinect
  //Iniatializing kinect object
kinect = new SimpleOpenNI(this);
//se hace un reflejo de la imagen obtenida
//Mirror of image
kinect.setMirror(true);
// se habilita la camara de profundidad
//Enable depth camera
kinect.enableDepth();
//se habilita el skeleton tracking para el usuario
//Enable skeleton tracking
kinect.enableUser(SimpleOpenNI.SKEL_PROFILE_ALL);
// se establece el tamaño de la pantalla donde se mostrara la camara
//Size screen
size(kinect.depthWidth(), kinect.depthHeight());
}


//Aqui se hace el traking y se arrojan los resultado del calculo de angulos


public void draw() {
  
  //se actualizan los datos obtenidos del kinect
  //update kinect
  kinect.update();

//se muestra en pantalla la camara de profundidad depthImageMap
//draw depthImageMap
image(kinect.depthImage(), 0, 0);

//se muestra en pantalla el Skeleton si esta disponible
//draw the skeleton if it is available
if (kinect.isTrackingSkeleton(1)) {
  //se actualizan los angulos mediante el llamado de la funcion updateAngles()
  updateAngles();
  //se dibuja el skeleton
  drawSkeleton(1);
  }
}

//funcion para calcular los angulos
float angle(PVector a, PVector b, PVector c) {
float angle01 = atan2(a.y - b.y, a.x - b.x);
float angle02 = atan2(b.y - c.y, b.x - c.x);
float ang = angle02 - angle01;
return ang;
}

///Calculo de angulos
//Angle compute
void updateAngles() {
// se obtienen los posicion para la mano izquierdo
// Left Arm
kinect.getJointPositionSkeleton(1, SimpleOpenNI.SKEL_LEFT_HAND, lHand);
/// se imprimen en consola la posicion en x de la mano izquierda
//Print X position for left hand
println (lHand.x);
/// se imprimen en consola la posicion en y de la mano izquierda
//Print y position for left hand
println (lHand.y);
/// se imprimen en consola la posicion en z de la mano izquierda
//Print z position for left hand
println (lHand.z);
//se obtienen los angulos del codo izquierdo
kinect.getJointPositionSkeleton(1, SimpleOpenNI.SKEL_LEFT_ELBOW, lElbow);
//se obtienen los posicion del hombro izquierdo
kinect.getJointPositionSkeleton(1, SimpleOpenNI.SKEL_LEFT_SHOULDER, lShoulder);
// Obtencion de los posicion para la pierna izquierda
// Left Leg
kinect.getJointPositionSkeleton(1, SimpleOpenNI.SKEL_LEFT_FOOT, lFoot);
kinect.getJointPositionSkeleton(1, SimpleOpenNI.SKEL_LEFT_KNEE, lKnee);
kinect.getJointPositionSkeleton(1, SimpleOpenNI.SKEL_LEFT_HIP, lHip);
// Obtencion de posicion para el brazo derecho
// Right Arm
kinect.getJointPositionSkeleton(1, SimpleOpenNI.SKEL_RIGHT_HAND, rHand);
kinect.getJointPositionSkeleton(1, SimpleOpenNI.SKEL_RIGHT_ELBOW, rElbow);
kinect.getJointPositionSkeleton(1, SimpleOpenNI.SKEL_RIGHT_SHOULDER, rShoulder);
// Obtencion de posicion de la pierna derecha
// Right Leg
kinect.getJointPositionSkeleton(1, SimpleOpenNI.SKEL_RIGHT_FOOT, rFoot);
kinect.getJointPositionSkeleton(1, SimpleOpenNI.SKEL_RIGHT_KNEE, rKnee);
kinect.getJointPositionSkeleton(1, SimpleOpenNI.SKEL_RIGHT_HIP, rHip);


angles[0] = atan2(PVector.sub(rShoulder, lShoulder).z, 
  PVector.sub(rShoulder, lShoulder).x);

// conversion a coordenadas proyectivas
 // Convert to Projective
  kinect.convertRealWorldToProjective(rFoot, rFoot);
  kinect.convertRealWorldToProjective(rKnee, rKnee);
  kinect.convertRealWorldToProjective(rHip, rHip);
  kinect.convertRealWorldToProjective(lFoot, lFoot);
  kinect.convertRealWorldToProjective(lKnee, lKnee);
  kinect.convertRealWorldToProjective(lHip, lHip);
  kinect.convertRealWorldToProjective(lHand, lHand);
  kinect.convertRealWorldToProjective(lElbow, lElbow);
  kinect.convertRealWorldToProjective(lShoulder, lShoulder);
  kinect.convertRealWorldToProjective(rHand, rHand);
  kinect.convertRealWorldToProjective(rElbow, rElbow);
  kinect.convertRealWorldToProjective(rShoulder, rShoulder);
// obtencion de angulos del lado izquierdo
  // Left-Side Angles
  angles[1] = angle(lShoulder, lElbow, lHand);
  angles[2] = angle(rShoulder, lShoulder, lElbow);
  angles[3] = angle(lHip, lKnee, lFoot);
  angles[4] = angle(new PVector(lHip.x, 0), lHip, lKnee);
   // obtencion de angulos del lado derecho
  // Right-Side Angles
  angles[5] = angle(rHand, rElbow, rShoulder);
  angles[6] = angle(rElbow, rShoulder, lShoulder );
  angles[7] = angle(rFoot, rKnee, rHip);
  angles[8] = angle(rKnee, rHip, new PVector(rHip.x, 0));

}


///Se dibuja el Skeleton en pantalla
//Draw skeleton on screen
void drawSkeleton(int userId) {
// con pushStyle se abre el dibujar varias lineas e integrarlas en un solo cuerpo
pushStyle();
//Se especifica el color de la lina de esqueletizacion
stroke(255,0,0);
//se especifica el grueso de la linea
strokeWeight(3);
//se dibuja cada una de las extremidades
kinect.drawLimb(userId, SimpleOpenNI.SKEL_HEAD, SimpleOpenNI.SKEL_NECK);
kinect.drawLimb(userId, SimpleOpenNI.SKEL_NECK, SimpleOpenNI.SKEL_LEFT_SHOULDER);
kinect.drawLimb(userId, SimpleOpenNI.SKEL_LEFT_SHOULDER, SimpleOpenNI.SKEL_LEFT_ELBOW);
kinect.drawLimb(userId, SimpleOpenNI.SKEL_LEFT_ELBOW, SimpleOpenNI.SKEL_LEFT_HAND);
kinect.drawLimb(userId, SimpleOpenNI.SKEL_NECK, SimpleOpenNI.SKEL_RIGHT_SHOULDER);
kinect.drawLimb(userId, SimpleOpenNI.SKEL_RIGHT_SHOULDER, SimpleOpenNI.SKEL_RIGHT_ELBOW);
kinect.drawLimb(userId, SimpleOpenNI.SKEL_RIGHT_ELBOW, SimpleOpenNI.SKEL_RIGHT_HAND);
kinect.drawLimb(userId, SimpleOpenNI.SKEL_LEFT_SHOULDER, SimpleOpenNI.SKEL_TORSO);
kinect.drawLimb(userId, SimpleOpenNI.SKEL_RIGHT_SHOULDER, SimpleOpenNI.SKEL_TORSO);
kinect.drawLimb(userId, SimpleOpenNI.SKEL_TORSO, SimpleOpenNI.SKEL_LEFT_HIP);
kinect.drawLimb(userId, SimpleOpenNI.SKEL_LEFT_HIP, SimpleOpenNI.SKEL_LEFT_KNEE);
kinect.drawLimb(userId, SimpleOpenNI.SKEL_LEFT_KNEE, SimpleOpenNI.SKEL_LEFT_FOOT);
kinect.drawLimb(userId, SimpleOpenNI.SKEL_TORSO, SimpleOpenNI.SKEL_RIGHT_HIP);
kinect.drawLimb(userId, SimpleOpenNI.SKEL_RIGHT_HIP, SimpleOpenNI.SKEL_RIGHT_KNEE);
kinect.drawLimb(userId, SimpleOpenNI.SKEL_RIGHT_KNEE, SimpleOpenNI.SKEL_RIGHT_FOOT);
//se cierra pushStyle con popStyle
popStyle();

}


//deteccion de un nuevo usuario, sin calibrar aun el esqueleto
public void onNewUser(int userId) {
println("onNewUser - userId: " + userId);
if (kinect.isTrackingSkeleton(1)) return;
println(" start pose detection");
kinect.startPoseDetection("Psi", userId);
}


//Cuando el usuario se pierde
public void onLostUser(int userId) {
println("onLostUser - userId: " + userId);
}

//Cuando se ha detectado una pose se puede deterner la deteccion de poses y se procede a la calibracion con NITE

public void onStartPose(String pose, int userId) {
println("onStartPose - userId: " + userId + ", pose: " + pose);
println(" stop pose detection");
kinect.stopPoseDetection(userId);
kinect.requestCalibrationSkeleton(userId, true);
}


//Mostrar mensajes cuando la pose se ha finalizado y cuando la calibracion ha sido iniciada

public void onEndPose(String pose, int userId) {
println("onEndPose - userId: " + userId + ", pose: " + pose);
}
public void onStartCalibration(int userId) {
println("onStartCalibration - userId: " + userId);
}

//Si la calibracoin ha terminado exitosamente se inicia el seguimiento del esqueleto

public void onEndCalibration(int userId, boolean successfull) {
println("onEndCalibration - userId: " + userId + ", successfull: " + successfull);
if (successfull) {
println(" User calibrated !!!");
kinect.startTrackingSkeleton(userId);
}
else {
println(" Failed to calibrate user !!!");
println(" Start pose detection");
kinect.startPoseDetection("Psi", userId);
}

}


