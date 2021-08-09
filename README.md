# arctium

Reliable UI-oriented service locator with great performance, Widget lifecycle bindings, queued auto disposal, and useful UI integrations.

## Motivation

Accessing state objects in UI is something that every app uses. In Flutter, generally, there are two approaches – context-based and locator-based. 

Context-based approaches are useful but can backfire. It is tricky to manipulate and obtain objects through context – it can be indirect, it cant have two services of the same class. There even can be no context at all!

Service locator approaches do not have that issue, but most of the existing packages suit UI needs poorly. But not **Arctium**!

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

Service can be located in three ways – using the `get<T>()` method, calling an instance of Arctium itself, or through `LocatorWidget<T>`, which will be discussed later.

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
await Future.delayed(Duration.zero); // The disposal is asynchronous, so it is needed to wait for the next iteration of The Event Loop.
print(sl.get<Service>().id) // Prints 'First'
```

### Auto-disposal 

One of the killer features of Arctium is the centralized, synchronous disposal queue with auto disposal. If your service extends or implements `Disposable`, Arctium will call the `onDispose()` method by sending it to the dispose queue.

That way, nothing clashes, and resources are properly released.

```dart
class DisposableService extends Disposable {
  @override 
  void onDispose() => print('Disposed DisposableService');
}

sl.register(DisposableService());
sl.remove<DisposableService>(); // Prints 'Disposed DisposableService'
```

## UI integrations

This is where Arctium shines. Existing solutions do not provide any UI bindings and feel a little "alien" when used in Flutter. Arctium provides a way to bind a service's lifecycle to the lifecycle of a widget, creating a single unit. 

When a bound widget, called Injector, is being inserted in the widget tree, the service's instance becomes available to every descendant widget, and when this widget disposes, service also becomes disposed through a centralized disposal queue. 

### Injection

To bound a service to a widget, the Injector widget must be used. The most basic use will look something like this.

```dart 
abstract class CounterService extends Disposable {
  ValueNotifier<int> get counterValue;
}

class CounterScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) => Injector(
        service: () => CounterServiceImplementation(),
        builder: (context, service) => /*some UI*/,
      );
}
```

Injector widget has a single type parameter, and as with a regular `.register<T>()` method, interface class can and should be specified. 

```dart
class CounterScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) => Injector<CounterService>(
        service: () => CounterServiceImplementation(),
        builder: (context, service) => /*some UI*/,
      );
}
```

### Location

To locate a registered service through regular registration or the `Injector` widget, `LocatorWidget` can be used. 

This widget not only provides a more explicit location of the services, but it is also more efficient than locating services by hand. On the first location, it establishes a reference to a service, and on every other rebuild of the widget, it will pass a service by the cached reference.

Of course, it is possible to use a regular location anywhere in the LocatorWidget, but such cases are rare.

Example usage of the `LocatorWidget` will look like this.

```dart
class CounterBody extends LocatorWidget<CounterService> {
  @override
  Widget build(BuildContext context, CounterService service) => Scaffold(
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ValueListenableBuilder(
                valueListenable: service.counterValue,
                builder: (_, value, __) => Text(value.toString()),
              ),
              OutlinedButton(
                onPressed: () => service.counterValue.value++,
                child: Text("Increment"),
              ),
            ],
          ),
        ),
      );
}
```