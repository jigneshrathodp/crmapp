import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../utils/api_logger.dart';

class BaseApi {
  final String baseUrl;

  BaseApi(this.baseUrl);
  Future<String?> _getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('token');
  }

  Future<Map<String, String>> _getAuthHeaders() async {
    final token = await _getToken();
    final headers = <String, String>{
      'Content-Type': 'application/json',
      'Accept': 'application/json',
    };
    if (token != null && token.isNotEmpty) {
      headers['Authorization'] = 'Bearer $token';
    }
    return headers;
  }

  // GET request
  Future<http.Response> get(
    String endpoint, {
    Map<String, String>? headers,
  }) async {
    final url = Uri.parse('$baseUrl$endpoint');
    final defaultHeaders = await _getAuthHeaders();
    final finalHeaders = headers ?? defaultHeaders;

    ApiLogger.logRequest('GET', url, headers: finalHeaders);

    final response = await http.get(url, headers: finalHeaders);

    ApiLogger.logResponse(response);
    return response;
  }

  // POST request (JSON body)
  Future<http.Response> post(
    String endpoint, {
    Map<String, String>? headers,
    Object? body,
  }) async {
    final url = Uri.parse('$baseUrl$endpoint');
    final defaultHeaders = await _getAuthHeaders();
    final finalHeaders = headers ?? defaultHeaders;
    String? encodedBody;
    if (body is Map<String, dynamic>) {
      encodedBody = jsonEncode(body);
    } else if (body is String) {
      encodedBody = body;
    }

    ApiLogger.logRequest('POST', url, headers: finalHeaders, body: encodedBody);

    final response = await http.post(
      url,
      headers: finalHeaders,
      body: encodedBody,
    );

    ApiLogger.logResponse(response);
    return response;
  }

  // POST multipart/form-data request (for file uploads)
  Future<http.Response> postMultipart(
    String endpoint, {
    Map<String, String>? fields,
    List<http.MultipartFile>? files,
  }) async {
    final token = await _getToken();
    final uri = Uri.parse('$baseUrl$endpoint');
    final request = http.MultipartRequest('POST', uri);
    request.headers['Accept'] = 'application/json';
    if (token != null && token.isNotEmpty) {
      request.headers['Authorization'] = 'Bearer $token';
    }
    if (fields != null) request.fields.addAll(fields);
    if (files != null) request.files.addAll(files);

    ApiLogger.logMultipartRequest('POST', uri, fields: fields, files: files);

    final streamedResponse = await request.send();
    final response = await http.Response.fromStream(streamedResponse);

    ApiLogger.logResponse(response);
    return response;
  }

  // PUT request (JSON body)
  Future<http.Response> put(
    String endpoint, {
    Map<String, String>? headers,
    Object? body,
  }) async {
    final url = Uri.parse('$baseUrl$endpoint');
    final defaultHeaders = await _getAuthHeaders();
    final finalHeaders = headers ?? defaultHeaders;
    String? encodedBody;
    if (body is Map<String, dynamic>) {
      encodedBody = jsonEncode(body);
    } else if (body is String) {
      encodedBody = body;
    }

    ApiLogger.logRequest('PUT', url, headers: finalHeaders, body: encodedBody);

    final response = await http.put(
      url,
      headers: finalHeaders,
      body: encodedBody,
    );

    ApiLogger.logResponse(response);
    return response;
  }

  // DELETE request
  Future<http.Response> delete(
    String endpoint, {
    Map<String, String>? headers,
  }) async {
    final url = Uri.parse('$baseUrl$endpoint');
    final defaultHeaders = await _getAuthHeaders();
    final finalHeaders = headers ?? defaultHeaders;

    ApiLogger.logRequest('DELETE', url, headers: finalHeaders);

    final response = await http.delete(url, headers: finalHeaders);

    ApiLogger.logResponse(response);
    return response;
  }
}
