abstract class Failure {
  final String message;
  const Failure(this.message);
}

class ServerFailure extends Failure {
  const ServerFailure(super.message);
}

class CacheFailure extends Failure {
  const CacheFailure(super.message);
}

class NetworkFailure extends Failure {
  const NetworkFailure(super.message);
}

class UnknownFailure extends Failure {
  const UnknownFailure(super.message);
}

class FileFailure extends Failure {
  const FileFailure(super.message);
}

class UploadFailure extends Failure {
  const UploadFailure(super.message);
}

class InvalidPasswordFailure extends Failure {
  const InvalidPasswordFailure() : super("Contraseña actual incorrecta");
}

class WeakPasswordFailure extends Failure {
  const WeakPasswordFailure(String message) : super(message);
}

class SessionExpiredFailure extends Failure {
  const SessionExpiredFailure()
    : super("Sesión expirada, inicia sesión nuevamente");
}

class UnauthorizedFailure extends Failure {
  const UnauthorizedFailure() : super("No autorizado");
}

class BadRequestFailure extends Failure {
  const BadRequestFailure(String message) : super(message);
}
