part of arctium;

/// Extensions of HashMap that allows storing items at the same key with
/// LIFO access.
///
/// For every key, an individual stack is created under the hood, allowing to
/// store any amount of values. Every operation has O(1) complexity.
class _DuplicatableMap {
  final _objectsMap = HashMap<String, List<dynamic>>();

  List<dynamic>? getStack(String key) => _objectsMap[key];

  int add<ValueType>(String key, ValueType value) {
    final stack = _objectsMap.putIfAbsent(key, () => <ValueType>[]);
    stack.add(value);
    return stack.length - 1;
  }

  ValueType? get<ValueType>(String key) {
    final stack = getStack(key);
    if (stack != null) return stack.last as ValueType;
    
  }

  bool remove(String key) {
    final stack = _objectsMap[key];
    if (stack == null || stack.isEmpty) return false;
    stack.removeLast();
    return true;
  }

  bool removeConcrete(String key, int index) {
    final stack = getStack(key);
    if (stack == null || stack.isEmpty || stack.length <= index) return false;
    stack.removeAt(index);
    return true;
  }

  @override
  String toString() => _objectsMap.toString();
}
