#include <Ultrasonic.h>

#define PIN_HCSR04_ECHO 18
#define PIN_HCSR04_TRIG 19

Ultrasonic ultrasonic(PIN_HCSR04_TRIG, PIN_HCSR04_ECHO);

class Altura {
private:
  float altura_calibracao;
  float altura_usuario;
  bool isCalibrated;
  bool calibrate;
  long envioAnterior;
  long time;

  /**
   * @brief Set the up hcsr04 object
   */
  void setup_hcsr04() {
    pinMode(PIN_HCSR04_ECHO, INPUT);  // DEFINE O PINO COMO ENTRADA (RECEBE)
    pinMode(PIN_HCSR04_TRIG, OUTPUT); // DEFINE O PINO COMO SAIDA (ENVIA)
  }

  /**
  * @brief Calcula a distancia entre o sensor e o ponto mais proximo
  * 
  * @return inteiro: altura em metros
  */
  float hcsr04() {
    float distancia;

    digitalWrite(PIN_HCSR04_TRIG, LOW);
    delayMicroseconds(2);
    digitalWrite(PIN_HCSR04_TRIG, HIGH);
    delayMicroseconds(10);
    digitalWrite(PIN_HCSR04_TRIG, LOW);
    distancia = float(ultrasonic.read(CM));
    distancia /= 100;

    return distancia;
  }

  /**
   * @brief Controla o tempo em millisengundos para a calibracao do sensor
   * 
   * @param reiniciar_contagem
   */
  void atualizar_tempo_calibracao(bool reiniciar_contagem) {
    if(reiniciar_contagem) {
      this->envioAnterior = millis();
      this->time = 30000;
    } else {
      this->time -= long(millis()) - this->envioAnterior;
    }
  }

public:
  /**
   * @brief Construct a new Altura object
   */
  Altura () {
    this->altura_calibracao = 0;
    this->altura_usuario = 0;
    this->isCalibrated = false;
    this->envioAnterior = 0;
    this->time = 30000;
    this->calibrate = false;

    setup_hcsr04();
  }

  /**
   * @brief Calibra o sensor HC-SR04
   * 
   */
  void calibrar_sensor() {
    float altura_anterior;

    if(long(time) > 0) {
      altura_anterior = this->altura_calibracao;
      this->altura_calibracao = hcsr04();

      if(altura_anterior == this->altura_calibracao) {
        atualizar_tempo_calibracao(false);  
      } else {
        atualizar_tempo_calibracao(true);
      }
    } else {
      this->isCalibrated = true;
    }
  }

  /**
   * @brief Mede e calcula a altura do usuario
   * 
   */
  void medir() {
    float altura = hcsr04();
    this->altura_usuario = this->altura_calibracao - altura;
  }

  /**
   * @brief Informa no monitor serial os valores obtidos
   * 
   */
  void imprimir() {
    if (this->isCalibrated) {
      // Imprimi altura do usuario
      Serial.print("Altura: ");
      Serial.print(this->altura_usuario);
      Serial.println(" m");
    } else {
      // Imprimi altura de calibracao
      Serial.print("Altura de calibracao: ");
      Serial.print(this->altura_calibracao);
      Serial.println(" m");
    }
  }

  /**
   * @brief Get the timeCalibracao object
   * 
   * @return long - tempo restante para calibracao
   */
  long get_timeCalibracao(){
    return this->time;
  }

  /**
   * @brief Get the altura object
   * 
   * @return float - altura do usuario em metros
   */
  float get_altura() {
    return this->altura_usuario;
  }

  /**
   * @brief Get the isCalibrated object
   * 
   * @return true - se o sensor estiver calibrado
   * @return false - se o sensor nao estiver calibrado
   */
  bool get_isCalibrated() {
    return this->isCalibrated;
  }

  /**
   * @brief Get the calibrate object
   * 
   * @return true 
   * @return false 
   */
  bool get_calibrate() {
    return this->calibrate;
  }

  /**
   * @brief Set the calibrate object
   * 
   * @param calibrate true para iniciar a calibracao, false para nao calibrar
   */
  void set_calibrate(bool calibrate) {
    this->calibrate = calibrate;
  }
};