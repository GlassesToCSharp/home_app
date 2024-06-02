import 'dart:math';

mixin MockRepository {
  static const Duration mockDelay = Duration(milliseconds: 500);

  Future<List<T>> generateData<T>(
      int numberOfData, T Function(int count, Random generator) instancing) {
    final data = <T>[];
    final gen = Random();

    // Get 1000 lots of data over.
    for (int i = 0; i < numberOfData; i++) {
      data.add(instancing(i, gen));
    }

    return Future.delayed(mockDelay, () => Future.value(data));
  }

  Future<T> returnDelayed<T>(T result) {
    return Future.delayed(mockDelay, () => result);
  }
}
