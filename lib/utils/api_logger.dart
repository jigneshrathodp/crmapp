import 'dart:convert';
import 'dart:developer' as developer;
import 'package:http/http.dart' as http;

class ApiLogger {
  static void logRequest(String method, Uri url, {Map<String, String>? headers, Object? body}) {
    developer.log('➡️ === API REQUEST ===', name: 'API');
    developer.log('Method: $method', name: 'API');
    developer.log('URL: $url', name: 'API');
    if (headers != null && headers.isNotEmpty) {
      developer.log('Headers: $headers', name: 'API');
    }
    if (body != null) {
      developer.log('Body: $body', name: 'API');
    }
    developer.log('=====================', name: 'API');
  }

  static void logMultipartRequest(String method, Uri url, {Map<String, String>? fields, List<http.MultipartFile>? files}) {
    developer.log('➡️ === MULTIPART API REQUEST ===', name: 'API');
    developer.log('Method: $method', name: 'API');
    developer.log('URL: $url', name: 'API');
    if (fields != null && fields.isNotEmpty) {
      developer.log('Fields: $fields', name: 'API');
    }
    if (files != null && files.isNotEmpty) {
      developer.log('Files: ${files.map((f) => '${f.field} -> ${f.filename}').toList()}', name: 'API');
    }
    developer.log('==============================', name: 'API');
  }

  static void logResponse(http.Response response) {
    developer.log('⬅️ === API RESPONSE ===', name: 'API');
    developer.log('URL: ${response.request?.url}', name: 'API');
    developer.log('Status Code: ${response.statusCode}', name: 'API');
    try {
      final jsonResponse = jsonDecode(response.body);
      developer.log('Response Body:\n${const JsonEncoder.withIndent('  ').convert(jsonResponse)}', name: 'API');
    } catch (e) {
      // If it's not JSON, just log the raw body
      developer.log('Response Body: ${response.body}', name: 'API');
    }
    developer.log('======================', name: 'API');
  }
}
