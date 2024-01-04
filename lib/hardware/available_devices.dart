/// Classe com as propriedades dos dispositivos
class DispositivosDisponivel {
  String nome;
  String imagePath;
  String? status;

  DispositivosDisponivel({
      required this.nome, 
      required this.imagePath, 
      this.status}) 
  {
    status = status ?? '';
  }
}

/// Lista dos dispositivos diponiveis para conectar no hardware
List<DispositivosDisponivel> dispositivo = [
  DispositivosDisponivel(
      nome: "Selecione um\ndispositivo",
      imagePath: 'assets/images/hardware.png',
      status: "Status"
  ),

  DispositivosDisponivel(
      nome: "ESP 32", 
      imagePath: 'assets/images/esp32.png', 
  ),

  DispositivosDisponivel(
      nome: "Termômetro", 
      imagePath: 'assets/images/termometro.png', 
  ),

  DispositivosDisponivel(
      nome: "Sensor de Altura", 
      imagePath: 'assets/images/sensor.png',
  ),

  DispositivosDisponivel(
      nome: "Balança", 
      imagePath: 'assets/images/balanca.png',
  )
];