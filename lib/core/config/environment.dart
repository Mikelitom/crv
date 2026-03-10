enum Environment { dev, prod }

class EnvironmentConfig {
  final String baseUrl;

  EnvironmentConfig._(this.baseUrl);

  static EnvironmentConfig get current {
    const env = String.fromEnvironment('ENV', defaultValue: 'dev');

    switch (env) {
      case 'prod':
        return EnvironmentConfig._(
          'https://backend-crv-refactor.onrender.com/api/v1',
        );
      default:
        return EnvironmentConfig._('https://backend-crv-refactor.onrender.com/api/v1');
    }
  }
}