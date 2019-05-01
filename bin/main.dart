
import 'package:dartsudo/hexadoku.dart';
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
  assureInputValid(hexaToSolve);

  final hexa = Hexadoku(hexaToSolve);

  //record how much time is consumed for the searching
  final stopwatch = Stopwatch()..start();

  if (hexa.SolveSudoku()) {
    printResult(hexa.grid);
  }
  print('time spent: ${stopwatch.elapsed}');

}

// make sure the input follows right rule that will be used for parsing
void assureInputValid(String hexa) {
  var split = hexa.split('\n');
  // start with '|', then 4 digits of hexa code or whitespace, repeating 4 times,
  // and then an ending '|'
  var regExp = RegExp(r"^(\|[0123456789ABCDEF\s]{4}){4}\|");
  for (var line in split) {
    if (line.startsWith('|') && !regExp.hasMatch(line)) {
      stderr.writeln('error: the line $line is in wrong format');
      exit(2);
    }
  }
}

void printResult(List<List<int>> matrix) {
  print("--------------------------------");
  matrix.forEach((List<int> row) {
    List<String> rowStr = List();
    row.forEach((rune) {
      rowStr.add(String.fromCharCode(rune));
    });

    print(rowStr.join(" "));

  });
  print("--------------------------------");
}

