class ENV {
  //Default values are for debug.
  //Will need to use `--dart-define` when building for release.
  static const String BASE_URL = String.fromEnvironment(
        'BASE_URL',
        // defaultValue: 'http://10.0.2.2:1337',
        // defaultValue: 'http://farmicon.tunnel.mdgspace.org',
        defaultValue: 'http://ec2-54-242-195-133.compute-1.amazonaws.com',
      ),
      OPEN_WEATHER_API_KEY = String.fromEnvironment(
        'OPEN_WEATHER_API_KEY',
        defaultValue: 'f778047606dfd1ce2e08bf9e69dd291f',
      ),
      STRAPI_TOKEN = String.fromEnvironment(
        'STRAPI_TOKEN',
        defaultValue: '8be9891d95e615c1cb13acbf9221f74ec02ddfd6b422f42bf944f6c4'
            'c8848b8433e55b0b83d4a34a65530769521f0161b129c26eae84'
            '8a7cfa27211d68162c9caffa26f057b15136ef0abcc16231b727'
            'cb4195a364b9d9626a8c9849be614483f6a17998e33c548e7dcd'
            'ebfe4c59543dbbba5875947a2bb3d3caa87ba85b5c95',
      ),
      SENTRY_DSN = String.fromEnvironment(
        'SENTRY_DSN',
        defaultValue: 'https://56284610378341888399afb86f61777f'
            '@o4504412533227520'
            '.ingest.sentry.io/4504412535455744',
      );
}
