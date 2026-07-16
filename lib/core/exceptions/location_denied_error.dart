class LocationDeniedError extends Error {
  final String message;

  LocationDeniedError(this.message);
}
