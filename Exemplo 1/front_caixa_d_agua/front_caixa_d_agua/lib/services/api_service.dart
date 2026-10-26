import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/caixa_dagua.dart';

class ApiService {
  // Use 'http://10.0.2.2:8080' para emulador Android ou 'http://localhost:8080' para web/iOS
  static const String baseUrl = 'http://localhost:8080';

  Future<List<CaixaDAgua>> listar() async {
    final response = await http.get(Uri.parse('$baseUrl/listar'));
    if (response.statusCode == 200) {
      Iterable lista = json.decode(utf8.decode(response.bodyBytes));
      return lista.map((modelo) => CaixaDAgua.fromJson(modelo)).toList();
    } else {
      throw Exception('Falha ao carregar caixas d\'água');
    }
  }

  Future<List<CaixaDAgua>> buscarMarca(String marca) async {
    final response = await http.get(Uri.parse('$baseUrl/marcas/$marca'));
    if (response.statusCode == 200) {
      Iterable lista = json.decode(utf8.decode(response.bodyBytes));
      return lista.map((modelo) => CaixaDAgua.fromJson(modelo)).toList();
    } else {
      throw Exception('Falha ao buscar por marca');
    }
  }

  Future<void> salvar(CaixaDAgua caixa) async {
    final response = await http.post(
      Uri.parse('$baseUrl/salvar'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode(caixa.toJson()),
    );
    if (response.statusCode != 201 && response.statusCode != 200) {
      throw Exception('Erro ao salvar caixa d\'água');
    }
  }

  Future<void> excluir(int id) async {
    final response = await http.delete(Uri.parse('$baseUrl/excluir/$id'));
    if (response.statusCode != 204 && response.statusCode != 200) {
      throw Exception('Erro ao excluir caixa d\'água');
    }
  }
}
