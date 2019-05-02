/// A console/commandline client to test if the Hexadoku solver using
/// recursion&backtracking strategy works
/// Author: yang.wilby@gmail.com
/// DateTime: 2019-04-30

import 'package:dartsudo/doku_all.dart' as doku;
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


final List<int> easySudokuSequence = List()
  ..addAll("002801070".runes)
  ..addAll("400000001".runes)
  ..addAll("508700904".runes)
  ..addAll("000650140".runes)
  ..addAll("620000390".runes)
  ..addAll("170038260".runes)
  ..addAll("253487619".runes)
  ..addAll("006309752".runes)
  ..addAll("091500483".runes);

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
  String check = doku.assureInputValid(hexaToSolve);
  if (check.isNotEmpty) {
    stderr.writeln('error: the line $check is in wrong format');
    exit(2);
  }
  List<int> hexaSequence = List<int>();
  var split = hexaToSolve.split('\n');

  for (var line in split) {
    if (line.startsWith('|')) {
      line = line.replaceAll(RegExp(r'\|'), '');
      hexaSequence.addAll(line.runes);
    }
  }

  // this is an sudoku
  final sudoku = doku.Doku(sequence: easySudokuSequence, UNASSIGNED: 48, N: 9, SUB_GRID_N: 3);

  // this is an hexadoku
  final hexa = doku.Doku(sequence: hexaSequence, UNASSIGNED: 32, N: 16, SUB_GRID_N: 4);

  //record how much time is consumed for the searching
  final stopwatch = Stopwatch()..start();

  //hexa.solveSudoku(hexa.grid);

  // if you want run easy sudoku
  sudoku.solveSudoku(sudoku.grid);
  print('time spent: ${stopwatch.elapsed}');

}



