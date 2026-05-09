import 'package:flutter/material.dart';

import '../models/country.dart';
import '../services/country_api_service.dart';
import '../widgets/country_card.dart';
import 'detail_screen.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() =>
      _SearchScreenState();
}

class _SearchScreenState
    extends State<SearchScreen> {
  final CountryApiService _apiService =
      CountryApiService();

  final TextEditingController _controller =
      TextEditingController();

  List<Country> _countries = [];

  bool _isLoading = false;

  String? _errorMessage;

  Future<void> _searchCountries() async {
    final query = _controller.text.trim();

    if (query.isEmpty) {
      return;
    }

    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      final results =
          await _apiService.searchCountries(query);

      if (mounted) {
        setState(() {
          _countries = results;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _errorMessage = e.toString();
        });
      }
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Search Countries'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          children: [
            TextField(
              controller: _controller,
              decoration: InputDecoration(
                hintText:
                    'Enter country name...',
                border:
                    const OutlineInputBorder(),
                suffixIcon: IconButton(
                  onPressed: _searchCountries,
                  icon: const Icon(Icons.search),
                ),
              ),
              onSubmitted: (_) =>
                  _searchCountries(),
            ),

            const SizedBox(height: 16),

            if (_isLoading)
              const CircularProgressIndicator(),

            if (_errorMessage != null)
              Padding(
                padding:
                    const EdgeInsets.only(top: 12),
                child: Text(
                  _errorMessage!,
                  textAlign: TextAlign.center,
                ),
              ),

            if (!_isLoading)
              Expanded(
                child: ListView.builder(
                  itemCount: _countries.length,
                  itemBuilder: (context, index) {
                    final country =
                        _countries[index];

                    return CountryCard(
                      country: country,
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) =>
                                DetailScreen(
                              countryCode:
                                  country
                                      .alpha3Code,
                            ),
                          ),
                        );
                      },
                    );
                  },
                ),
              ),
          ],
        ),
      ),
    );
  }
}