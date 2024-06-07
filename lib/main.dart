import 'package:flutter/material.dart';
import 'package:sudoku/sudokuWidget.dart';

void main(){
  runApp(const Sudoku());
}

class Sudoku extends StatelessWidget {
  const Sudoku({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Sudoku App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const SudokuWidget(),
    );
  }
}
