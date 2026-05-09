import 'package:flutter/material.dart';

import 'models/country.dart';
import 'services/country_api_service.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: TestScreen(),
    );
  }
}

class TestScreen extends StatefulWidget {
  const TestScreen({super.key});

  @override
  State<TestScreen> createState() => _TestScreenState();
}

class _TestScreenState extends State<TestScreen> {
  final CountryApiService _apiService = CountryApiService();

  late Future<List<Country>> _countriesFuture;

  @override
  void initState() {
    super.initState();
    _countriesFuture = _apiService.fetchAllCountries();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Country Explorer'),
      ),
      body: FutureBuilder<List<Country>>(
        future: _countriesFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          if (snapshot.hasError) {
            return Center(
              child: Text(snapshot.error.toString()),
            );
          }

          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(
              child: Text('No countries found'),
            );
          }

          final countries = snapshot.data!;

          return ListView.builder(
            itemCount: countries.length,
            itemBuilder: (context, index) {
              final country = countries[index];

              return ListTile(
                leading: Text(
                  country.flag,
                  style: const TextStyle(fontSize: 28),
                ),
                title: Text(country.name),
                subtitle: Text(country.region),
              );
            },
          );
        },
      ),
    );
  }
}
