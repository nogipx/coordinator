export 'dart:async';
import 'package:logging/logging.dart';
import 'package:meta/meta.dart';

import '_index.dart';

abstract class AppFlow<Shared extends AppFlowShared> {
  AppFlow({
    required this.shared,
    AppFlowNavigator? navigator,
  }) : _navigator = navigator {
    try {
      onCreate();
    } catch (error, trace) {
      Logger.root.shout('Error while creating $runtimeType', error, trace);
    }
  }

  @protected
  final Shared shared;
  final AppFlowNavigator? _navigator;

  @protected
  AppFlowNavigator get navigator => _navigator ?? shared.navigator;

  void onCreate() {}

  FutureOr<void> run() async {}

  @mustCallSuper
  FutureOr<void> dispose() async {}
}
