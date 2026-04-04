class ServerException implements Exception {
  final String message;

  ServerException(this.message);

  @override
  String toString() => message;
}

class NetworkException implements Exception {
  final String message;

  NetworkException([this.message = 'Network error occurred']);

  @override
  String toString() => message;
}

class CacheException implements Exception {
  final String message;

  CacheException([this.message = 'Cache error occurred']);

  @override
  String toString() => message;
}