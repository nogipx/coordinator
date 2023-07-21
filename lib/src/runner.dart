import '_index.dart';

abstract class AppFlowInput<Shared extends AppFlowShared> {
  Shared get shared;
}

class AppFlowRunner<T extends AppFlowInput> {
  final FutureOr<AppFlow> Function(T input) _flowCreator;

  const AppFlowRunner(this._flowCreator);

  Future<void> run(T input) async {
    final flow = await _flowCreator(input);
    await flow.run();
    await flow.dispose();
  }
}
