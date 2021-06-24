import 'package:arctium/arctium.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) => MaterialApp(
        home: RegularInjector(),
      );
}

// -- Service interface

abstract class CounterService extends Disposable {
  ValueNotifier<int> get counterValue;
}

class CounterServiceImplementation extends CounterService {
  @override
  final counterValue = ValueNotifier(0);

  @override
  void onDispose() => counterValue.dispose();
}

// -- Injector widgets

class RegularInjector extends StatelessWidget {
  @override
  Widget build(BuildContext context) => Injector<CounterService>(
        service: CounterServiceImplementation(),
        builder: (context, service) => CounterBody(),
      );
}

// Shared UI

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
