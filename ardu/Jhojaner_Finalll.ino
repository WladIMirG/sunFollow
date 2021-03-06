                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                #include <SD.h>
#include <SPI.h>
#include <Servo.h>

#include <Wire.h>
#include "RTClib.h"
#include <LiquidCrystal_I2C.h>

int cspin = 4;
int cont = 6;
int sec = 00;
int f;
int puntos = 100;
int tiempo = 100;
int dia;
int mes;
int anho;
float tao;
float tmin;  
float s;
String linea = "";
String ms;
String ele_anterior = "0";
String asi_anterior = "0";

File Archivo;
LiquidCrystal_I2C lcd( 0x3F, 20,4);
RTC_DS1307 RTC;
DateTime nw;

Servo servo1;
Servo servo2;

void setup() {
  Wire.begin();// Inicia el puerto I2C
  RTC.begin(); // Inicia la comuncación con el RTC
  Serial.begin(9600);
  pinMode(7, OUTPUT);    //Tierra al motor en el puerto 7 de la arduino.
  digitalWrite(7, LOW);
  servo1.attach(9);      //Servo de elevacion.
  servo2.attach(10);     //Servo de asimut.
  
  inicial();
  //delay(500);
  SD_run();
  lcd_run();

}

void loop() {
  nw = RTC.now();
  comHoraReloj();
  DibujarLCD();
  delay(1000);
}

void inicial(){
  mover_Servo(90, 0, 1);                // Servo de elevación.
  mover_Servo(-180 * 247/270, 0, 2);
}

void lcd_run(){
  //Inicia la LCD.
  lcd.init();
  lcd.backlight();
  lcd.clear();
}

void SD_run() {
  //Inicia la SD
  Serial.println("Iniciando SD...");
  Serial.println();
  pinMode(cspin, OUTPUT);
  if (!SD.begin(cspin)) {
    Serial.println("SD mo inicio.");
    return;  //while (1) ;
  }
  Serial.println("SD inicio correctamente.");
  Serial.println();
  Serial.println("...");
  Serial.println();
  Serial.println();
  Serial.println("Done");
}

void comHoraReloj(){
  //Compara la hora para posteriormente extraer los datos.
  //if (cont > 5 && cont < 18){
  if ((int)nw.hour() > 5 && (int)nw.hour() < 18 && (int)nw.minute() == 00 && (int)nw.second() == 00){
    dia = nw.day();
    mes = nw.month();
    anho = nw.year();
    BLinea((String)nw.hour());     //Funcion Buscar linea.
  }else if ((int)nw.hour() > 0 && (int)nw.hour() < 5 || (int)nw.hour() > 18 && (int)nw.hour() > 23){
      mover_Servo(ele_anterior.toInt(), 90, 1);
      ele_anterior = (String)90;
      //mover_Servo(asi_anterior.toInt(), 90, 2);
      //asi_anterior = (String)90;
  }
}

void DibujarLCD(){
  //Esta funcion grafica los datos de elevacion y asimut,
  // asi como los de la hora, fecha, voltaje y corriente de los paneles.//

  //_____Grafica la elevacion y la fecha.
  lcd.setCursor(0,0);
  lcd.print("Ele:");
  lcd.print(ele_anterior.toInt(), DEC);
  lcd.setCursor(8,0);
  lcd.print("| ");
  lcd.print("D:");
  lcd.print(nw.year()-2000, DEC);
  lcd.print("/");
  lcd.print(nw.month(), DEC);
  lcd.print("/");
  lcd.print(nw.day(), DEC);
  //_____Grafica el asimut y la hora completa
  lcd.setCursor(0,1);
  lcd.print("Asi:");
  lcd.print(asi_anterior.toInt(), DEC);
  lcd.setCursor(8,1);
  lcd.print("| ");
  lcd.print("T:");
  lcd.print(nw.hour(), DEC);
  lcd.print(":");
  lcd.print(nw.minute(), DEC);
  lcd.print(":");
  lcd.print(nw.second(), DEC);
  //_____Grafica el voltaje
  lcd.setCursor(0,2);
  lcd.print("Vol:");
  lcd.print(000, DEC);
  lcd.setCursor(8,2);
  lcd.print("| ");
  //_____Grafica la corriente
  lcd.setCursor(0,3);
  lcd.print("Cor:");
  lcd.print(000, DEC);
  lcd.setCursor(8,3);
  lcd.print("| ");
}

