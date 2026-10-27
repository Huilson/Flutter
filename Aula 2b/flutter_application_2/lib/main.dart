
import 'package:flutter/material.dart';
import 'package:flutter/gestures.dart';

void main() {
  runApp(
    const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: MinhaTela(),
    ),
  );
}

class MinhaTela extends StatefulWidget {
  const MinhaTela({super.key});

  @override
  State<MinhaTela> createState() => _MinhaTelaState();
}

class _MinhaTelaState extends State<MinhaTela> {
  String? mensagem;

  late final TapGestureRecognizer _reconhecedor =
      TapGestureRecognizer()
        ..onTap = () {
          debugPrint('Você clicou em "mais top!"');
        };

  void alterarTexto(String novoTexto) {
    setState(() {
      mensagem = novoTexto;
    });
  }

  @override
  void dispose() {
    _reconhecedor.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Minha aplicação'),
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
        actions: [
          PopupMenuButton<String>(
            tooltip: 'Abrir menu',
            icon: const Icon(Icons.more_vert),
            onSelected: (String opcao) {
              alterarTexto('$opcao selecionado');
            },
            itemBuilder: (BuildContext context) {
              return [
                const PopupMenuItem<String>(
                  value: 'Início',
                  child: Text('Início'),
                ),
                const PopupMenuItem<String>(
                  value: 'Configurações',
                  child: Text('Configurações'),
                ),
                const PopupMenuItem<String>(
                  value: 'Sobre',
                  child: Text('Sobre'),
                ),
              ];
            },
          ),
        ],
      ),

      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              // 1. RichText principal
              RichText(
                textAlign: TextAlign.center,
                softWrap: true,
                text: TextSpan(
                  style: const TextStyle(
                    fontSize: 30,
                    color: Colors.black,
                  ),
                  children: [
                    if (mensagem == null) ...[
                      const TextSpan(text: 'Olá '),
                      const TextSpan(
                        text: 'mundo',
                        style: TextStyle(
                          fontSize: 40,
                          color: Colors.blue,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const TextSpan(
                        text: ' Flutter!',
                        style: TextStyle(
                          color: Colors.green,
                          fontStyle: FontStyle.italic,
                        ),
                      ),
                    ] else ...[
                      TextSpan(
                        text: mensagem!,
                        style: const TextStyle(
                          fontSize: 30,
                          color: Colors.black,
                        ),
                      ),
                    ],
                  ],
                ),
              ),

              const SizedBox(height: 20),

              // 2. Estilos de texto
              RichText(
                textAlign: TextAlign.center,
                text: const TextSpan(
                  style: TextStyle(
                    fontSize: 20,
                    color: Colors.black,
                  ),
                  children: [
                    TextSpan(
                      text: 'Negrito ',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 30,
                      ),
                    ),
                    TextSpan(
                      text: 'Itálico ',
                      style: TextStyle(
                        fontStyle: FontStyle.italic,
                      ),
                    ),
                    TextSpan(
                      text: 'Sublinhado ',
                      style: TextStyle(
                        decoration: TextDecoration.underline,
                      ),
                    ),
                    TextSpan(
                      text: 'Tachado',
                      style: TextStyle(
                        decoration: TextDecoration.lineThrough,
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 16),

              // 3. Texto clicável
              RichText(
                textAlign: TextAlign.center,
                text: TextSpan(
                  style: const TextStyle(
                    fontSize: 20,
                    color: Colors.black,
                  ),
                  children: [
                    const TextSpan(text: 'Que aula '),
                    TextSpan(
                      text: 'mais top!',
                      style: const TextStyle(
                        color: Colors.blue,
                        fontWeight: FontWeight.bold,
                        decoration: TextDecoration.underline,
                      ),
                      recognizer: _reconhecedor,
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 16),

              // 4. Ícone dentro do texto
              RichText(
                textAlign: TextAlign.center,
                text: const TextSpan(
                  style: TextStyle(
                    fontSize: 22,
                    color: Colors.black,
                  ),
                  children: [
                    TextSpan(text: 'Flutter é '),
                    WidgetSpan(
                      alignment: PlaceholderAlignment.middle,
                      child: Icon(
                        Icons.favorite,
                        color: Colors.red,
                        size: 24,
                      ),
                    ),
                    TextSpan(text: ' incrível!'),
                  ],
                ),
              ),

              const SizedBox(height: 16),

              // 5. Limite de linhas
              SizedBox(
                width: 250,
                child: RichText(
                  textAlign: TextAlign.center,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  text: const TextSpan(
                    style: TextStyle(
                      fontSize: 18,
                      color: Colors.black,
                    ),
                    children: [
                      TextSpan(
                        text: 'Este é um texto de exemplo ',
                      ),
                      TextSpan(
                        text: 'com destaque!',
                        style: TextStyle(
                          color: Colors.blue,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      TextSpan(
                        text:
                            ' Este trecho adicional demonstra o limite de linhas.',
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 24),

              // 6. ElevatedButton
              ElevatedButton(
                onPressed: () {
                  alterarTexto('ElevatedButton pressionado');
                },
                child: const Text('ElevatedButton'),
              ),

              // 7. IconButton
              IconButton(
                onPressed: () {
                  alterarTexto('IconButton pressionado');
                },
                icon: const Icon(
                  Icons.touch_app,
                  size: 32,
                ),
                tooltip: 'Pressione o IconButton',
              ),
            ],
          ),
        ),
      ),

      // 8. FloatingActionButton
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          alterarTexto('FloatingActionButton pressionado');
        },
        tooltip: 'Pressione o botão flutuante',
        child: const Icon(Icons.add),
      ),
    );
  }
}