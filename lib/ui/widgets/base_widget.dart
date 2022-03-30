import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:quiz_app/services/service_locator.dart';

class BaseWidget<T extends ChangeNotifier> extends StatefulWidget {
  final Widget Function(BuildContext context, T value, Widget? child) builder;
  final Function(T)? onModelReady;
  final Function(T)? onDispose;

  const BaseWidget({
    Key? key,
    required this.builder,
    this.onModelReady,
    this.onDispose,
  }) : super(key: key);

  @override
  _BaseWidgetState<T> createState() => _BaseWidgetState<T>();
}

class _BaseWidgetState<T extends ChangeNotifier> extends State<BaseWidget<T>>
    with AutomaticKeepAliveClientMixin {
  final T model = ServiceLocator.resolve<T>();

  @override
  void initState() {
    if (widget.onModelReady != null) {
      widget.onModelReady!(model);
    }
    super.initState();
  }

  @override
  void dispose() {
    if (widget.onDispose != null) {
      widget.onDispose!(model);
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return ChangeNotifierProvider<T>(
      create: (context) => model,
      child: Consumer<T>(builder: widget.builder),
    );
  }

  @override
  bool get wantKeepAlive => true;
}
