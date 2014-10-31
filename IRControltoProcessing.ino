/*
 * IRremote: IRrelevador_processing - Control de Relevadores y pantalla de processing
 * An IR detector/demodulator must be connected to the input RECV_PIN.
 * Version 0 Oct, 2014
 * 
 */
 
 
#include <IRremote.h>

//Variables para el receptor

int RECV_PIN = 11;  //Indicamos que usaremos el PIN11
IRrecv irrecv(RECV_PIN); //Especificamos que el PIN 11 sera usado por IRremote
decode_results results; //Declaramos el uso de un decodificador para los resultados

//Variables para el uso del relevadores
int RELAY_PIN = 4;   //Especificamos que usaremos el PIN4 

// Podemos especificar cuantos pines queramos usar para controlar relevadores 



void setup()
{
 pinMode(RELAY_PIN, OUTPUT);  //Establecemos que RELAY_PIN sera una salida
  pinMode(13, OUTPUT);        //Establecemos que el PIN13 sera una salida, este pin es un led integrado en la placa
  
  
  Serial.begin(9600);
  irrecv.enableIRIn(); // Inicializamos el receptor
}

int on = 0;  //Esta variable abrira o cerrara el relevador

void loop() {
//Si recibimos informacion por el serial y es codificada entonces:
  if (irrecv.decode(&results)) {
      Serial.println(results.value, DEC); //Manda el valor por el puerto serial
   
    //Si el valor codificado que recibimos es igual a un valor que establecemos entonces:
    if (results.value==2887){
      on = !on; //esto significa que si on=0 cambiara a on=1 y viceverza
      digitalWrite(13, on ? HIGH : LOW);  //Preguntamos al PIN13 el estado y lo cambia
      digitalWrite(RELAY_PIN, on ? HIGH : LOW); //Preguna a RELAY_PIN (PIN 4) el estado y lo cambia
      
       }
    irrecv.resume(); // Receive the next value    
  }
  delay(100); //Espera 100 microsegundos para volver a hacerlo
  
}
