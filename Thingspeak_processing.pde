/**
 * Tests the thinkspeak channel by sending any numeric 
 * keypress using the specified APIKEY and FIELD
 */

import processing.serial.*;
import processing.net.*;

//CONFIGURATION
String APIKEY = "YOURAPI"; //your api key
String FIELD = "field1";
int PORTNUM = 0; //port number of your arduino
//END CONFIGURATION

Serial arduino;
Client c;
String data;
int number; //read from arduino

void setup() {
  size(600, 400);

  //setup the serial port
  // List all the available serial ports:
  println(Serial.list());
  //Init the Serial object
  arduino = new Serial(this, Serial.list()[PORTNUM], 9600);

 
}

void draw() {
  background(50);
  fill(255);
  text("ThinkSpeak Processor", 10, 20);

  fill(0, 255, 0);
  text("Temperature Value Read:  " + number, 10, 40);

  if( data != null ) {
    fill(0, 255, 0);
    text("Server Response:", 10, 60);
    fill(200);
    text(data, 10, 80);
  }
  if(c != null) {
    if (c.available() > 0) { // If there's incoming data from the client...
      data = c.readString(); // ...then grab it
      println(data);
    }
  }

  //if we have a new line from our arduino, then send it to the server
  String ln;
  if( (ln = arduino.readStringUntil('\n')) != null) {
    try {
      number = new Integer(trim(ln));
      if(number < 1025) {
        println("Writing " + number);
        sendNumber(number);
      }
    }
    catch(Exception ex) {
    }
  }
}

void sendNumber(float num) {
  c = new Client(this, "api.thingspeak.com", 80); // Connect to server on port 80
  c.write("GET /update?key="+APIKEY+"&"+FIELD+"=" + num + " HTTP/1.1\n");
  c.write("Host: my_domain_name.com\n\n"); // Be polite and say who we are
}
