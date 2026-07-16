abstract class Links {
  /// TODO(backend): mindly has no backend yet — set the real base URL when
  /// the API exists. The quiz module currently reads local mock JSON.
  static const String baseUrl = 'https://api.mindly.app/';
}

/// Endpoint paths used by datasources. Centralised so a backend rename only
/// touches one file (same convention as the scooter apps).
abstract class Endpoints {
  /// Used by the refresh interceptor — must stay in [noAuthPaths].
  /// TODO(backend): placeholder until a real auth service exists.
  static const refreshToken = 'v1/auth/refresh';

  /// Paths the [HeaderInterceptor] must NOT attach an access token to.
  static const Set<String> noAuthPaths = {refreshToken};
}
