void setup() {
  // put your setup code here, to run once:
  Serial.begin(9600);

}

void loop() {
  // put your main code here, to run repeatedly:
  float elevacion = random(90);
  float asimut = random(180);
  float voltaje = random(9);
  float corriente = random(10);
  String val = "'Ele'," +(String)elevacion+",'Asi',"+(String)asimut+",'v',"+(String)voltaje+",'i',"+(String)corriente;
  Serial.println("");
  Serial.print(val);
  //Serial.println("");
  delay(1000);

}
