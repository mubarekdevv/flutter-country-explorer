import 'package:flutter/material.dart';

import '../models/country.dart';

class CountryCard extends StatelessWidget {
  final Country country;
  final VoidCallback onTap;

  const CountryCard({
    super.key,
    required this.country,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(
        horizontal: 12,
        vertical: 6,
      ),
      child: ListTile(
        onTap: onTap,
        leading: Text(
          country.flag,
          style: const TextStyle(fontSize: 32),
        ),
        title: Text(
          country.name,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
        subtitle: Text(country.region),
        trailing: const Icon(Icons.arrow_forward_ios),
      ),
    );
  }
}
