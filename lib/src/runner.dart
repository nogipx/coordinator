import '_index.dart';

abstract class CoordinatorInput<Shared extends CoordinatorShared> {
  Shared get shared;
}

class CoordinatorRunner<T extends CoordinatorInput> {
  final FutureOr<Coordinator> Function(T input) _flowCreator;

  const CoordinatorRunner(this._flowCreator);

  Future<void> run(T input) async {
    final flow = await _flowCreator(input);
    await flow.run();
    await flow.dispose();
  }
}
