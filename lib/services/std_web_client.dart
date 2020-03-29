import 'package:http/http.dart';
import 'package:thesaurus_omicron/services/web_client.dart';

class StdWebClient implements WebClient {

  @override
  Future<T> read<T>(
      final String url,
      final String method,
      final T Function(dynamic) fromJson,
      {
        final Map<String, String> headers = const {},
        final String body
      }
  ) {
    final Request request = _prepareRequest(method, url, headers, body);
    return _useWebClient((client) async {
      final response = await client.send(request);
      final responseJson = await _parseResponse(response);
      return fromJson(responseJson);
    });
  }

  @override
  Future<List<T>> readMany<T>(
      final List<String> urls,
      final String method,
      final T Function(dynamic) fromJson,
      {
        final Map<String, String> headers = const {},
        final String body
      }
  ) {
    return Future.wait(urls.map((url) => read(url, method, fromJson, headers: headers, body: body)).toList());
  }

  Future<String> _parseResponse(final StreamedResponse streamedResponse) {
    if (streamedResponse.statusCode != 200) {
      throw "Unexpected status code in reponse from server: ${streamedResponse.statusCode}";
    }
    return streamedResponse.stream.bytesToString();
  }

  Request _prepareRequest(final String mthd, final String url, final Map<String, String> headers, final String body) {
    final Request request = Request(mthd, Uri.parse(url));

    if (body != null) {
      request.body = body;
    }

    request.headers.addAll(headers);

    return request;
  }

  Future<T> _useWebClient<T>(Future<T> fn(Client client)) async {
    var client = new Client();
    try {
      return await fn(client);
    } finally {
      client.close();
    }
  }

}