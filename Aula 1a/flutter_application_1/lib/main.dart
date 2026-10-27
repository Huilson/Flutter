import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(
    MaterialApp(
      home: MinhaTela(),
    ),
  );
}

class MinhaTela extends StatefulWidget {
  @override
  State<MinhaTela> createState() => _MinhaTelaState();
}

class _MinhaTelaState extends State<MinhaTela> {
  String texto = 'Olá Mundo!';

  void alterarTexto() {
    setState(() {
      texto = 'Botão pressionado!';
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            RichText(
                textAlign: TextAlign.center,
                text: TextSpan(
                    style: TextStyle(
                      fontSize: 50,
                      color: Colors.blue,
                    ),
                    children: [
                      if (texto == "Olá Mundo!") ...[
                        TextSpan(text: 'Olá '),
                        TextSpan(
                            text: 'Mundo!',
                            style: TextStyle(
                                color: Colors.black,
                                fontSize: 40,
                                fontWeight: FontWeight.bold))
                      ] else
                        TextSpan(text: texto)
                    ])),
            ElevatedButton(
              onPressed: alterarTexto,
              child: Text('Clique aqui!'),
            ),
          ],
        ),
      ),
    );
  }
}
