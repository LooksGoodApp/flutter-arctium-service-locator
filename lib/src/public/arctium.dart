part of arctium;

/// Service locator.
///
/// Allows easy location of services, UI-oriented stack-based access for
/// services of the same class, auto-disposal of services in centralized
/// queue and O(1) complexity for every operation.
class Arctium {
  // MARK: - Private constructor
  Arctium._();

  /// Singleton instance of the service locator.
  static final instance = Arctium._();

  // MARK: - Private variables

  final _disposeQueue = _DisposeQueue();
  final _servicesMap = _DuplicatableMap();

  // MARK: - Private methods

  /// Registers the given service under the given type parameter in the
  /// service locator, creating a stack for service's type and returns a key 
  /// in stack `T`
  int _register<T>(T service) => _servicesMap.add<T>(T.toString(), service);

  /// Deregisters service in stack `T` under the given key, sending it to the
  /// dispose queue
  void _removeConcrete<T>(int index) {
    final service = get<T>();
    _servicesMap.removeConcrete(T.toString(), index);
    _disposeQueue.send(service);
  }

  // MARK: - Public methods

  /// Registers the given service under the given type parameter in the
  /// service locator, creating a stack for service's type
  void register<T>(T service) => _register<T>(service);

  /// Un-registrates a last added services under the given type parameter, and
  /// calls the [onDispose()] method if service is [Disposables]
  void remove<T>() {
    final service = get<T>();
    _servicesMap.remove(T.toString());
    _disposeQueue.send(service);
  }

  /// Locates the last added service of the given type parameter.
  ///
  /// Throws an Exception if requested service is not registered
  T get<T>() {
    final service = _servicesMap.get<T>(T.toString());
    if (service == null) throw Exception("$T is not registered in Arctium");
    return service;
  }

  T call<T>() => get<T>();
}
