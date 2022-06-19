/// Simple helper class that allows you to know when it was cancelled.
class Cancellable<T> {
  bool _isCancelled = false;
  bool _isCompleted = false;

  bool get isCancelled => _isCancelled;
  bool get isCompleted => _isCompleted;

  void cancel() {
    _isCancelled = true;
  }

  Future<T> run(Future<T> Function(Cancellable<T> cancellable) func) {
    return func(this).whenComplete(() => _isCompleted = true);
  }
}
