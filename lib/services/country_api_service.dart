import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;

import '../models/country.dart';
import 'api_exception.dart';

class CountryApiService {
  final String _baseUrl = 'restcountries.com';

  final Duration _timeout = const Duration(seconds: 10);

  final Map<String, String> _headers = {
    'Content-Type': 'application/json',
    'Accept': 'application/json',
  };

  void _checkResponse(http.Response response) {
    if (response.statusCode != 200) {
      throw ApiException(
        'Request failed',
        response.statusCode,
      );
    }
  }

  Future<List<Country>> fetchAllCountries() async {
    try {
      final uri = Uri.https(
        _baseUrl,
        '/v3.1/all',
        {
          'fields': 'name,flag,region,population,capital,area,timezones,cca3',
        },
      );

      final response = await http
          .get(
            uri,
            headers: _headers,
          )
          .timeout(_timeout);

      _checkResponse(response);

      final List<dynamic> jsonData = jsonDecode(response.body) as List<dynamic>;

      return jsonData
          .map(
            (countryJson) => Country.fromJson(
              countryJson as Map<String, dynamic>,
            ),
          )
          .toList();
    } on SocketException {
      throw Exception('No internet connection.');
    } on TimeoutException {
      throw Exception('Request timed out. Please try again.');
    } on FormatException {
      throw Exception('Unexpected data format received.');
    } on ApiException {
      rethrow;
    } catch (e) {
      throw Exception('An unexpected error occurred: $e');
    }
  }

  Future<List<Country>> searchCountries(String name) async {
    try {
      final uri = Uri.https(
        _baseUrl,
        '/v3.1/name/$name',
      );

      final response = await http
          .get(
            uri,
            headers: _headers,
          )
          .timeout(_timeout);

      _checkResponse(response);

      final List<dynamic> jsonData = jsonDecode(response.body) as List<dynamic>;

      return jsonData
          .map(
            (countryJson) => Country.fromJson(
              countryJson as Map<String, dynamic>,
            ),
          )
          .toList();
    } on SocketException {
      throw Exception('No internet connection.');
    } on TimeoutException {
      throw Exception('Request timed out. Please try again.');
    } on FormatException {
      throw Exception('Unexpected data format received.');
    } on ApiException {
      rethrow;
    } catch (e) {
      throw Exception('An unexpected error occurred: $e');
    }
  }

  Future<Country> fetchCountryByCode(String code) async {
    try {
      final uri = Uri.https(
        _baseUrl,
        '/v3.1/alpha/$code',
      );

      final response = await http
          .get(
            uri,
            headers: _headers,
          )
          .timeout(_timeout);

      _checkResponse(response);

      final List<dynamic> jsonData = jsonDecode(response.body) as List<dynamic>;

      return Country.fromJson(
        jsonData.first as Map<String, dynamic>,
      );
    } on SocketException {
      throw Exception('No internet connection.');
    } on TimeoutException {
      throw Exception('Request timed out. Please try again.');
    } on FormatException {
      throw Exception('Unexpected data format received.');
    } on ApiException {
      rethrow;
    } catch (e) {
      throw Exception('An unexpected error occurred: $e');
    }
  }
}
