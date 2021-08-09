import 'dart:async';

import 'package:arctium/src/public/disposable.dart';

/// Provides centralized dispose queue that is used for un-registering services
/// inside Arctium.
/// 
/// It is guaranteed that services are disposed in the same order that they 
/// are added.
class DisposeQueue extends Disposable {
  late final _disposeController = StreamController<dynamic>(sync: true);
  late final StreamSubscription _disposeSubscription;

  DisposeQueue() {
    _disposeSubscription = _disposeController.stream.listen(_disposeService);
  }

  /// Disposer method that calls [onDispose()] if service is [Disposable].
  /// 
  /// Used as a listener to a [_disposeService]'s Stream.
  void _disposeService(dynamic service) {
    if (service is Disposable) {
      service.onDispose();
    }
  }

  /// Sends given service to a dispose queue by adding it to the 
  /// [_disposeController]'s sink.
  /// 
  /// If service is [Disposable], [Disposable.onDispose()] will be called.
  void send(dynamic service) => _disposeController.sink.add(service);

  @override
  void onDispose() {
    _disposeSubscription.cancel();
    _disposeController.close();
  }
}
