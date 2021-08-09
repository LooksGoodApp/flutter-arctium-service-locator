import 'package:flutter/material.dart';
import 'package:arctium/src/public/arctium.dart';

/// Non-UI Injector widget
///
/// Registers the given service under the given type parameter, making it
/// available for every descendant widget. Service becomes bound to Injectors
/// lifecycle, registering and initializing on Injector's [onInit()], and
/// disposing on Injector's [onDispose()]
class Injector<T> extends StatefulWidget {
  final T service;
  final void Function(T service)? onInit;
  final void Function(T service)? onDispose;
  final Widget Function(BuildContext context, T service) builder;

  Injector({
    required this.service,
    this.onInit,
    this.onDispose,
    required this.builder,
  });

  _InjectorState<T> createState() => _InjectorState<T>();
}

class _InjectorState<T> extends State<Injector<T>> {
  @override
  void initState() {
    super.initState();
    Arctium.instance.register<T>(widget.service);
    if (widget.onInit != null) widget.onInit!(widget.service);
  }

  @override
  void dispose() {
    if (widget.onDispose != null) widget.onDispose!(widget.service);
    Arctium.instance.remove<T>();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => widget.builder(context, widget.service);
}
