#include <OneWire.h>
#include <DallasTemperature.h>

#define PIN_SENSOR_TEMP 23

OneWire oneWire(PIN_SENSOR_TEMP);
DallasTemperature sensors(&oneWire);

void setup_termometro() {
  sensors.begin();  
}

float medir_temperatura() {
  sensors.requestTemperatures();
  return sensors.getTempCByIndex(0);
}