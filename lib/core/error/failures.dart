import 'package:equatable/equatable.dart';

abstract class Failure extends Equatable {
  final String message;

  const Failure(this.message);

  @override
  List<Object?> get props => [message];
}

class ServerFailure extends Failure {
  const ServerFailure(String message) : super(message);
}

class NetworkFailure extends Failure {
  const NetworkFailure() : super('لا يوجد اتصال بالإنترنت');
}

class CacheFailure extends Failure {
  const CacheFailure() : super('خطأ في التخزين المؤقت');
}

class AuthFailure extends Failure {
  const AuthFailure(String message) : super(message);
}