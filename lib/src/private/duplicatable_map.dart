import 'dart:collection';

/// Extensions of HashMap that allows storing items at the same key with
/// LIFO access.
///
/// For every key, an individual stack is created under the hood, allowing to
/// store any amount of values. Every operation has O(1) complexity.
class DuplicatableMap {
  final _objectsMap = HashMap<String, List<dynamic>>();

  List<dynamic>? _getStack(String key) => _objectsMap[key];

  void add<ValueType>(String key, ValueType value) =>
      _objectsMap.putIfAbsent(key, () => <ValueType>[])..add(value);

  ValueType? get<ValueType>(String key) {
    final stack = _getStack(key);
    if (stack != null) return stack.last as ValueType;
  }

  bool remove(String key) {
    final stack = _objectsMap[key];
    if (stack == null || stack.isEmpty) return false;
    stack.removeLast();
    return true;
  }

  @override
  String toString() => _objectsMap.toString();

  @override
  bool operator ==(o) => o is DuplicatableMap && _objectsMap == o._objectsMap;

  @override
  int get hashCode => _objectsMap.hashCode;
}
