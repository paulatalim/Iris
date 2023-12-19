#include <OneWire.h>
#include <DallasTemperature.h>
#include <Ultrasonic.h>
#include "HX711.h"

/*** SENSORES E CONTROLES ***/
#define PIN_SENSOR_TEMP 23 
#define PIN_HCSR04_ECHO 18
#define PIN_HCSR04_TRIG 19
#define PIN_HX711_DT 39 
#define PIN_HX711_SCK 14

/*** OBJETOS ***/
OneWire oneWire(PIN_SENSOR_TEMP);
DallasTemperature sensors(&oneWire);
Ultrasonic ultrasonic(PIN_HCSR04_TRIG, PIN_HCSR04_ECHO);
HX711 balanca;  

float calibration_factor = - 45000; // Fator de calibração para ajuste da célula 
char comando;

bool medir_temperatura;
bool medir_altura;
bool medir_peso;

int altura_calibracao;
int altura_medida;
int altura;
float peso;
float temperatura;

void setup() {
  Serial.begin(9600);
  Serial.println("Iris: iniciando sistema iniciando ESP Iris");

  //SENSOR TEMPERATURA
  sensors.begin();

  //SENSOR ULTRASSONICO
  pinMode(PIN_HCSR04_ECHO, INPUT); //DEFINE O PINO COMO ENTRADA (RECEBE)
  pinMode(PIN_HCSR04_TRIG, OUTPUT); //DEFINE O PINO COMO SAIDA (ENVIA)

  //BALANÇA
  balanca.begin(PIN_HX711_DT, PIN_HX711_SCK);
  balanca.read_average(); 
  balanca.tare();

  //Inicializa as variaveis
  medir_temperatura = false;
  medir_altura = true;
  medir_peso = false;
}

void loop() {
  // SENSOR DE TEMPERATURA
  if (medir_temperatura) {
    // Espera 1 minuto
    delay(60000);

    sensors.requestTemperatures(); /* Envia o comando para leitura da temperatura */
    Serial.print("A temperatura é: ");
    temperatura = sensors.getTempCByIndex(0);
    Serial.print(temperatura); /* Endereço do sensor */
    Serial.println(" °C");
    medir_temperatura = false;
  }

  //SENSOR ULTRASSONICO
  hcsr04();
  altura_calibracao = altura_medida;
  Serial.print("Altura de calibração: ");
  Serial.print(altura_calibracao);
  
  // Espera 30 segundos
  // delay(30000);

  hcsr04(); // FAZ A CHAMADA DO MÉTODO "hcsr04()"
  Serial.print("Sua altura é: "); //IMPRIME O TEXTO NO MONITOR SERIAL
  altura = altura_calibracao - altura_medida;
  Serial.print(altura); ////IMPRIME NO MONITOR SERIAL A DISTÂNCIA MEDIDA
  Serial.println("cm"); //IMPRIME O TEXTO NO MONITOR SERIAL

  // if (medir_altura) {
  //   MQTT.publish(TOPICO_PUBLISH_SISTEMA, altura_str);
  //   medir_altura = false;
  // }
  
  //BALANÇA
  balanca.set_scale(calibration_factor);  // a balanca está em função do fator de calibração
  
  //verifica se o modulo esta pronto para realizar leituras
  if (balanca.is_ready()) {
    //mensagens de leitura no monitor serial
    Serial.print("Leitura: ");
    peso = balanca.get_units();
    Serial.print(balanca.get_units(), 1); //retorna a leitura da variavel balanca com a unidade quilogramas
    Serial.println(" kg");
      
    // if (medir_peso) {
    //   MQTT.publish(TOPICO_PUBLISH_SISTEMA, peso_str);
    //   medir_peso = false;
    // }

    //alteracao do fator de calibracao
    if (Serial.available()) {
      comando = Serial.read();
      switch (comando) {
        case 'x':
          calibration_factor = calibration_factor - 100;
          break;
        case 'c':
          calibration_factor = calibration_factor + 100;
          break;
        case 'v':
          calibration_factor = calibration_factor - 10;
          break;
        case 'b':
          calibration_factor = calibration_factor + 10;
          break;
        case 'n':
          calibration_factor = calibration_factor - 1;
          break;
        case 'm':
          calibration_factor = calibration_factor + 1;
          break;
      }
    }
  } else {
    Serial.println("HX-711 ocupado");
  }
}

//MÉTODO RESPONSÁVEL POR CALCULAR A DISTÂNCIA
void hcsr04(){
  digitalWrite(PIN_HCSR04_TRIG, LOW); //SETA O PINO 6 COM UM PULSO BAIXO "LOW"
  delayMicroseconds(2); //INTERVALO DE 2 MICROSSEGUNDOS
  digitalWrite(PIN_HCSR04_TRIG, HIGH); //SETA O PINO 6 COM PULSO ALTO "HIGH"
  delayMicroseconds(10); //INTERVALO DE 10 MICROSSEGUNDOS
  digitalWrite(PIN_HCSR04_TRIG, LOW); //SETA O PINO 6 COM PULSO BAIXO "LOW" NOVAMENTE
  altura_medida = (ultrasonic.read(CM)); //VARIÁVEL GLOBAL RECEBE O VALOR DA DISTÂNCIA MEDIDA
  delay(1000); 
}
