#include <OneWire.h>
#include <DallasTemperature.h>

#define PIN_SENSOR_TEMP 23

OneWire oneWire(PIN_SENSOR_TEMP);
DallasTemperature sensors(&oneWire);

/**
 * @brief Set the up termometro object
 * 
 */
void setup_termometro() {
  sensors.begin();  
}

/**
 * @brief Mede a temperatura
 * 
 * @return float - temperatura em graus celcius
 */
float medir_temperatura() {
  sensors.requestTemperatures();
  return sensors.getTempCByIndex(0);
}