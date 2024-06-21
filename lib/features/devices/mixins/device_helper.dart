mixin DeviceHelper {
  T? firstWhere<T>(Set<T> set, bool Function(T) test) {
    try {
      return set.firstWhere(test);
    } catch (_) {
      return null;
    }
  }
}
