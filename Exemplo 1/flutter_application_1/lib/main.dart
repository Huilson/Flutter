import 'package:flutter/material.dart';

void main() {
  runApp(
    MaterialApp(
      home: Scaffold(
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'Olá mundo!',
                style: TextStyle(fontSize: 50),
                softWrap: true,
                textAlign: TextAlign.center,
              ),
              Text(
                'Que aula mais top!',
                style: TextStyle(
                  fontSize: 20,
                  color: Color.fromARGB(255, 0, 0, 255),
                  overflow: TextOverflow.ellipsis,
                ),
                maxLines: 1,
              ),
            ],
          ),
        ),
      ),
    ),
  );
}