void BLinea(String hora) {
  //Esta funcion arma el nombre del archivo (Data), lo busca y lo abre.
  // Tambien se encarga de buscar linea a linea la hora hora precisa de la linea
  // y extrae los datos de Elevacion y Asimut asociados a dicha hora.
  // Posteriormente envia el angulo obtenido a la funcion mover_Servo()
  // para que esta, por medio de interpolacion, posicione el servo correspondiente.//
  Des(); //Funcion: TRansforma los meses de numero a caracteres. Esta arroja la variable "ms".
  String nom = ((String)nw.year() + "/" + ms + "/" + (String)nw.day() + ".csv");
    Archivo = SD.open(nom.c_str(), FILE_READ);
    if (Archivo) {
    Serial.println(hora.c_str());
     while (Archivo.available()) {     //Recorremos el archivo linea a linea.
      linea = Archivo.readStringUntil('\n'); //lee caracteres de un stream y los escribe en un string. La función termina si el carácter 
                                                //especificado ha sido encontrado (character) o el tiempo máximo de lectura ha expirado
      int pos = linea.indexOf((String)hora.c_str()); //Posicion donde se encuentra el valor de la hora.
      delay(15);
      if (pos == 0) {
        Serial.println("Esperando...........");
        /*Localiza un carácter o cadena dentro de otra cadena. De forma predeterminada, busca desde el comienzo de la Cadena, 
        pero también puede comenzar desde un índice dado, lo que permite la localización de todas las instancias del carácter o Cadena.
        */
        pos = linea.indexOf(";");  //Identifica los !;! para separar los valores de asimut y elevacion de la BD.
        int pos2 = linea.indexOf(";", pos + 1);
       // busca una subcadena dada desde la posición dada hasta el final de la cadena
        String elevacion = linea.substring(pos + 1, linea.indexOf(";", pos + 1));      //Suatraemos la elevacio.
        String asimut = linea.substring(pos2 + 1, linea.indexOf(";", pos2 + 1));      //Suatraemos Asimut.
        
        long ang;
        ang = (long)elevacion.toInt();                          //Transforma el tipo de la variable.
        Serial.print("Angulo en Servo de Elevacion: ");
        Serial.println(elevacion.toInt());
//        ang = 180 * (long)elevacion.toInt() / 270;
        if (elevacion.toInt() <= 270) {
          mover_Servo(ele_anterior.toInt(), (int)ang+5, 1);
          ele_anterior = (String)ang;
          Serial.print("Angulo en Servo de Elevacion: ");
          Serial.println(ele_anterior);
        } else {
          servo1.write(90);
        }
        
        ang = 180 * (long)asimut.toInt() / 270;     //Transforma el valor del angulo real del motor a un angulo equivalente para el PWM en la targeta arduino.
        if (asimut.toInt() <= 270) {
          mover_Servo(asi_anterior.toInt(), (int)ang, 2);
          asi_anterior = (String)ang;
          Serial.print("Angulo en Servo de Asimut: ");
          Serial.println(asi_anterior);
        } else {
          servo2.write(180 * 270 / 270);
          //delay(3000);
        }
      }else{
        //Serial.println("La posicion no es 0");
      }
      //delay(100);
    }
    Archivo.close();
    //cont = 0;
  } else {
    //Archivo.close();
    Serial.println("El archivo de datos no se abrió correctamente");
  }
}
//2.094395102 rad/s @ 24v
//120°/s
//0.5s/1.047197551
void mover_Servo(int angulo_anterior, int angulo_actual, int n){
  //Esta funcion interpola el movimiento del servo de un angulo anterior a uno posterior.
  int_trapezoidal_npuntos((float)angulo_anterior, (float)angulo_actual, 1, 2.094395102/2, puntos, 0, n);
}

