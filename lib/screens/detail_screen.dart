import 'package:flutter/material.dart';

import '../models/country.dart';
import '../services/country_api_service.dart';

class DetailScreen extends StatefulWidget {
  final String countryCode;

  const DetailScreen({
    super.key,
    required this.countryCode,
  });

  @override
  State<DetailScreen> createState() => _DetailScreenState();
}

class _DetailScreenState extends State<DetailScreen> {
  final CountryApiService _apiService = CountryApiService();

  late Future<Country> _countryFuture;

  @override
  void initState() {
    super.initState();

    _countryFuture = _apiService.fetchCountryByCode(
      widget.countryCode,
    );
  }

  Widget buildInfoTile(
    String title,
    String value,
  ) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        vertical: 8,
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '$title: ',
            style: const TextStyle(
              fontWeight: FontWeight.bold,
            ),
          ),
          Expanded(
            child: Text(value),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Country Details'),
      ),
      body: FutureBuilder<Country>(
        future: _countryFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          if (snapshot.hasError) {
            return Center(
              child: Text(
                snapshot.error.toString(),
              ),
            );
          }

          if (!snapshot.hasData) {
            return const Center(
              child: Text('No country data'),
            );
          }

          final country = snapshot.data!;

          return SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: Text(
                    country.flag,
                    style: const TextStyle(
                      fontSize: 80,
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                Center(
                  child: Text(
                    country.name,
                    style: const TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                const SizedBox(height: 24),
                buildInfoTile(
                  'Region',
                  country.region,
                ),
                buildInfoTile(
                  'Capital',
                  country.capital,
                ),
                buildInfoTile(
                  'Population',
                  country.population.toString(),
                ),
                buildInfoTile(
                  'Area',
                  '${country.area} km²',
                ),
                buildInfoTile(
                  'Timezones',
                  country.timezones.join(', '),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
