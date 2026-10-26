enum Cor { AZUL, BRANCA, PRETA, CINZA } // Ajuste conforme o seu enum no backend

enum Material {
  POLIETILENO,
  FIBRA_DE_VIDRO,
  ACO_INOX
} // Ajuste conforme necessário

class CaixaDAgua {
  final int? id;
  final String marca;
  final String modelo;
  final List<double> dimensao;
  final String cor; // Ou Enum dependendo de como serializa
  final String material;
  final String formato;
  final double preco;

  CaixaDAgua({
    this.id,
    required this.marca,
    required this.modelo,
    required this.dimensao,
    required this.cor,
    required this.material,
    required this.formato,
    required this.preco,
  });

  factory CaixaDAgua.fromJson(Map<String, dynamic> json) {
    return CaixaDAgua(
      id: json['id'],
      marca: json['marca'] ?? '',
      modelo: json['modelo'] ?? '',
      dimensao: json['dimensao'] != null
          ? List<double>.from(json['dimensao'].map((x) => x.toDouble()))
          : [],
      cor: json['cor']?.toString() ?? '',
      material: json['material']?.toString() ?? '',
      formato: json['formato'] ?? '',
      preco: json['preco'] != null ? (json['preco'] as num).toDouble() : 0.0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      if (id != null) 'id': id,
      'marca': marca,
      'modelo': modelo,
      'dimensao': dimensao,
      'cor': cor,
      'material': material,
      'formato': formato,
      'preco': preco,
    };
  }
}
