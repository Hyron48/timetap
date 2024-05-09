class CustomException implements Exception {
  int statusCode;
  String message;

  CustomException({
    required this.statusCode,
    required this.message
  });

  static final empty = CustomException(
      statusCode: 0,
      message: ''
  );
}