#include "BluetoothSerial.h"

#include "Balanca.hpp"
#include "Termometro.hpp"
#include "Altura.hpp"

BluetoothSerial SerialBT;
Altura altura;

unsigned long envioAnterior;
bool enviar_temp;
bool enviar_peso;
bool enviar_altura;

void setup() {
  Serial.begin(115200);
  Serial.println("Iris: iniciando sistema iniciando ESP Iris");

  // Nome do bluetooth que aparece no celular
  SerialBT.begin("Iris Hardware");

  // Inicializa sensores
  setup_termometro();
  setup_balanca();
  altura = Altura();

  envioAnterior = 0;
  enviar_temp = true;
  enviar_peso = false;
  enviar_altura = false;
}

void loop() {
  char caracterRecebido;

  if (millis() - envioAnterior > 1000) {
    envioAnterior = millis();
    
    float temp = medir_temperatura();
    Serial.print("\nTemperatura: ");
    Serial.print(temp);
    Serial.println(" °C");

    // Mede e informa a altura
    altura.medir();
    altura.imprimir();

    // Informa o peso no celular
    float peso = medir_peso();
    Serial.print("Peso: ");
    Serial.print(peso);
    Serial.println(" kg");

    char mensage[10] = {0};

    // Processa a informacao a ser enviada
    if(enviar_altura) {
      // Prepara a mensagem para enviar a altura
      sprintf(mensage, "A%.03f", altura.get_altura());

      // Ajuste nas variaveis
      altura.set_isCalibrated(false);
      enviar_altura = false;
    
    } else if(enviar_temp) {
      // Prepara a mensagem para enviar a temperatura
      sprintf(mensage, "T%.02f", temp);
    
    } else {
      // Prepara a mensagem para enviar o peso
      sprintf(mensage, "P%.02f", peso);
    }

    SerialBT.println(mensage);

    // Envia a mensagem
    if (Serial.available()) {
      SerialBT.write(Serial.read());
    }

    enviar_temp = !enviar_temp;
  }

  // Recebe caracter do bluetooth
  caracterRecebido = SerialBT.read();

  // Verifica se ha alguma mensagem
  if (SerialBT.available()) {
  
    //Informa o caracter recebido do app no terminal serial
    Serial.print("Caracter recebido: ");
    Serial.println(caracterRecebido);

    // Processa a informacao recebida
    switch(caracterRecebido) {
      case 'c':
        // Inicia a leitura da altura
        altura.set_isCalibrated(true);
        break;
      case 'a':
        // Permite o envio da altura
        enviar_altura = true;
        break;
    }
  }
}