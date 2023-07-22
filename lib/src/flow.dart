export 'dart:async';
import 'package:logging/logging.dart';
import 'package:meta/meta.dart';

import '_index.dart';

abstract class Coordinator<Shared extends CoordinatorShared> {
  Coordinator({
    required this.shared,
    CoordinatorNavigator? navigator,
  }) : _navigator = navigator {
    try {
      onCreate();
    } catch (error, trace) {
      Logger.root.shout('Error while creating $runtimeType', error, trace);
    }
  }

  @protected
  final Shared shared;
  final CoordinatorNavigator? _navigator;

  @protected
  CoordinatorNavigator get navigator => _navigator ?? shared.navigator;

  void onCreate() {}

  FutureOr<void> run() async {}

  @mustCallSuper
  FutureOr<void> dispose() async {}
}
