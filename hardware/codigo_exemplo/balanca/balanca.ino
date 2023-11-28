#include "HX711.h"

#define LOADCELL_DOUT_PIN  23
#define LOADCELL_SCK_PIN  22

HX711 escala;

float fator_calibracao = - 45000; //-7050 worked for my 440lb max scale setup
char comando; //declaracao da variavel que ira receber os comandos para alterar o fator de calibracao
const int TEMPO_ESPERA = 1000; //declaracao da variavel de espera

void setup() {
  //mensagens do monitor serial
  Serial.begin(9600);
  Serial.println("Celula de carga - Calibracao de Peso");
  Serial.println("Posicione um peso conhecido sobre a celula ao comecar as leituras");

  escala.begin (LOADCELL_DOUT_PIN , LOADCELL_SCK_PIN); //inicializacao e definicao dos pinos DT e SCK dentro do objeto ESCALA

  //realiza uma media entre leituras com a celula sem carga 
  float media_leitura = escala.read_average(); 
  Serial.print("Media de leituras com Celula sem carga: ");
  Serial.print(media_leitura);
  Serial.println();

  escala.tare(); //zera a escala
}

void loop ()
{
  escala.set_scale(fator_calibracao); //ajusta a escala para o fator de calibracao

  //verifica se o modulo esta pronto para realizar leituras
  if (escala.is_ready())
  {
    //mensagens de leitura no monitor serial
    Serial.print("Leitura: ");
    Serial.print(escala.get_units(), 1); //retorna a leitura da variavel escala com a unidade quilogramas
    Serial.print(" kg");
    Serial.print(" \t Fator de Calibracao = ");
    Serial.print(fator_calibracao);
    Serial.println();

  //alteracao do fator de calibracao
    if(Serial.available())
      {
        comando = Serial.read();
        switch (comando)
        {
          case 'x':
          fator_calibracao = fator_calibracao - 100;
          break;
          case 'c':
          fator_calibracao = fator_calibracao + 100;
          break;
          case 'v':
          fator_calibracao = fator_calibracao - 10;
          break;
          case 'b':
          fator_calibracao = fator_calibracao + 10;
          break;
          case 'n':
          fator_calibracao = fator_calibracao - 1;
          break;
          case 'm':
          fator_calibracao = fator_calibracao + 1;
          break;
        }
      }
    }
    else
    {
      Serial.print("HX-711 ocupado");
    }
  delay(TEMPO_ESPERA);
  
}
