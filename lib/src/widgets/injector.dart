part of arctium;

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
  final Widget Function(T service) builder;

  Injector({
    required this.service,
    this.onInit,
    this.onDispose,
    required this.builder,
  });

  _InjectorState<T> createState() => _InjectorState<T>();
}

class _InjectorState<T> extends State<Injector<T>> {
  late final int _concreteKey;

  @override
  void initState() {
    super.initState();
    _concreteKey = Arctium.instance._register<T>(widget.service);
    if (widget.onInit != null) {
      widget.onInit!(widget.service);
    } 
  }

  @override
  void dispose() {
    if (widget.onDispose != null) {
      widget.onDispose!(widget.service);
    } 
    Arctium.instance._removeConcrete<T>(_concreteKey);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return widget.builder(widget.service);
  }
}
