import 'dart:async';

/// Abstract class for services that must be disposed on un-registration.
/// 
/// Only one method, [onDispose()], must be implemented, and it will be called 
/// in a centralized queue on service un-registration.
abstract class Disposable {
  FutureOr<void> onDispose();
}