void int_trapezoidal_npuntos( float qi, float qf, float a, int vmax, int npuntos, float ti, int n) {
  int_trapezoidal_tmin( qi, qf, a, vmax );   //Devuelve tao, f y tmin.
  sign(qi, qf);   //Referencia el signo para posteriores calculos, arrojando la variable "s".
  int i = 0;
  int vec_t[]   = {};
  float vec_q[]   = {};
  int vec_qp[]  = {};
  int vec_qpp[] = {};
  float ntao = ti + tao;
  float na = 0;
  //Serial.println(f);
  if (f == 0) {
    float T = tmin; // / npuntos;
    int i = 0;
    for (float t = ti; t <= ti + tmin; t = t + T/npuntos) {
      i = i + 1;
      if (t <= ntao) {
        vec_t[i]   = t;
        na = qi + s*(a/(float)2) * pow(t-ti, (float)2);
        na = na;
      }
      if (t <= ti + T - tao && t > ntao) {
        vec_t[i]   = t;
        na = qi - (s*(pow(vmax,(float)2)/(2*a))) + (s*vmax*(t-ti));
        na = na;
        vec_qp[i]  = s * vmax;
        vec_qpp[i] = 0;
      }
      if (t < ti + T && t > ti + T - tao) {
        vec_t[i]   = t;
        na = qf + (s*((a*T*(t-ti))-(pow(a*T,(float)2)/(float)2)-((a/(float)2)*pow(t-ti,(float)2))));
        vec_qp[i]  = s * ((a * T) - (a * (t - ti)));
        vec_qpp[i] = -s * a;
      }
      if (n == 1){
        servo1.write((int)na);
        delay(tiempo);
      }else if (n == 2){
        servo2.write((int)na);
        delay(tiempo);
      }
    }
  }

  if (f == 1) {
    float Tt = tmin / npuntos;
    int i = 0;
    //Serial.println(ti + tmin);
    //Serial.println(ntao);
    for (float t = ti; t <= ti + tmin; t = t + Tt) {
      float vmax2 = tao * a;
      if (t <= ntao) {
        vec_t[i]   = t;
        //vec_q[i]   = qi + s * (a / (float) 2) * (t - ti) ^ (float) 2;
        vec_q[i]   = qi + s * (a / (float) 2) * pow(t - ti, (float)2);
        vec_qp[i]  = s * a * (t - ti);
        vec_qpp[i] = s * a;
      }
      if (t > ntao) {
        vec_t[i]   = t;
        //vec_q[i]   = qf + ( s * ( (a * Tt * (t - ti)) - ((a * Tt ^ (float) 2) / (float) 2) - ((a / (float) 2) * (t - ti) ^ (float) 2)));
        vec_q[i]   = qf + ( s * ((a*Tt*(t-ti)) - (pow(a*Tt, (float)2)/(float)2) - ((a / (float) 2) * pow(t - ti, (float) 2))));
        vec_qp[i]  = s * ((a * Tt) - (a * (t - ti)));
        vec_qpp[i] = -s * a;
      }
    }
  }
}

void int_trapezoidal_tmin( int qi, int qf, int a, int vmax) {
  sign(qi, qf);
  tao = vmax / a;
  long toa = 2 * tao;
  int zz = qf - qi;
  tmin = (s * ((qf - qi) / vmax)) + tao;
  if (toa >= tmin) {
    int d = s * a * (qf - qi);
    long vmax2 = sqrt(d);
    tao  = vmax2 / a;
    tmin = (s * ((qf - qi) / vmax2)) + tao;
    f = 1;
    //Serial.println(vmax2);
  } else {
    f = 0;
  }
  return;
}

void sign(int q1, int q2) {
  //Serial.println("estos son los datos para calcular el signo");
  //Serial.println(q1);
  //Serial.println(q2);
  if (q2 - q1 <= 0) {
    s = -1;
  } else if (q2 - q1 >= 0) {
    s = 1;
  }
}

void Des() {
  switch (nw.month())
  {
    case 1:
      ms = "Enero";
      return;
    case 2:
      ms = "Febrero";
      return;
    case 3:
      ms = "Marzo";
      return;
    case 4:
      ms = "Abril";
      return;
    case 5:
      ms = "Mayo";
      return;
    case 6:
      ms = "Junio";
      return;
    case 7:
      ms = "Julio";
      return;
    case 8:
      ms = "Agosto";
      return;
    case 9:
      ms = "Septiembre";
      return;
    case 10:
      ms = "Octubre";
      return;
    case 11:
      ms = "Noviembre";
      return;
    case 12:
      ms = "Diciembre";
      return;
    default:
      ms = ms;
      return;
  }
}
void printDigits(int digits) {
  // utility function for digital clock display: prints preceding colon and leading 0
  Serial.print(":");
  if (digits < 10)
    Serial.print('0');
  Serial.print(digits);
}
