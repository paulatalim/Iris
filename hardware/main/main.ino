#include "BluetoothSerial.h"

#include "Balanca.hpp"
#include "Termometro.hpp"
#include "Altura.hpp"

BluetoothSerial SerialBT;

void setup() {
  Serial.begin(115200);
  Serial.println("Iris: iniciando sistema iniciando ESP Iris");

  // Nome do bluetooth que aparece no celular
  SerialBT.begin ("Iris Hardware");

  // Inicializa sensores
  setup_termometro();
  setup_balanca();
  setup_hcsr04();
}

void loop() {
  char caracterRecebido;

  medir_temperatura();
  medir_altura();
  medir_peso();

  //Informa o peso no celular
  SerialBT.println(medir_peso());

  // Envia a mensagem
  if (Serial.available()) {
    SerialBT.write(Serial.read());
  }

  // Recebe caracter do bluetooth
  caracterRecebido = SerialBT.read();

  // Verifica se ha alguma mensagem
  if (SerialBT.available()) {
  
    //Informa o caracter recebido do app no terminal serial
    Serial.print("Caracter recebido: ");
    Serial.println(caracterRecebido);

  }
}