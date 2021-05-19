class ErrException implements Exception {
  final String msg;

  const ErrException(this.msg);

  @override
  String toString() {
    return msg;
  }
}
