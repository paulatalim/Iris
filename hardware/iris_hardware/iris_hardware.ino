#include "BluetoothSerial.h"

#include "Balanca.hpp"
#include "Termometro.hpp"
#include "Altura.hpp"

#define LED 22

BluetoothSerial SerialBT;
Altura altura;

unsigned long envioAnterior;
// bool enviar_temp;
// bool enviar_peso;
// bool enviar_altura;
// bool enviar_altura_calibragem;
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
  // enviar_temp = true;
  // enviar_peso = false;
  // enviar_altura = false;
  // enviar_altura_calibragem = false;
  enviar_msg = -1;
}

void loop() {
  char caracterRecebido;

  // if(SerialBT.connect()) {
  //     digitalWrite(LED, HIGH);
  //   } else {
  //     digitalWrite(LED, LOW);
  //   }

  
  if (millis() - envioAnterior > 2000) {
    envioAnterior = millis();

    // Serial.println(SerialBT.connect());
    
    float temp = medir_temperatura();
    Serial.print("\nTemperatura: ");
    Serial.print(temp);
    Serial.println(" °C");

    // Mede e informa a altura
    if(altura.get_isCalibrated()) {
      altura.medir();
    } else if (altura.get_calibrate()) {
      altura.calibrar_sensor();
      Serial.print("time: ");
      Serial.println(altura.get_timeCalibracao());
    }

    altura.imprimir();

    // Informa o peso no celular
    float peso = medir_peso();
    Serial.print("Peso: ");
    Serial.print(peso);
    Serial.println(" kg");

    char mensage[10] = {0};

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
        sprintf(mensage, "T%.02f", temp);
        break;
      case 1:
        sprintf(mensage, "P%.02f", peso);
        break;
      case 2:
        sprintf(mensage, "S");
        break;
    }

    SerialBT.println(mensage);

    // Envia a mensagem
    if (Serial.available()) {
      SerialBT.write(Serial.read());
    }

    if(enviar_msg < 1) {
      enviar_msg++;
    } else {
      enviar_msg = -1;
    }
  }

  //   // Processa a informacao a ser enviada
  //   if(enviar_altura) {
  //     if(altura.get_isCalibrated()) {
  //       // Prepara a mensagem para enviar a altura
  //       sprintf(mensage, "A%.03f", altura.get_altura());
  //     } else {
  //       sprintf(mensage, "C%.04f", altura.get_timeCalibracao());
  //     }

  //     // Ajuste nas variaveis
  //     // altura.set_isCalibrated(false);
  //     enviar_altura = false;
    
  //   } else if(enviar_temp) {
  //     // Prepara a mensagem para enviar a temperatura
  //     sprintf(mensage, "T%.02f", temp);
    
  //   } else {
  //     // Prepara a mensagem para enviar o peso
  //     sprintf(mensage, "P%.02f", peso);
  //   }

  //   SerialBT.println(mensage);

  //   // Envia a mensagem
  //   if (Serial.available()) {
  //     SerialBT.write(Serial.read());
  //   }

  //   enviar_temp = !enviar_temp;
  // }

  // Recebe caracter do bluetooth
  caracterRecebido = SerialBT.read();
  // int letra = SerialBT.read();

  // Verifica se ha alguma mensagem
  if (SerialBT.available()) {
  
    //Informa o caracter recebido do app no terminal serial
    Serial.print("Caracter recebido: ");
    Serial.println(caracterRecebido);

    enviar_msg = 2;

    digitalWrite(LED, HIGH);
    altura.set_calibrate(true);

    // Serial.println(letra);

    // // Processa a informacao recebida
    // switch(caracterRecebido) {
    //   case 'c':
    //     // Inicia a leitura da altura
    //     altura.set_isCalibrated(true);
    //     enviar_altura_calibragem = true;
    //     break;
    //   case 'a':
    //     // Permite o envio da altura
    //     enviar_altura = true;
    //     break;
    // }
  }
}