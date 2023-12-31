#include <PubSubClient.h>
#include <arduino.h>
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
#define LED_BUILTIN 2
#define PIN_LED 2

/*** OBJETOS ***/
WiFiClient espClient;          // Cria o objeto espClient
PubSubClient MQTT(espClient);  // Instancia o Cliente MQTT passando o objeto espClient

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
  if (msg.equals("L")) {
    digitalWrite(PIN_LED, HIGH);
    Serial.println("LED aceso mediante comando MQTT");
  } else if (msg.equals("D")) {
    digitalWrite(PIN_LED, LOW);
    Serial.println("LED apagado mediante comando MQTT");
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
int numAleatorio;
void setup() {
  Serial.begin(9600);
  Serial.println("Iris: iniciando sistema iniciando ESP Iris");



  // Inicializa Wifi e broker
  initWiFi();
  initMQTT();
}

void loop() {
  // cria string para temperatura
 char temperatura_str[10] = {0};
 
/* garante funcionamento das conexões WiFi e ao broker MQTT */
 VerificaConexoesWiFIEMQTT();
 // gera um valor aleatório de temperatura entre 10 e 100
 numAleatorio = random(10, 101);
 
 // formata a temperatura aleatoria como string
 sprintf(temperatura_str, "A%d", numAleatorio);
 /* Publica a temperatura */

 MQTT.publish(TOPICO_PUBLISH_SISTEMA, temperatura_str);
 
 Serial.print("Gerando temperatura aleatoria: ");
 Serial.println(temperatura_str);
 
 /* keep-alive da comunicação com broker MQTT */
 MQTT.loop();
 
delay(2000);
  
}
