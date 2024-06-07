import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:quiver/iterables.dart';
import 'package:sudoku/blokChar.dart';
import 'package:sudoku/boxInner.dart';
import 'package:sudoku/focusClass.dart';
import 'package:sudoku_solver_generator/sudoku_solver_generator.dart';

class SudokuWidget extends StatefulWidget {
  const SudokuWidget({Key? key}) : super(key: key);

  @override
  State<SudokuWidget> createState() => _SudokuWidgetState();
}

class _SudokuWidgetState extends State<SudokuWidget> {

  List<BoxInner> boxInners = [];
  FocusClass focusClass = FocusClass();
  bool isFinish = false;
  String? tapBoxIndex;

  @override
  void initState() {
    generateSudoku();

    // TODO: implement initState
    super.initState();
  }

  void generateSudoku(){
    isFinish = false;
    focusClass = new FocusClass();
    tapBoxIndex = null;
    generatePuzzle();
    checkFinish();

    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          ElevatedButton(onPressed: () => generateSudoku(), child: Icon(Icons.refresh)),
        ],
      ),
      backgroundColor: Colors.blueAccent,
      body: SafeArea(
        child: Container(
          alignment: Alignment.center,
          child: Column(
            children: [
              SizedBox(
                  child: Container(
                margin: EdgeInsets.all(20),
                //height: 400,
                color: Colors.blueGrey,
                padding: EdgeInsets.all(5),
                width: double.maxFinite,
                alignment: Alignment.center,
                child: GridView.builder(
                    itemCount: boxInners.length,
                    shrinkWrap: true,
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 3,
                      childAspectRatio: 1,
                      crossAxisSpacing: 5,
                      mainAxisSpacing: 5,
                    ),
                    physics: ScrollPhysics(),
                    itemBuilder: (buildContext, index) {
                      BoxInner boxInner = boxInners[index];

                      return Container(
                        color: Colors.red.shade100,
                        alignment: Alignment.center,
                        child: GridView.builder(
                            itemCount: boxInner.blokChars.length,
                            shrinkWrap: true,
                            gridDelegate:
                                SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 3,
                              childAspectRatio: 1,
                              crossAxisSpacing: 2,
                              mainAxisSpacing: 2,
                            ),
                            physics: ScrollPhysics(),
                            itemBuilder: (buildContext, index) {
                              BlokChar blokChar = boxInner.blokChars[index];

                              return Container(
                                color: Colors.yellow.shade100,
                                alignment: Alignment.center,
                                child: Text("${blokChar.text}"),
                              );
                            }),
                      );
                    }),
              )),
              Expanded(
                child: Container(
                  padding: EdgeInsets.only(top: 20, bottom: 20, left: 10, right: 10),
                  alignment: Alignment.center,
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                        margin: EdgeInsets.only(right: 10),
                        child: GridView.builder(
                          itemCount: 9,
                          shrinkWrap: true,
                          scrollDirection: Axis.horizontal,
                          gridDelegate:
                              SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 3,
                            childAspectRatio: 1,
                            crossAxisSpacing: 5,
                            mainAxisSpacing: 5,
                          ),
                          physics: ScrollPhysics(),
                          itemBuilder: (buildContext, index) {
                            return ElevatedButton(
                              onPressed: () {},
                              child: Text("${index + 1}"),
                            );
                          },
                        ),
                      ),
                      Expanded(
                          child: Container(
                        child: ElevatedButton(
                          onPressed: () {},
                          child: Container(
                            child: Text("Clear"),
                          ),
                        ),
                      ))
                    ],
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  generatePuzzle(){}

  void checkFinish(){
    boxInners.clear();
    var sudokuGenerator = SudokuGenerator(emptySquares: 54);

    List<List<List<int>>> completes = partition(sudokuGenerator.newSudokuSolved,sqrt(sudokuGenerator.newSudoku.length).toInt()).toList();
    partition(sudokuGenerator.newSudoku,sqrt(sudokuGenerator.newSudoku.length).toInt()).toList().asMap().entries.forEach((entry){
      List<int> tempListCompletes = completes[entry.key].expand((element) => element).toList();
      List<int> tempList = entry.value.expand((element) => element).toList();

      tempList.asMap().entries.forEach((entryIn) {
        int index = entry.key * sqrt(sudokuGenerator.newSudoku.length).toInt() + (entryIn.key % 9).toInt() ~/ 3;
        if(boxInners.where((element) => element.index == index).length == 0) {
          boxInners.add(BoxInner(index, []));
        }

        BoxInner boxInner = boxInners.where((element) => element.index == index).first;

        boxInner.blokChars.add(BlokChar(
          entryIn. value == 0 ? "" : entryIn.value.toString(),
          index: boxInner.blokChars.length,
          isDefault: entryIn.value != 0,
          isCorrect: entryIn.value != 0,
          correctText: tempListCompletes[entryIn.key].toString(),
        ));
      });
    },);

  }
}
