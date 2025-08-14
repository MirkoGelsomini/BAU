class ServerConfig {
  static const String ip = '192.168.1.134';
  static const int port = 3000;

  static String get baseUrl => 'http://$ip:$port';

  static String get auth => '$baseUrl/auth';
  static String get audio => '$baseUrl/audio';
  static String get dogs => '$baseUrl/dogs';
  static String get info => '$baseUrl/info';
  static String get feedback => '$baseUrl/feedback';
}
