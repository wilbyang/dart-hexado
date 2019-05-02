/// A recursion&backtracking approach in Dart language to solve Hexadoku grid
/// with all of the possible solutions
/// Author: yang.wilby@gmail.com
/// DateTime: 2019-05-02


class Location {
  final row;
  final column;
  const Location(this.row, this.column);
}

/// class contains the algorithm
class Doku {
  List<List<int>> grid;
  /// UNASSIGNED is used for empty cells in doku grid
  int UNASSIGNED; //32 is the rune code for whitespace, while 48 '0'

  /// N is used for size of grid. Size will be NxN
  int N; // 9 is for sudoku, 16 is for hexadoku

  /// N is used for size of sub grid.
  int SUB_GRID_N; // 3 is for sudoku, 4 is for hexadoku
  Set<int> standardSet;

  /// constructor, fill in the grid from input
  Doku({List<int> sequence, int UNASSIGNED, int N, SUB_GRID_N}) {
    this.N = N;
    this.SUB_GRID_N = SUB_GRID_N;
    this.UNASSIGNED = UNASSIGNED;
    if (N == 9) {
      standardSet = Set.from("123456789".runes);
    } else if(N == 16) {
      standardSet = Set.from("0123456789ABCDEF".runes);
    }
    this.grid = List.generate(N, (int row) {
      return List.generate(N, (int column) {
        int index = row * N + column;
        // use UNASSIGNED to represent empty cells
        return sequence[index];
      });
    });
  }

  List<List<int>> deepCloneList(List<List<int>> grid) {
    List<List<int>> newGrid = List();
    grid.forEach((row) {
      newGrid.add(List.from(row));
    });
    return newGrid;
  }

  Set<int> checkRow(List<List<int>> grid, row) {
    return standardSet.difference(Set<int>.from(grid[row]));
  }

  Set<int> checkColumn(List<List<int>> grid, column) {
    Set<int> columnSet = {};
    for (var row = 0; row < N; row++) {
      columnSet.add(grid[row][column]);
    }
    return standardSet.difference(columnSet);
  }

  Set<int> checkSubGrid(
      List<List<int>> grid, int subGridRow, int subGridColumn) {
    Set<int> subGridSet = {};

    for (var row = subGridRow * SUB_GRID_N;
        row < SUB_GRID_N + subGridRow * SUB_GRID_N;
        row++) {
      for (var column = subGridColumn * SUB_GRID_N;
          column < SUB_GRID_N + subGridColumn * SUB_GRID_N;
          column++) {
        subGridSet.add(grid[row][column]);
      }
    }
    return standardSet.difference(subGridSet);
  }

  Set<int> findCandidates(List<List<int>> grid, int row, int column) {
    final candidateColumnSet = checkColumn(grid, column);
    final candidateRowSet = checkRow(grid, row);
    final candidateSubGridSet =
        checkSubGrid(grid, row ~/ SUB_GRID_N, column ~/ SUB_GRID_N);

    final candidates = candidateColumnSet
        .intersection(candidateRowSet)
        .intersection(candidateSubGridSet);
    return candidates;
  }

  // the backbone here, use recursion and Backtracking strategy to solve the problem
  bool solveSudoku(List<List<int>> grid,) {
    for (var row = 0; row < N; row++) {
      for (var column = 0; column < N; column++) {
        var cell = grid[row][column];
        if (cell == UNASSIGNED) {
          var candidates = findCandidates(grid, row, column);
          if (candidates.isEmpty) {
            return false;
          }
          for (var candidate in candidates) {
            grid[row][column] = candidate;
            var smallerGrid = deepCloneList(grid);
            solveSudoku(smallerGrid);
          }
        }
        if (row == N - 1 && column == N - 1) {
          printResult(grid);
        }
      }
    }
    return true;
  }

  /// Returns a boolean which indicates whether it will be legal to assign
  /// num to the given row,col location.
  bool isFit(List<List<int>> grid, int row, int column, int num) {
    // Check if 'num' is not already placed in current row, current column and
    // current sub SUB_GRID_N x SUB_GRID_N  box
    bool taken = _takenInRow(grid, row, num) ||
        _takenInColumn(grid, column, num) ||
        _takenInSubGrid(grid, row ~/ SUB_GRID_N, column ~/ SUB_GRID_N, num);

    return !taken;
  }

  /// Searches the grid to find an entry that is still unassigned. If
  /// found, the reference parameters row, col will be set the location
  /// that is unassigned, and true is returned. If no unassigned entries
  /// remain, false is returned.
  Location _findUnassignedLocation(List<List<int>> grid) {
    for (var row = 0; row < N; row++) {
      for (var col = 0; col < N; col++) {
        if (grid[row][col] == UNASSIGNED) {
          return Location(row, col);
        }
      }
    }

    return Location(-1, -1);
  }

  /// Returns a boolean which indicates whether any assigned entry
  /// in the specified row matches the given number.
  bool _takenInRow(List<List<int>> grid, int row, int num) {
    for (var x in grid[row]) {
      if (x == num) {
        return true;
      }
    }
    return false;
  }

  /// Returns a boolean which indicates whether any assigned entry
  /// in the specified column matches the given number.
  bool _takenInColumn(List<List<int>> grid, int column, int num) {
    for (var row = 0; row < N; row++) {
      if (grid[row][column] == num) {
        return true;
      }
    }
    return false;
  }

  /// Returns a boolean which indicates whether any assigned entry
  /// within the specified 3x3 box matches the given number.
  bool _takenInSubGrid(
      List<List<int>> grid, int subGridRow, int subGridColumn, num) {
    for (var row = subGridRow * SUB_GRID_N;
        row < SUB_GRID_N + subGridRow * SUB_GRID_N;
        row++) {
      for (var column = subGridColumn * SUB_GRID_N;
          column < SUB_GRID_N + subGridColumn * SUB_GRID_N;
          column++) {
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
