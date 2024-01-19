#include "BluetoothSerial.h"

#include "Balanca.hpp"
#include "Termometro.hpp"
#include "Altura.hpp"

#define LED 22

BluetoothSerial SerialBT;
Altura altura;

unsigned long envioAnterior;
int enviar_msg;
int state;

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

  state = 1;
  envioAnterior = 0;
  enviar_msg = -1;
}

void loop() {
  char caracterRecebido;

  if (millis() - envioAnterior > 2000) {
    envioAnterior = millis();
    
    float temp = medir_temperatura();
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

    // Informa o peso lido
    float peso = medir_peso();
    Serial.print("Peso: ");
    Serial.print(peso);
    Serial.println(" kg");

    char mensage[10] = {0};

    // Verifica a mensagem a ser enviada
    switch(enviar_msg) {
      case -1:
        if(altura.get_isCalibrated()) {
          // Prepara a mensagem para enviar a altura
          sprintf(mensage, "A%.03f", altura.get_altura());
        } else {
          sprintf(mensage, "C%d", altura.get_timeCalibracao());
        }
        break;
      case 0:
        // Prepara a mensagem para enviar a temperatura
        sprintf(mensage, "T%.02f", temp);
        break;
      case 1:
        // Prepara a mensagem para enviar o peso
        sprintf(mensage, "P%.02f", peso);
        break;
      case 2:
        // Prepara a mensagem para enviar a verificacao que o sistema esta conectado
        sprintf(mensage, "S");
        break;
    }

    SerialBT.println(mensage);

    // Envia a mensagem
    if (Serial.available()) {
      SerialBT.write(Serial.read());
    }

    // Atualiza variavel
    if(enviar_msg < 1) {
      enviar_msg++;
    } else {
      enviar_msg = -1;
    }
  }

  // Recebe caracter do bluetooth
  caracterRecebido = SerialBT.read();

  // Verifica se ha alguma mensagem
  if (SerialBT.available()) {
  
    //Informa o caracter recebido do app no terminal serial
    Serial.print("Caracter recebido: ");
    Serial.println(caracterRecebido);

    enviar_msg = 2;

    digitalWrite(LED, HIGH);
    altura.set_calibrate(true);
  }
}