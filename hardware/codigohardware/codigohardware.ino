
#include <OneWire.h>
#include <DallasTemperature.h>
#include <Ultrasonic.h>
#include "HX711.h"

#include <PubSubClient.h>
#include <WiFi.h>

/*** Definicoes para o MQTT ***/
#define TOPICO_SUBSCRIBE_SISTEMA "iris/atuador"
#define TOPICO_PUBLISH_SISTEMA "iris/sensor"

#define ID_MQTT "LDDM_Iris"
#define BROKER_MQTT "test.mosquitto.org"
#define BROKER_PORT 1883

// Configuracao Wifi
#define SSID     "PP_TALIM_2G_EXT" // nome da rede WI-FI que deseja se conectar
#define PASSWORD "HOMETP20"  // Senha da rede WI-FI que deseja se conectar

/*** SENSORES E CONTROLES ***/
#define PIN_SENSOR_TEMP 23 
#define PIN_HCSR04_ECHO 18
#define PIN_HCSR04_TRIG 19
#define PIN_HX711_DT 39 
#define PIN_HX711_SCK 14

/*** OBJETOS ***/
WiFiClient espClient;
PubSubClient MQTT(espClient); 
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

/** 
 * @brief Inicializa e conecta-se na rede WI-FI desejada
 */
void initWiFi(void) {
  delay(10);
  Serial.println("------Conexao WI-FI------");
  Serial.print("Conectando-se na rede: ");
  Serial.println(SSID);
  Serial.println("Aguarde");
  reconnectWiFi();
}

/** 
 * @brief Inicializa parâmetros de conexão MQTT
 */
void initMQTT(void) {
  MQTT.setServer(BROKER_MQTT, BROKER_PORT);  //informa qual broker e porta deve ser conectado
  MQTT.setCallback(mqtt_callback);
}

/**
 * @brief esta função é chamada toda vez que uma 
 * informação de um dos tópicos subescritos chega
 */
void mqtt_callback(char* topic, byte* payload, unsigned int length) {
  String msg;
  /* obtem a string do payload recebido */
  for (int i = 0; i < length; i++) {
    char c = (char)payload[i];
    msg += c;
  }

  Serial.print("Chegou a seguinte string via MQTT: ");
  Serial.println(msg);

  /* toma ação dependendo da string recebida */
  if (msg.equals("A")) {
    medir_altura = true;
  } else if (msg.equals("P")) {
    medir_peso = true;
  } else if (msg.equals("T")) {
    medir_temperatura = true;
  }
}

/** 
 * @brief Reconecta-se ao broker MQTT (caso ainda não esteja conectado ou 
 * em caso de a conexão cair) em caso de sucesso na conexão ou reconexão, 
 * o subscribe dos tópicos é refeito.
 */
void reconnectMQTT() {
  while (!MQTT.connected()) {
    Serial.print("* Tentando se conectar ao Broker MQTT: ");
    Serial.println(BROKER_MQTT);

    if (MQTT.connect(ID_MQTT)) {
      Serial.println("Conectado com sucesso ao broker MQTT!");
      MQTT.subscribe(TOPICO_SUBSCRIBE_SISTEMA);
    } else {
      Serial.println("Falha ao reconectar no broker.");
      Serial.println("Havera nova tentatica de conexao em 2s");
      delay(2000);
    }
  }
}

/** 
 * @brief Verifica o estado das conexões WiFI e ao broker MQTT.
 * Em caso de desconexão (qualquer uma das duas), a conexão
 * é refeita.
 */
void VerificaConexoesWiFIEMQTT() {
  if (!MQTT.connected()) {
    reconnectMQTT();  // Reconecta o Broker
    reconnectWiFi();  // Reconecta o WiFI
  }
}

/** 
 * @brief Reconecta-se ao WiFi
 */
void reconnectWiFi() {
  //se já está conectado a rede WI-FI, nada é feito.
  //Caso contrário, são efetuadas tentativas de conexão
  if (WiFi.status() == WL_CONNECTED) {
    return;
  }

  WiFi.begin(SSID, PASSWORD);  // Conecta na rede WI-FI

  while (WiFi.status() != WL_CONNECTED) {
    delay(100);
    Serial.print(".");
  }

  Serial.println();
  Serial.print("Conectado com sucesso na rede ");
  Serial.print(SSID);
  Serial.println("\nIP obtido: ");
  Serial.println(WiFi.localIP());
}

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

  // Inicializa Wifi e broker
  initWiFi();
  initMQTT();

  //Inicializa as variaveis
  medir_temperatura = false;
  medir_altura = true;
  medir_peso = false;
}

void loop() {
  char temperatura_str[10] = {0};
  char altura_str[10] = {0};
  char peso_str[10] = {0};

  VerificaConexoesWiFIEMQTT();

  //SENSOR DE TEMPERATURA
  if (medir_temperatura) {
    //Esperar 1 minuto
    delay(60000);

    sensors.requestTemperatures(); /* Envia o comando para leitura da temperatura */
    Serial.print("A temperatura é: ");
    temperatura = sensors.getTempCByIndex(0);
    Serial.print(temperatura); /* Endereço do sensor */
    Serial.println(" °C");
    sprintf(temperatura_str, "T%f", temperatura);
    MQTT.publish(TOPICO_PUBLISH_SISTEMA, temperatura_str);
    medir_temperatura = false;
  }

  //SENSOR ULTRASSONICO
  if (medir_altura) {
    hcsr04();
    altura_calibracao = altura_medida;
    MQTT.publish(TOPICO_PUBLISH_SISTEMA, "C");
    Serial.print("Altura de calibração: ");
    Serial.print(altura_calibracao);
    
    // esperar 30 segundos
    delay(30000);

    hcsr04(); // FAZ A CHAMADA DO MÉTODO "hcsr04()"
    Serial.print("Sua altura é: "); //IMPRIME O TEXTO NO MONITOR SERIAL
    altura = altura_calibracao - altura_medida;
    Serial.print(altura); ////IMPRIME NO MONITOR SERIAL A DISTÂNCIA MEDIDA
    Serial.println("cm"); //IMPRIME O TEXTO NO MONITOR SERIAL
    sprintf(altura_str, "A%d", altura);
    MQTT.publish(TOPICO_PUBLISH_SISTEMA, altura_str);
    medir_altura = false;
  }
  
  //BALANÇA
  if (medir_peso) {
    balanca.set_scale(calibration_factor);  // a balanca está em função do fator de calibração
    
    //verifica se o modulo esta pronto para realizar leituras
    if (balanca.is_ready()) {
      //mensagens de leitura no monitor serial
      Serial.print("Leitura: ");
      peso = balanca.get_units();
      Serial.print(balanca.get_units(), 1); //retorna a leitura da variavel balanca com a unidade quilogramas
      Serial.println(" kg");
      sprintf(peso_str, "P%f", peso);
      MQTT.publish(TOPICO_PUBLISH_SISTEMA, peso_str);

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
    medir_peso = false;
  }

  MQTT.loop();
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
