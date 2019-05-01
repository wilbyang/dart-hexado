
/// A deductive&dynamic programming approach in Dart language to solve Hexadoku problem
/// Author: yang.wilby@gmail.com
/// DateTime: 2019-04-30

import 'dart:collection';

/// UNASSIGNED is used for empty cells in hexadoku grid
const UNFILLED = 32; //32 is the rune code for whitespace

/// N is used for size of grid. Size will be NxN
const N = 16;

/// N is used for size of sub grid.
const SUB_GRID_N = 4;

class Hexadoku {
  List<List<int>> grid;
  Map<String, List<int>> candidateMap;
  Queue<String> candidateMapMemory;
  final Set<int> standardSet =
      Set.from("0123456789ABCDEF".runes);

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
        // use UNFILLED to represent empty cells
        return sequence[index];
      });
    });

  }

  Set<int> checkRow(row) {
    return standardSet.difference(Set<int>.from(grid[row]));
  }

  Set<int> checkColumn(column) {
    Set<int> columnSet = {};
    for (var row = 0; row < 16; row++) {
      columnSet.add(grid[row][column]);
    }
    return standardSet.difference(column);
  }

  Set<int> checkSubGrid(int subGridRow, int subGridColumn) {
    Set<int> subGridSet = {};

    for (var row = subGridRow * SUB_GRID_N; row < SUB_GRID_N + subGridRow * SUB_GRID_N;
    row++) {
      for (var column = subGridColumn * SUB_GRID_N;
          column < SUB_GRID_N + subGridColumn * SUB_GRID_N;
          column++) {
        subGridSet.add(grid[row][column]);
      }
    }
    return standardSet.difference(subGridSet);
  }

  bool get isSolved {
    // each row should be valide, return quickly
    for (var row = 0; row < N; row++) {
      if (checkRow(row).isNotEmpty) {
        return false;
      }
    }

    // each column should be valid, return quickly
    for (var column = 0; column < N; column++) {
      if (checkColumn(column).isNotEmpty) {
        return false;
      }
    }

    // each 16 subgrid shoule be valid, return quickly
    for (var subGridRow = 0; subGridRow < SUB_GRID_N; subGridRow++) {
      for (var subGridColumn = 0; subGridColumn < SUB_GRID_N; subGridColumn++) {
        if (checkSubGrid(subGridRow, subGridColumn).isNotEmpty) {
          return false;
        }
      }
    }

    return true;
  }

  //final List<List<int>> grid = List.generate(16, (int row) => List<int>.generate(16, (int column) => row * column));
  void solveSudoku() {
    this.updateCandidates();

    while (this.candidateMap.isNotEmpty || this.candidateMapMemory.isNotEmpty) {
      if (this.candidateMap.isNotEmpty) {
        this.probe();
        this.updateCandidates();
      } else {
        if (isSolved) {
          print(grid);
        }
        var candidate = this.candidateMapMemory.first;
        var split = candidate.split('|');

        var rowColumn = split[0];
        var candidates = split[1];

        split = rowColumn.split(',');
        var row = int.parse(split[0]);
        var column = int.parse(split[1]);


        this.candidateMapMemory.removeFirst();
        if (candidates.isEmpty) {
          this.grid[row][column] = 0;
        } else {

          var candidateValue = candidates.substring(0, 1);
          this
              .candidateMapMemory
              .addFirst("$rowColumn|${candidates.substring(1)}");

          this.grid[row][column] = int.parse(candidateValue);
          print("position:$rowColumn fill in $candidateValue");
          this.updateCandidates();
        }



        print(this.candidateMapMemory);
      }
    }
  }

  /// try to pick up position has the most candidates, fix it with one value,
  /// put the left options in the backtracking path
  void probe() {


    var sortedKeys = this.candidateMap.keys.toList(growable: false)
      ..sort((k1, k2) =>
          this.candidateMap[k2].length.compareTo(this.candidateMap[k1].length));
    var first = sortedKeys.first;

    var split = first.split(",");
    int row = int.parse(split.first);
    int column = int.parse(split.last);
    int candidate = this.candidateMap[first].first;
    this.grid[row][column] = candidate;

    print("position:$first fill in $candidate");
    this
        .candidateMapMemory
        .addFirst("$first|${this.candidateMap[first].join().substring(1)}");
    print("backtracking path: $candidateMapMemory");
  }

  void updateCandidates() {
    bool toPropagate = false;
    do {
      this.candidateMap = {};
      toPropagate = false;
      for (var row = 0; row < N; row++) {
        for (var column = 0; column < N; column++) {
          if (grid[row][column] < 1) {
            final candidateColumnSet = checkColumn(column);
            final candidateRowSet = checkRow(row);
            final candidateSubGridSet = checkSubGrid(row ~/ SUB_GRID_N, column ~/ SUB_GRID_N);

            final candidates = candidateColumnSet
                .intersection(candidateRowSet)
                .intersection(candidateSubGridSet);

            if (candidates.length == 1) {
              grid[row][column] = candidates
                  .first; //fill in the certain ones, as it has impact on the previous one, we need to loop to check
              toPropagate = true;
            } else if (candidates.length > 1) {
              this.candidateMap["$row,$column"] = candidates.toList();
            }
          }
        }
      }
    } while (toPropagate);
  }

}

