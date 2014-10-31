/**
 * IRControlfromArduino
 * 
 * Lee datos desde el serial y cambia de color un rectangulo
 * Los datos que envia el arduino son codigos de un control remoto IR.
  */


import processing.serial.*;

Serial myPort;  // Creas un objeto de Serial Class

int lf = 10;                                      // Linefeed (fin de linea) en ASCII
String myString = null;                           ///Cadena (string) enviada por el Arduino
float num;                                        //Para comprobar el numero que recibimos en la terminal

void setup() 
{
  size(200, 200);                                 //Tamaño de la pantalla
  background(255);                               // Fondo Blanco
  
  println(Serial.list());                      //Muestra todos los puertos COM disponibles
  String portName = Serial.list()[1];          //Se selecciona el puerto COM a utilizar por el programa
                                               //recuerda que es un arreglo asi que el primer puerto es [0], el segundo [1] .....
                                              //El puerto seleccionado debe de coincidir con el usado por el Arduino
 
  myPort = new Serial(this, portName, 9600); //Parametros de la comunicacion serial 
                                            //El ultimo numero debe de coincidir con la velocidad de transmision del arduino
  myPort.clear();                           //Limpia el puerto serial
}

void draw()
{
 // Si existen datos en el puerto serial,
  if ( myPort.available() > 0) {  
    myString = myPort.readStringUntil(lf); // Almacena los datos hasta que exista un fin de linea
  //Si existe informacion en el puerto entonces:
    if (myString != null) {
      println(myString);        // Imprime lo que hay en el puerto
      num= float(myString);     // Convierte esa informacion en flotante
      println(num);            //Imprime el numero flotante
    }
 
  if (num ==2887) {              // Si el valor del puerto serial es igual a algun valor definido,
    fill(0,0,255);                   // Seleccionas el azul
  } 
  if (num == 527175) {              // Si el valor del puerto serial es igual a otro valor definido,
    fill(0,255,0);                   // set fill to verde
  } 
  
  rect(50, 50, 100, 100);  //Dibuja un rectangulo con el color definido arriba
  }
  myPort.clear();         //Limpia el puerto serial
  
}
