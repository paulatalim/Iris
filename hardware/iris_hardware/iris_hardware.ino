#include "BluetoothSerial.h"

#include "Balanca.hpp"
#include "Termometro.hpp"
#include "Altura.hpp"

#define LED 22

BluetoothSerial SerialBT;
Altura altura;

unsigned long envioAnterior;
bool sistema_conectado;

void setup() {
  Serial.begin(115200);
  Serial.println("Iris: iniciando sistema iniciando ESP Iris");

  // Nome do bluetooth que aparece no celular
  SerialBT.begin("Iris Hardware");

  // Inicializa sensores
  setup_termometro();
  setup_balanca();
  altura = Altura();

  pinMode(LED, OUTPUT);

  // Inicialiaza variaveis
  envioAnterior = 0;
  sistema_conectado = false;
}

void loop() {
  char caracterRecebido;

  if (millis() - envioAnterior > 1000) {
    // Atualizacao de tempo
    envioAnterior = millis();
    
    // Leitura da temperatura
    float temp = medir_temperatura();

    // Informa a temperatura lida
    Serial.print("\nTemperatura: ");
    Serial.print(temp);
    Serial.println(" °C");

    // Verifica se o sensor esta calibrado
    if(altura.get_isCalibrated()) {
      // Mede e informa a altura
      altura.medir();
    } else if (altura.get_calibrate()) {
      // Calibra o sensor
      altura.calibrar_sensor();

      // Informa o tempo para calibrar
      Serial.print("time: ");
      Serial.println(altura.get_timeCalibracao());
    }

    // Informa a altura lida
    altura.imprimir();

    // Leitura do peso
    float peso = medir_peso();

    // Informa o peso lido
    Serial.print("Peso: ");
    Serial.print(peso);
    Serial.println(" kg");

    // Cria a mensagem a ser enviada via bluetooth
    char mensage[30] = {0};

    // Adicao de temperatura e peso a mensagem a ser enviada
    sprintf(mensage, "T%.02f", temp);
    sprintf(mensage, "%s,P%.02f", mensage, peso);

    // Verifica se o sensor esta sendo calibrado
    if(altura.get_isCalibrated()) {
      // Adiciona a altura na mensagem a ser enviada
      sprintf(mensage, "%s,A%.03f", mensage, altura.get_altura());
    } else {
      // Adiciona o tempo de calibracao restante na mensagem a ser enviada
      sprintf(mensage, "%s,C%d", mensage, altura.get_timeCalibracao());
    }

    // Verifica se o sistema esta conectado
    if (sistema_conectado) {
      // Adiciona verificacao de sistema conectado na mensagem a ser enviada
      sprintf(mensage, "%s,S", mensage);
    }

    // Prepara mensagem para ser enviada
    SerialBT.println(mensage);

    // Envia a mensagem
    if (Serial.available()) {
      SerialBT.write(Serial.read());
    }
  }

  // Recebe caractere do bluetooth
  caracterRecebido = SerialBT.read();

  // Verifica se ha alguma mensagem
  if (SerialBT.available()) {
  
    //Informa o caracter recebido do app no terminal serial
    Serial.print("Caracter recebido: ");
    Serial.println(caracterRecebido);

    // Atualizacao de status do sistema
    digitalWrite(LED, HIGH);
    sistema_conectado = true;
    altura.set_calibrate(true);
  }
}