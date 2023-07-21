import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';

typedef AppFlowRouteBuilder = Route<Object> Function(
    WidgetBuilder widgetBuilder);

enum AppFlowNavigatorType {
  material,
  cupertino,
}

abstract class AppFlowNavigator {
  factory AppFlowNavigator({
    required AppFlowRouteBuilder routeBuilder,
    required GlobalKey<NavigatorState> navigatorKey,
  }) =>
      _NavigatorImpl(routeBuilder, navigatorKey);

  factory AppFlowNavigator.material({
    required GlobalKey<NavigatorState> navigatorKey,
  }) =>
      _NavigatorImpl(
        (builder) => MaterialPageRoute(builder: builder),
        navigatorKey,
      );

  factory AppFlowNavigator.cupertino({
    required GlobalKey<NavigatorState> navigatorKey,
  }) =>
      _NavigatorImpl(
        (builder) => CupertinoPageRoute(builder: builder),
        navigatorKey,
      );

  GlobalKey<NavigatorState> get navigatorKey;

  Future<Object?>? next(WidgetBuilder widgetBuilder);
  Future<Object?>? nextReplaceLast(WidgetBuilder widgetBuilder);
  void first(WidgetBuilder widgetBuilder);
  void second(WidgetBuilder widgetBuilder);
  void pop({bool toFirst = false});
}

class _NavigatorImpl implements AppFlowNavigator {
  const _NavigatorImpl(
    this._routeBuilder,
    this.navigatorKey,
  );

  @override
  final GlobalKey<NavigatorState> navigatorKey;
  final AppFlowRouteBuilder _routeBuilder;

  NavigatorState? get _navigator => Navigator.maybeOf(
        navigatorKey.currentContext!,
      );

  @override
  Future<Object?> next(
    WidgetBuilder widgetBuilder, {
    AppFlowRouteBuilder? routeBuilder,
  }) async {
    return _navigator?.push(
      _routeBuilder(widgetBuilder),
    );
  }

  @override
  Future<Object?>? nextReplaceLast(
    WidgetBuilder widgetBuilder, {
    AppFlowRouteBuilder? routeBuilder,
  }) {
    return _navigator?.pushReplacement(
      _routeBuilder(widgetBuilder),
    );
  }

  @override
  Future<void> first(
    WidgetBuilder widgetBuilder, {
    AppFlowRouteBuilder? routeBuilder,
  }) async =>
      await _navigator?.pushAndRemoveUntil(
        _routeBuilder(widgetBuilder),
        (_) => false,
      );

  @override
  Future<void> second(
    WidgetBuilder widgetBuilder, {
    AppFlowRouteBuilder? routeBuilder,
  }) async =>
      await _navigator?.pushAndRemoveUntil(
        _routeBuilder(widgetBuilder),
        (_) => _.isFirst,
      );

  @override
  void pop({bool toFirst = false}) => toFirst
      ? navigatorKey.currentState?.popUntil((route) => route.isFirst)
      : navigatorKey.currentState?.pop();
}
