import 'dart:convert';

import 'package:http/http.dart' as http;

class HttpService {
  static Future<JsonObject> post({
    required String endpoint,
    required Map<String, dynamic> body,
    Map<String, dynamic>? parameters,
  }) async {
    final fullUrl = Uri.http("", endpoint, parameters);

    http.Response res = await http.post(fullUrl, body: body);
    if (res.statusCode < 200 || res.statusCode > 299) {
      throw "${res.statusCode} : ${res.body}";
    }

    return JsonObject.fromResponse(res);
  }

  static Future<JsonObject> get({
    required String endpoint,
    Map<String, dynamic>? parameters,
  }) async {
    final fullUrl = Uri.http("", endpoint, parameters);

    http.Response res = await http.get(fullUrl);
    if (res.statusCode < 200 || res.statusCode > 299) {
      throw "${res.statusCode} : ${res.body}";
    }

    return JsonObject.fromResponse(res);
  }
}

class JsonObject {
  static const Converter<List<int>, String> _decoder = Utf8Decoder();

  final String jsonString;

  JsonObject._(this.jsonString) {
    // If this gets constructed with an invalid json, throw an exception sooner
    // rather than later.
    if (!_validateJson()) {
      throw "InvalidJsonError";
    }
  }

  factory JsonObject.fromResponse(http.Response response) {
    final jsonString = _decoder.convert(response.bodyBytes);
    return JsonObject._(jsonString);
  }

  // Converting back to more useful formats.

  List<T> toList<T>({required T Function(Map<String, dynamic>) converter}) {
    final decodedJson = jsonDecode(jsonString) as List<dynamic>;
    return decodedJson.cast<Map<String, dynamic>>().map(converter).toList();
  }

  Map<String, dynamic> toMap() =>
      jsonDecode(jsonString) as Map<String, dynamic>;

  @override
  String toString() => jsonString;

  /// Check our [jsonString] is valid.
  bool _validateJson() {
    try {
      dynamic decoded = jsonString;
      if (jsonString.isNotEmpty) {
        // jsonDecode requires the input string to be non-null at a minimum,
        // otherwise a NoSuchMethodError (aka a null exception) occurs. Empty
        // strings, whilst valid will throw a FormatException.
        decoded = jsonDecode(jsonString);
      }
      return decoded != null;
    } on FormatException catch (_) {
      return false;
    }
  }
}
