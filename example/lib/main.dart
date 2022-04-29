import 'package:filesaverz/filesaver.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MaterialApp(
      title: 'File Saver Example',
      debugShowCheckedModeBanner: false,
      home: MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Material(
          color: Colors.blue,
          child: InkWell(
            onTap: () {
              FileSaver(
                initialFileName: 'New File',
                fileTypes: const ['txt'],
              ).writeAsString('Hello World', context: context);
            },
            child: const Padding(
              padding: EdgeInsets.all(10),
              child: Text(
                'Browse',
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
