part of arctium;

/// Widget that locates service under the given type parameter.
///
/// A [StatelessWidget] that locates service of type [ServiceType], providing
/// it as a parameter in the [build] method. Locating it by hand before
/// returning from build is equivalent, but requires more code.
abstract class LocatorWidget<ServiceType> extends StatefulWidget {
  Widget build(BuildContext context, ServiceType service);

  _LocatorWidgetState<ServiceType> createState() =>
      _LocatorWidgetState<ServiceType>();
}

class _LocatorWidgetState<ServiceType>
    extends State<LocatorWidget<ServiceType>> {
  
  final _instance = Arctium.instance<ServiceType>();

  @override
  Widget build(BuildContext context) => widget.build(context, _instance);
}
