class AccessDeniedException implements Exception {
  const AccessDeniedException([this.message = 'Access denied']);

  final String message;

  @override
  String toString() => 'AccessDeniedException: $message';
}
