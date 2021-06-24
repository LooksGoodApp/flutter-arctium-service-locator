import 'package:arctium/src/private/duplicatable_map.dart';
import 'package:test/expect.dart';
import 'package:test/scaffolding.dart';

void main() {
  group('Adding entries', () {
    test('Add single entry', () {
      final map = DuplicatableMap();
      map.add('Number', 0);
      expect(map.toString(), '{Number: [0]}');
    });

    test('Add two entries at different keys', () {
      final map = DuplicatableMap();
      map.add('Number', 0);
      map.add('Letter', 'A');
      expect(map.toString(), '{Number: [0], Letter: [A]}');
    });

    test('Add two entries at the same key', () {
      final map = DuplicatableMap();
      map.add('Number', 0);
      map.add('Number', 1);
      expect(map.toString(), '{Number: [0, 1]}');
    });
  });

  group('Getting entries', () {
    final map = DuplicatableMap();
    map.add('Single', 0);
    map.add('Double', 'First');
    map.add('Double', 'Second');
    test(
      'Get entry from single-entry stack',
      () => expect(map.get('Single'), 0),
    );

    test(
      'Get entry from stack of length 2',
      () => expect(map.get('Double'), 'Second'),
    );
  });

  group('Removing entries', () {
    test('Add and remove a single entry', () {
      final map = DuplicatableMap();
      map.add('Number', 0);
      map.remove('Number');
      expect(map.toString(), '{Number: []}');
    });

    test('Add two values and remove the last', () {
      final map = DuplicatableMap();
      map.add('Number', 0);
      map.add('Number', 1);
      map.remove('Number');
      expect(map.toString(), '{Number: [0]}');
    });

    test('Add one value and replace it with other', () {
      final map = DuplicatableMap();
      map.add('Number', 0);
      map.remove('Number');
      map.add('Number', 10);
      expect(map.toString(), '{Number: [10]}');
    });
  });
}
