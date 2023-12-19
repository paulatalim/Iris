#include "Balanca.hpp"
#include "Termometro.hpp"
#include "Altura.hpp"

void setup() {
  Serial.begin(9600);
  Serial.println("Iris: iniciando sistema iniciando ESP Iris");

  setup_termometro();
  setup_balanca();
  setup_hcsr04();
}

void loop() {
  medir_temperatura();
  medir_altura();
  medir_peso();
}