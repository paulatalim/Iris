#include <Ultrasonic.h>

#define PIN_HCSR04_ECHO 18
#define PIN_HCSR04_TRIG 19

Ultrasonic ultrasonic(PIN_HCSR04_TRIG, PIN_HCSR04_ECHO);

class Altura {
private:
  float altura_calibracao;
  float altura_usuario;
  bool isCalibrated;

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
    int distancia;

    digitalWrite(PIN_HCSR04_TRIG, LOW);
    delayMicroseconds(2);
    digitalWrite(PIN_HCSR04_TRIG, HIGH);
    delayMicroseconds(10);
    digitalWrite(PIN_HCSR04_TRIG, LOW);
    distancia = (ultrasonic.read(CM));

    return distancia;
  }

public:
  Altura () {
    altura_calibracao = 0;
    altura_usuario = 0;
    isCalibrated = false;

    setup_hcsr04();
  }

  void medir() {
    float altura =  hcsr04() / 100;
    
    if(isCalibrated) {
      // Calcula altura
      altura_usuario = altura_calibracao - altura;
    } else {
      // Calibra o sensor
      altura_calibracao = altura;
    }
  }

  void imprimir() {
    if (isCalibrated) {
      // Imprimi altura do usuario
      Serial.print("Altura: ");
      Serial.print(altura_usuario);
      Serial.println(" m");
    } else {
      // Imprime altura de calibracao
      Serial.print("Altura de calibracao: ");
      Serial.print(altura_calibracao);
      Serial.println(" m");
    }
  }

  float get_altura() {
    return altura_usuario;
  }

  void set_isCalibrated(bool value) {
    isCalibrated = value;

    // Reinicia valores
    if (!value) {
      altura_usuario = 0;
    }
  }
};