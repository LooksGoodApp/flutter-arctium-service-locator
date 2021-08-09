import 'package:flutter/material.dart';
import 'package:arctium/src/public/arctium.dart';

/// Widget that locates service under the given type parameter.
///
/// A [StatelessWidget] that locates service of type [T], providing
/// it as a parameter in the [build] method. Locating it by hand before
/// returning from build is equivalent, but requires more code.
abstract class LocatorWidget<T> extends StatefulWidget {
  const LocatorWidget({Key? key}) : super(key: key);

  Widget build(BuildContext context, T service);

  _LocatorWidgetState<T> createState() => _LocatorWidgetState<T>();
}

class _LocatorWidgetState<T> extends State<LocatorWidget<T>> {
  final _instance = Arctium.instance.get<T>();

  @override
  Widget build(BuildContext context) => widget.build(context, _instance);
}
