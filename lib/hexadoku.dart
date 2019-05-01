/// A recursion&backtracking approach in Dart language to solve Hexadoku grid
/// Author: yang.wilby@gmail.com
/// DateTime: 2019-04-30

/// UNASSIGNED is used for empty cells in hexadoku grid
const UNASSIGNED = 32; //32 is the rune code for whitespace

/// N is used for size of grid. Size will be NxN
const N = 16;

/// N is used for size of sub grid.
const SUB_GRID_N = 4;

/// class contains the algorithm
class Hexadoku {
  List<List<int>> grid;
  int toFillRow;
  int toFillColumn;

  /// constructor, fill in the grid from input
  Hexadoku(String hexa) {
    List<int> sequence = List<int>();
    var split = hexa.split('\n');

    for (var line in split) {
      if (line.startsWith('|')) {
        line = line.replaceAll(RegExp(r'\|'), '');
        sequence.addAll(line.runes);
      }
    }

    this.grid = List.generate(N, (int row) {
      return List.generate(N, (int column) {
        int index = row * N + column;
        // use UNASSIGNED to represent empty cells
        return sequence[index];
      });
    });

    this.toFillColumn = 0;
    this.toFillRow = 0;
  }


  // the backbone here, use recursion and Backtracking strategy to solve the problem
  bool SolveSudoku() {
    if (!_findUnassignedLocation()) {
      return true; // success!
    }

    // use two local variable to be stored in the frame, to assure the recursion
    // return correctly
    int row = toFillRow;
    int column = toFillColumn;

    // try digits 1 to 9
    for (int num in "0123456789ABCDEF".runes) {
      // if looks promising
      if (isFit(row, column, num)) {
        // make tentative assignment
        grid[row][column] = num;

        // return, if success, yay!
        if (SolveSudoku()) {
          return true;
        }
        // failure, unmake & try again
        grid[row][column] = UNASSIGNED;
      }
    }
    return false; // backtracking
  }
  /// Returns a boolean which indicates whether it will be legal to assign
  /// num to the given row,col location.
  bool isFit(int row, int column, int num) {

    // Check if 'num' is not already placed in current row, current column and
    // current sub SUB_GRID_N x SUB_GRID_N  box
    bool taken = _takenInRow(row, num) ||
         _takenInColumn(column, num) ||
         _takenInSubGrid(row ~/ SUB_GRID_N, column ~/ SUB_GRID_N, num);

    return !taken;
  }

  /// Searches the grid to find an entry that is still unassigned. If
  /// found, the reference parameters row, col will be set the location
  /// that is unassigned, and true is returned. If no unassigned entries
  /// remain, false is returned.
  bool _findUnassignedLocation() {
    for (var row = 0; row < N; row++) {
      for (var col = 0; col < N; col++) {
        if (grid[row][col] == UNASSIGNED) {
          toFillRow = row;
          toFillColumn = col;
          return true;
        }
      }
    }

    return false;
  }

  /// Returns a boolean which indicates whether any assigned entry
  /// in the specified row matches the given number.
  bool _takenInRow(int row, int num) {
    for (var x in grid[row]) {
      if (x == num) {
        return true;
      }
    }
    return false;
  }


  /// Returns a boolean which indicates whether any assigned entry
  /// in the specified column matches the given number.
  bool _takenInColumn(int column, int num) {
    for (var row = 0; row < N; row++) {
      if (grid[row][column] == num) {
        return true;
      }
    }
    return false;
  }


  /// Returns a boolean which indicates whether any assigned entry
  /// within the specified 3x3 box matches the given number.
  bool _takenInSubGrid(int subGridRow, int subGridColumn, num) {

    for (var row = subGridRow * SUB_GRID_N; row < SUB_GRID_N + subGridRow * SUB_GRID_N; row++) {
      for (var column = subGridColumn * SUB_GRID_N; column < SUB_GRID_N + subGridColumn * SUB_GRID_N; column++) {
        if (grid[row][column] == num) {
          return true;
        }
      }
    }
    return false;
  }

}

// make sure the input follows right rule that will be used for parsing
String assureInputValid(String hexa) {
  var split = hexa.split('\n');
  // start with '|', then 4 digits of hexa code or whitespace, repeating 4 times,
  // and then an ending '|'
  var regExp = RegExp(r"^(\|[0123456789ABCDEF\s]{4}){4}\|");
  for (var line in split) {
    if (line.startsWith('|') && !regExp.hasMatch(line)) {
      return line;

    }
  }
  return '';
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
