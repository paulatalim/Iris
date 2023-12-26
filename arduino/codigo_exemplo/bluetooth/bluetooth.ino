#include "BluetoothSerial.h"

BluetoothSerial SerialBT;

void setup() {
  Serial.begin(115200);
  Serial.println("Iris: iniciando sistema iniciando ESP Iris");

  // Nome do bluetooth que aparece no celular
  SerialBT.begin ("Iris Hardware");

  randomSeed(analogRead(0));

}

void loop() {
  char caracterRecebido;

  // gera um valor aleatório de temperatura entre 10 e 100
  int numAleatorio= random(10, 101);

  Serial.print("Gerando temperatura aleatoria: ");
  Serial.println(numAleatorio);

  // Informa o peso no celular
  SerialBT.println(numAleatorio);

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

  delay(2000);
}
