import 'package:test/test.dart';
import 'package:dartsudo/hexadoku.dart' as hexadoku;
void main() {
  test('input line validation', () {
    expect(hexadoku.assureInputValid("|A  F|    |  9 | L  |"), isNotEmpty);
    expect(hexadoku.assureInputValid("|BE 7| C 8|   2| 4 D "), isNotEmpty);
    expect(hexadoku.assureInputValid("A|  F|    |  9 | 8  |"), isEmpty);
  });
}
