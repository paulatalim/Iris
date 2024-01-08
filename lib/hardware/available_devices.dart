/// Classe com as propriedades dos dispositivos
class DispositivosDisponivel {
  String nome;
  late String imagePath;
  String? status;

  DispositivosDisponivel({
      required this.nome, 
      required imageName, 
      this.status}) 
  {
    status = status ?? '';
    imagePath = 'assets/images/$imageName.png';
  }
}

/// Lista dos dispositivos diponiveis para conectar no hardware
List<DispositivosDisponivel> dispositivo = [
  DispositivosDisponivel(
      nome: "Selecione um\ndispositivo",
      imageName: 'hardware',
      status: "Status"
  ),

  DispositivosDisponivel(
      nome: "ESP 32", 
      imageName: 'esp32', 
  ),

  DispositivosDisponivel(
      nome: "Termômetro", 
      imageName: 'termometro', 
  ),

  DispositivosDisponivel(
      nome: "Sensor de Altura", 
      imageName: 'sensor',
  ),

  DispositivosDisponivel(
      nome: "Balança", 
      imageName: 'balanca',
  )
];