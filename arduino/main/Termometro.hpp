#include <OneWire.h>
#include <DallasTemperature.h>

#define PIN_SENSOR_TEMP 23

OneWire oneWire(PIN_SENSOR_TEMP);
DallasTemperature sensors(&oneWire);

// bool medir_temperatura;
float temperatura;

void setup_termometro() {
    sensors.begin();
    //  medir_temperatura = false;
}

float medir_temperatura() {
    Serial.print("Coloque o sensor debaixo do braco");

    // Espera 1 minuto
    delay(60000);

    sensors.requestTemperatures(); /* Envia o comando para leitura da temperatura */
    Serial.print("A temperatura é: ");
    temperatura = sensors.getTempCByIndex(0);
    Serial.print(temperatura); /* Endereço do sensor */
    Serial.println(" °C");

    return temperatura;
}