#include <Ultrasonic.h>

#define PIN_HCSR04_ECHO 18
#define PIN_HCSR04_TRIG 19

Ultrasonic ultrasonic(PIN_HCSR04_TRIG, PIN_HCSR04_ECHO);

void setup_hcsr04() {
  pinMode(PIN_HCSR04_ECHO, INPUT);  // DEFINE O PINO COMO ENTRADA (RECEBE)
  pinMode(PIN_HCSR04_TRIG, OUTPUT); // DEFINE O PINO COMO SAIDA (ENVIA)
}

/**
 * @brief Calcula a distancia entre o sensor e o ponto mais proximo
 * 
 * @return inteiro: altura em centimetros 
 */
int hcsr04() {
  int altura_medida;

  digitalWrite(PIN_HCSR04_TRIG, LOW);    // SETA O PINO 6 COM UM PULSO BAIXO "LOW"
  delayMicroseconds(2);                  // INTERVALO DE 2 MICROSSEGUNDOS
  digitalWrite(PIN_HCSR04_TRIG, HIGH);   // SETA O PINO 6 COM PULSO ALTO "HIGH"
  delayMicroseconds(10);                 // INTERVALO DE 10 MICROSSEGUNDOS
  digitalWrite(PIN_HCSR04_TRIG, LOW);    // SETA O PINO 6 COM PULSO BAIXO "LOW" NOVAMENTE
  altura_medida = (ultrasonic.read(CM)); // VARIÁVEL GLOBAL RECEBE O VALOR DA DISTÂNCIA MEDIDA
  delay(1000);

  return altura_medida;
}

int medir_altura() {
  int distancia;
  int altura_calibracao;
  int altura;

  // Mede a altura de calibracao
  altura_calibracao = hcsr04();
  Serial.print("Altura de calibração: ");
  Serial.print(altura_calibracao);
  
  // Orientacao
  Serial.print("Orientação: Fique de baixo do sensor");
  delay(1000);
  
  // Mede a altura
  distancia = hcsr04();
  altura = altura_calibracao - distancia;

  // Imprime a altura medida
  Serial.print("Sua altura é: ");
  Serial.print(altura);
  Serial.println("cm");

  // if (medir_altura) {
  //   MQTT.publish(TOPICO_PUBLISH_SISTEMA, altura_str);
  //   medir_altura = false;
  // }
  return altura;
}