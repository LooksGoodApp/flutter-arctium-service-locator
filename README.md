# arctium

Reliable UI-oriented service locator with great performance, Widget lifecycle bindings, queued auto disposal and useful UI integrations.

## Motivation

Accessing state object in UI is something that every app uses. In Flutter, generally, there are two approaches – context-based and locator-based. 

Context-based approaches are useful, but can backfire. It is tricky to manipulate and obtain objects through context – it can be indirect, it cant have two services of the same class. There even can be no context at all!

Service locator approaches does not have that issue, but most of the existing packages suit UI needs poorly. But not **Arctium**!

## Getting started

Here are listed basic operations that Arctium can perform.

### Registration 

To register some service in Arctium, its instance is passed to the `register<T>()` method.

```dart
Arctium.instance.register(Service());
```

To reduce verbosity, it is possible to pass a reference of Arctium instance to a variable.

```dart
final sl = Arctium.instance;
```

Arctium allows storing several instances of the same class with LIFO access.

```dart
sl.register(Service(id: 'First'));
sl.register(Service(id: 'Second'));
print(sl.get<Service>().id) // Prints 'Second'
```

Optionally, services can be registered under their parent-classes types.

```dart 
abstract class Parent {}

class Child extends Parent {}

sl.register<Parent>(Child());

sl.get<Parent>();
sl.get<Child>(); // Throws an exception
```

### Location 

Service can be located in three ways – using `get<T>()` method, calling an instance of Arctium itself, or through `LocatorWidget<T>`, which will be discussed later.

```dart
sl.register(Service());
final service = sl.get<Service>();
final sameService = sl<Service>();
```

### Deregistration

Deregistration works through type parameters and method `remove<T>()`

```dart 
sl.register(Service());
sl.remove<Service>();
```

Since Arctium supports same-class registration with LIFO access, deregistration works in the same manner.

```dart
sl.register(Service(id: 'First'));
sl.register(Service(id: 'Second'));
print(sl.get<Service>().id) // Prints 'Second'
sl.remove<Service>();
print(sl.get<Service>().id) // Prints 'First'
```

### Auto-disposal 

One of the killer-features of Arctium is the centralized, synchronous dispose queue with auto disposal. If your service extends or implements `Disposable`, arctium will call the `onDispose()` method by sending it to the dispose queue.

That way, nothing clashes and resources are properly released.

```dart
class DisposableService extends Disposable {
  @override 
  void onDispose() => print('Disposed DisposableService');
}

sl.register(DisposableService());
sl.remove<DisposableService>(); // Prints 'Disposed DisposableService'
```

## UI integrations

### Injection

### Location