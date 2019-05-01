/// A console/commandline client to test if the Hexadoku solver using
/// recursion&backtracking strategy works
/// Author: yang.wilby@gmail.com
/// DateTime: 2019-04-30

import 'package:dartsudo/hexadoku.dart' as hexadoku;
import 'dart:io';
import 'package:args/args.dart';

const input = 'input';
const String hardCodedHexaIncomplete = """
---------------------
|45AB|E   |    | F7 |
|6   |  9 | 8  |   A|
|    |3   |   B| D  |
| 8  |  0C|43  | E 5|
---------------------
| 2 9|D3  |A C |   F|
|   4|  5E| D  |9   |
|8 1 |    |B F |  CE|
|BE 7| C 8|   2| 4 D|
---------------------
|2  8| 9  | A  |  E6|
|    | B  |9  E|4  7|
|3D A|  4 |    |    |
|5   |    | C03| BD |
---------------------
|C   |A82 |    |    |
|    | 039| 6D | 7 C|
|    |  1 | 0  | 69 |
|A  F|    |  9 | 8  |
---------------------
""";

main(List<String> arguments) async {

  String hexaToSolve;
  ArgResults argResults;

  // use command line arguments to tell where the problem is
  final parser = ArgParser()
    ..addOption("input", abbr: 'i', defaultsTo: 'hardCoded');
  argResults = parser.parse(arguments);

  final source = argResults["input"];

  if (source == "hardCoded") { // from the hard coded
    hexaToSolve = hardCodedHexaIncomplete;
  } else if (source == "console"){ // from stdin
    hexaToSolve = stdin.readLineSync();
  } else { //from file
    hexaToSolve = await File(source).readAsString();
  }
  String check = hexadoku.assureInputValid(hexaToSolve);
  if (check.isNotEmpty) {
    stderr.writeln('error: the line $check is in wrong format');
    exit(2);
  }

  final hexa = hexadoku.Hexadoku(hexaToSolve);

  //record how much time is consumed for the searching
  final stopwatch = Stopwatch()..start();

  if (hexa.SolveSudoku()) {
    hexadoku.printResult(hexa.grid);
  }
  print('time spent: ${stopwatch.elapsed}');

}



