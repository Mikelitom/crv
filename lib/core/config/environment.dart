enum Environment { dev, prod }

class EnvironmentConfig {
  final String baseUrl;

  EnvironmentConfig._(this.baseUrl);

  static EnvironmentConfig get current {
    const env = String.fromEnvironment('ENV', defaultValue: 'dev');

    switch (env) {
      case 'prod':
        return EnvironmentConfig._(
          'https://crv-3bmn.onrender.com/api/v1',
        );
      default:
        return EnvironmentConfig._('http://127.0.0.1:8000/api/v1');
    }
  }
}
