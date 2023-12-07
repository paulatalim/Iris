
#include <OneWire.h>
#include <DallasTemperature.h>
#include <Ultrasonic.h>
#include "HX711.h"


//DEFININDO O SENSOR DE TEMPERATURA 
#define sensor_temp 23 //pino
OneWire oneWire(sensor_temp);  /*Protocolo OneWire*/
DallasTemperature sensors(&oneWire); /*encaminha referências OneWire para o sensor*/

//DEFININDO O SENSOR ULTRASSONICO
const int echoPin = 18; //PINO DIGITAL UTILIZADO PELO HC-SR04 ECHO(RECEBE)
const int trigPin = 19; //PINO DIGITAL UTILIZADO PELO HC-SR04 TRIG(ENVIA)
Ultrasonic ultrasonic(trigPin,echoPin); //INICIALIZANDO OS PINOS DO ARDUINO
int distancia; 
String result; 

//DEFININDO BALANÇA
#define DOUT 36 //Pino 1
#define CLK 39 //Pino 2
HX711 balanca;  
float calibration_factor = 48011.00; // Fator de calibração para ajuste da célula 
float peso; //variável peso 
long zero_factor = balanca.read_average();  




void setup() {
Serial.begin(9600); /*definição de Baudrate de 9600*/

//SENSOR TEMPERATURA
sensors.begin(); /*inicia biblioteca*/

//SENSOR ULTRASSONICO
pinMode(echoPin, INPUT); //DEFINE O PINO COMO ENTRADA (RECEBE)
pinMode(trigPin, OUTPUT); //DEFINE O PINO COMO SAIDA (ENVIA)

//BALANÇA
balanca.begin(DOUT,CLK);
balanca.set_scale();                                                                     
balanca.tare();  
  

}

void loop() {

//SENSOR DE TEMPERATURA
sensors.requestTemperatures(); /* Envia o comando para leitura da temperatura */
 Serial.print("A temperatura é: "); /* Printa "A temperatura é:" */
 Serial.print(sensors.getTempCByIndex(0)); /* Endereço do sensor */
 Serial.println(" °C"); 

//SENSOR ULTRASSONICO
hcsr04(); // FAZ A CHAMADA DO MÉTODO "hcsr04()"
  Serial.print("Sua altura é: "); //IMPRIME O TEXTO NO MONITOR SERIAL
  Serial.print(result); ////IMPRIME NO MONITOR SERIAL A DISTÂNCIA MEDIDA
  Serial.println("cm"); //IMPRIME O TEXTO NO MONITOR SERIAL
 

//BALANÇA
balanca.set_scale(calibration_factor);  // a balanca está em função do fator de calibração 
Serial.print("Peso: ");   
peso = balanca.get_units(), 10;                                             
if (peso < 0){
  peso = 0.00;                         
} 
Serial.print(peso);                                                                     
Serial.print(" kg");                                                                    

if(Serial.available()){
    char temp = Serial.read();
    if(temp == '+')   // Se o + for pressionado     
      calibration_factor += 1;   // incrementa 1 no fator de calibração   
    else if(temp == '-')    // Caso o - seja pressionado   
      calibration_factor -= 1;    // Decrementa 1 do fator de calibração  
  }

    
delay(2000); //Atualiza todos os valores de 2 em 2 segundos
}

//MÉTODO RESPONSÁVEL POR CALCULAR A DISTÂNCIA
void hcsr04(){
    digitalWrite(trigPin, LOW); //SETA O PINO 6 COM UM PULSO BAIXO "LOW"
    delayMicroseconds(2); //INTERVALO DE 2 MICROSSEGUNDOS
    digitalWrite(trigPin, HIGH); //SETA O PINO 6 COM PULSO ALTO "HIGH"
    delayMicroseconds(10); //INTERVALO DE 10 MICROSSEGUNDOS
    digitalWrite(trigPin, LOW); //SETA O PINO 6 COM PULSO BAIXO "LOW" NOVAMENTE
    //FUNÇÃO RANGING, FAZ A CONVERSÃO DO TEMPO DE
    //RESPOSTA DO ECHO EM CENTIMETROS, E ARMAZENA
    //NA VARIAVEL "distancia"
    distancia = (ultrasonic.read(CM)); //VARIÁVEL GLOBAL RECEBE O VALOR DA DISTÂNCIA MEDIDA
    result = String(distancia); //VARIÁVEL GLOBAL DO TIPO STRING RECEBE A DISTÂNCIA(CONVERTIDO DE INTEIRO PARA STRING)
    delay(1000); 
 }
