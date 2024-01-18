import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../constants/enums/connectivity_status.dart';
import '../constants/enums/view_state.dart';
import '../core/locator.dart';
import '../viewmodels/base.dart';
import 'app_theme.dart';
import 'views/no_internet.dart';

class BaseView<T extends BaseViewModel> extends StatefulWidget {
  const BaseView({
    required this.builder,
    this.onModelReady,
    this.onModelReadyAsync,
    this.onModelRefresh,
    this.onModelDestroy,
    Key? key,
  }) : super(key: key);

  final Widget Function(BuildContext context, T model, Widget? child) builder;
  final Function(T)? onModelReady;
  final Future<bool> Function(T)? onModelReadyAsync;
  final Function(T)? onModelRefresh;
  final Function(T)? onModelDestroy;

  @override
  State<BaseView<T>> createState() => _BaseViewState<T>();
}

class _BaseViewState<T extends BaseViewModel> extends State<BaseView<T>> {
  T model = locator<T>();

  Future<bool>? future;

  @override
  void initState() {
    widget.onModelReady?.call(model);
    if (widget.onModelReadyAsync != null) {
      future = widget.onModelReadyAsync!(model);
    }
    super.initState();
  }

  @override
  void didUpdateWidget(BaseView<T> oldWidget) {
    widget.onModelRefresh?.call(model);
    super.didUpdateWidget(oldWidget);
  }

  @override
  void dispose() {
    widget.onModelDestroy?.call(model);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final connectionStatus = Provider.of<ConnectivityStatus>(context);
    if (connectionStatus == ConnectivityStatus.online) {
      if (widget.onModelReadyAsync != null) {
        return ChangeNotifierProvider<T>.value(
          value: model,
          child: FutureBuilder<bool>(
            future: future,
            builder: (BuildContext context, AsyncSnapshot<bool> result) {
              if (!result.hasData || model.state == ViewState.busy) {
                return const Scaffold(
                  backgroundColor: AppTheme.white,
                  body: Center(
                    child: CircularProgressIndicator(color: AppTheme.primary),
                  ),
                );
              }
              if (!result.data! || model.state == ViewState.error) {
                return const Scaffold(
                  backgroundColor: AppTheme.white,
                  body: Center(
                    child: Icon(
                      Icons.error,
                      color: AppTheme.errorColor,
                      size: 200,
                    ),
                  ),
                );
              }
              //ELSE
              return Consumer<T>(
                builder: widget.builder,
              );
            },
          ),
        );
      } else {
        return ChangeNotifierProvider<T>.value(
          value: model,
          child: Consumer<T>(
            builder: widget.builder,
          ),
        );
      }
    } else {
      return const NoInternetView();
    }
  }
}
