abstract class WebClient {

  Future<T> read<T>(
      final String url,
      final String method,
      final T Function(dynamic) fromJson,
      {
        final Map<String, String> headers = const {},
        final String body
      }
  );

  Iterable<Future<T>> readMany<T>(
      final List<String> urls,
      final String method,
      final T Function(dynamic) fromJson,
      {
        final Map<String, String> headers = const {},
        final String body
      }
  );

}