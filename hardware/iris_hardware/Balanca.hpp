#include "HX711.h"

#define PIN_HX711_DT 39 
#define PIN_HX711_SCK 14

HX711 balanca;
float calibration_factor;
char comando;
float peso;

/**
 * @brief Set the up balanca object
 * 
 */
void setup_balanca() {
  balanca.begin(PIN_HX711_DT, PIN_HX711_SCK);
  balanca.read_average(); 
  balanca.tare();

  calibration_factor = -45000;
}

/**
 * @brief Medicao do peso do usuario
 * 
 * @return float peso do usuario em kg
 */
float medir_peso () {
  balanca.set_scale(calibration_factor);  // a balanca está em função do fator de calibração
  
  // Verifica se o modulo esta pronto para realizar leituras
  if (balanca.is_ready()) {
    peso = balanca.get_units();

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
    return peso;
  } else {
    Serial.println("HX-711 ocupado");
  }
  return -1;
}