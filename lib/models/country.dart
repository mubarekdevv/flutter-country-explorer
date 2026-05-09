class Country {
  final String name;
  final String flag;
  final String region;
  final String capital;
  final int population;
  final double area;
  final List<String> timezones;
  final String alpha3Code;

  const Country({
    required this.name,
    required this.flag,
    required this.region,
    required this.capital,
    required this.population,
    required this.area,
    required this.timezones,
    required this.alpha3Code,
  });

  factory Country.fromJson(Map<String, dynamic> json) {
    return Country(
      name: json['name']['common'] as String? ?? 'Unknown',
      flag: json['flag'] as String? ?? '',
      region: json['region'] as String? ?? 'Unknown',
      capital: (json['capital'] != null && (json['capital'] as List).isNotEmpty)
          ? json['capital'][0] as String
          : 'No Capital',
      population: json['population'] as int? ?? 0,
      area: (json['area'] as num?)?.toDouble() ?? 0.0,
      timezones:
          json['timezones'] != null ? List<String>.from(json['timezones']) : [],
      alpha3Code: json['cca3'] as String? ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'flag': flag,
      'region': region,
      'capital': capital,
      'population': population,
      'area': area,
      'timezones': timezones,
      'alpha3Code': alpha3Code,
    };
  }

  Country copyWith({
    String? name,
    String? flag,
    String? region,
    String? capital,
    int? population,
    double? area,
    List<String>? timezones,
    String? alpha3Code,
  }) {
    return Country(
      name: name ?? this.name,
      flag: flag ?? this.flag,
      region: region ?? this.region,
      capital: capital ?? this.capital,
      population: population ?? this.population,
      area: area ?? this.area,
      timezones: timezones ?? this.timezones,
      alpha3Code: alpha3Code ?? this.alpha3Code,
    );
  }
}
