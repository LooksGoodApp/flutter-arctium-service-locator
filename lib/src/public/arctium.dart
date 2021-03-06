import 'package:arctium/src/private/duplicatable_map.dart';
import 'package:arctium/src/private/dispose_queue.dart';
import 'package:arctium/src/public/disposable.dart';

/// Service locator.
///
/// Allows easy location of services, UI-oriented stack-based access for
/// services of the same class, auto-disposal of services in centralized
/// queue and O(1) complexity for every operation.
class Arctium extends Disposable {
  // MARK: - Private constructor
  Arctium._();

  /// Singleton instance of the service locator.
  static final instance = Arctium._();

  // MARK: - Private variables

  final _disposeQueue = DisposeQueue();
  final _servicesMap = DuplicatableMap();

  // MARK: - Public methods

  /// Registers the given service under the given type parameter in the
  /// service locator, creating a stack for service's type
  void register<T>(T service) => _servicesMap.add<T>(T.toString(), service);

  /// Un-registrates the last added service under the given type parameter, and
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

  /// Creates a new instance of service locator.
  ///
  /// It is advised to not use this method. Arctium supports storing different
  /// instances of a single class, and cases when you need a new instance are
  /// extremely rare.
  factory Arctium.create() => Arctium._();

  @override
  Future<void> onDispose() async {
    _servicesMap.values.forEach(_disposeQueue.send);
    await Future.delayed(Duration.zero);
    _disposeQueue.onDispose();
  }
}
