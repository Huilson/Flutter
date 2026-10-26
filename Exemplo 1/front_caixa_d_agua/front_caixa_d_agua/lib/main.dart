import 'package:flutter/material.dart';
import 'models/caixa_dagua.dart';
import 'services/api_service.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Gerenciador de Caixas d\'Água',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: const CaixaDAguaPage(),
    );
  }
}

class CaixaDAguaPage extends StatefulWidget {
  const CaixaDAguaPage({super.key});

  @override
  State<CaixaDAguaPage> createState() => _CaixaDAguaPageState();
}

class _CaixaDAguaPageState extends State<CaixaDAguaPage> {
  final ApiService apiService = ApiService();
  late Future<List<CaixaDAgua>> futureCaixas;
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _carregarCaixas();
  }

  void _carregarCaixas() {
    setState(() {
      futureCaixas = apiService.listar();
    });
  }

  void _buscarPorMarca(String marca) {
    setState(() {
      if (marca.isEmpty) {
        futureCaixas = apiService.listar();
      } else {
        futureCaixas = apiService.buscarMarca(marca);
      }
    });
  }

  void _abrirFormulario([CaixaDAgua? caixa]) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) => FormularioCaixaModal(
        onSalvo: () {
          _carregarCaixas();
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Gerenciador de Caixas d\'Água'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _carregarCaixas,
          ),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                labelText: 'Pesquisar por marca',
                prefixIcon: const Icon(Icons.search),
                border: const OutlineInputBorder(),
                suffixIcon: IconButton(
                  icon: const Icon(Icons.clear),
                  onPressed: () {
                    _searchController.clear();
                    _buscarPorMarca('');
                  },
                ),
              ),
              onChanged: _buscarPorMarca,
            ),
          ),
          Expanded(
            child: FutureBuilder<List<CaixaDAgua>>(
              future: futureCaixas,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return Center(child: Text('Erro: ${snapshot.error}'));
                } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return const Center(
                      child: Text('Nenhuma caixa d\'água encontrada.'));
                }

                final caixas = snapshot.data!;
                return ListView.builder(
                  itemCount: caixas.length,
                  itemBuilder: (context, index) {
                    final caixa = caixas[index];
                    return Card(
                      margin: const EdgeInsets.symmetric(
                          horizontal: 8, vertical: 4),
                      child: ListTile(
                        title: Text('${caixa.marca} - ${caixa.modelo}'),
                        subtitle: Text(
                          'Preço: R${caixa.preco.toStringAsFixed(2)}\nMaterial: ${caixa.material} | Cor: ${caixa.cor}',
                        ),
                        isThreeLine: true,
                        trailing: IconButton(
                          icon: const Icon(Icons.delete, color: Colors.red),
                          onPressed: () async {
                            try {
                              await apiService.excluir(caixa.id!);
                              _carregarCaixas();
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                    content: Text('Excluído com sucesso!')),
                              );
                            } catch (e) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(content: Text('Erro ao excluir: $e')),
                              );
                            }
                          },
                        ),
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _abrirFormulario(),
        child: const Icon(Icons.add),
      ),
    );
  }
}

// Formulário simples em Modal para cadastro
class FormularioCaixaModal extends StatefulWidget {
  final VoidCallback onSalvo;
  const FormularioCaixaModal({super.key, required this.onSalvo});

  @override
  State<FormularioCaixaModal> createState() => _FormularioCaixaModalState();
}

class _FormularioCaixaModalState extends State<FormularioCaixaModal> {
  final _formKey = GlobalKey<FormState>();
  final ApiService _apiService = ApiService();

  final _marcaController = TextEditingController();
  final _modeloController = TextEditingController();
  final _dimensaoController = TextEditingController(); // ex: 100,200
  final _corController = TextEditingController();
  final _materialController = TextEditingController();
  final _formatoController = TextEditingController();
  final _precoController = TextEditingController();

  bool _salvando = false;

  void _salvar() async {
    if (_formKey.currentState!.validate()) {
      setState(() => _salvando = true);
      try {
        List<double> dimensoes = _dimensaoController.text
            .split(',')
            .map((e) => double.tryParse(e.trim()) ?? 0.0)
            .toList();

        CaixaDAgua novaCaixa = CaixaDAgua(
          marca: _marcaController.text,
          modelo: _modeloController.text,
          dimensao: dimensoes,
          cor: _corController.text,
          material: _materialController.text,
          formato: _formatoController.text,
          preco: double.parse(_precoController.text.replaceAll(',', '.')),
        );

        await _apiService.salvar(novaCaixa);
        widget.onSalvo();
        Navigator.pop(context);
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Erro ao salvar: $e')),
        );
      } finally {
        setState(() => _salvando = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
        left: 16,
        right: 16,
        top: 16,
      ),
      child: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text('Nova Caixa d\'Água',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              TextFormField(
                  controller: _marcaController,
                  decoration: const InputDecoration(labelText: 'Marca'),
                  validator: (v) => v!.isEmpty ? 'Campo obrigatório' : null),
              TextFormField(
                  controller: _modeloController,
                  decoration: const InputDecoration(labelText: 'Modelo'),
                  validator: (v) => v!.isEmpty ? 'Campo obrigatório' : null),
              TextFormField(
                  controller: _dimensaoController,
                  decoration: const InputDecoration(
                      labelText:
                          'Dimensões (separadas por vírgula, ex: 1.5, 2.0)'),
                  validator: (v) => v!.isEmpty ? 'Campo obrigatório' : null),
              TextFormField(
                  controller: _corController,
                  decoration: const InputDecoration(labelText: 'Cor'),
                  validator: (v) => v!.isEmpty ? 'Campo obrigatório' : null),
              TextFormField(
                  controller: _materialController,
                  decoration: const InputDecoration(labelText: 'Material'),
                  validator: (v) => v!.isEmpty ? 'Campo obrigatório' : null),
              TextFormField(
                  controller: _formatoController,
                  decoration: const InputDecoration(labelText: 'Formato'),
                  validator: (v) => v!.isEmpty ? 'Campo obrigatório' : null),
              TextFormField(
                  controller: _precoController,
                  decoration: const InputDecoration(labelText: 'Preço (R\$)'),
                  keyboardType: TextInputType.number,
                  validator: (v) => v!.isEmpty ? 'Campo obrigatório' : null),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: _salvando ? null : _salvar,
                child: _salvando
                    ? const CircularProgressIndicator()
                    : const Text('Salvar'),
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}
