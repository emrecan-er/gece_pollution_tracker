class AirQualityData {
  final String dateTime;
  final String regionCode;
  final List<AirQualityIndex> indexes;
  final List<Pollutant> pollutants;
  final HealthRecommendations healthRecommendations;

  AirQualityData({
    required this.dateTime,
    required this.regionCode,
    required this.indexes,
    required this.pollutants,
    required this.healthRecommendations,
  });

  factory AirQualityData.fromJson(Map<String, dynamic> json) {
    var indexesList = json['indexes'] as List;
    List<AirQualityIndex> indexes =
        indexesList.map((i) => AirQualityIndex.fromJson(i)).toList();

    var pollutantsList = json['pollutants'] as List;
    List<Pollutant> pollutants =
        pollutantsList.map((i) => Pollutant.fromJson(i)).toList();

    return AirQualityData(
      dateTime: json['dateTime'],
      regionCode: json['regionCode'],
      indexes: indexes,
      pollutants: pollutants,
      healthRecommendations:
          HealthRecommendations.fromJson(json['healthRecommendations']),
    );
  }
}

class AirQualityIndex {
  final String code;
  final String displayName;
  final aqi;
  final String aqiDisplay;
  final Map<String, dynamic>? color;
  final String category;
  final String dominantPollutant;

  AirQualityIndex({
    required this.code,
    required this.displayName,
    required this.aqi,
    required this.aqiDisplay,
    this.color,
    required this.category,
    required this.dominantPollutant,
  });

  factory AirQualityIndex.fromJson(Map<String, dynamic> json) {
    return AirQualityIndex(
      code: json['code'],
      displayName: json['displayName'],
      aqi: json['aqi'],
      aqiDisplay: json['aqiDisplay'],
      color: json['color'] != null
          ? Map<String, dynamic>.from(json['color'])
          : null,
      category: json['category'],
      dominantPollutant: json['dominantPollutant'],
    );
  }
}

class Pollutant {
  final String code;
  final String displayName;
  final String fullName;
  final Concentration concentration;
  final AdditionalInfo additionalInfo;

  Pollutant({
    required this.code,
    required this.displayName,
    required this.fullName,
    required this.concentration,
    required this.additionalInfo,
  });

  factory Pollutant.fromJson(Map<String, dynamic> json) {
    return Pollutant(
      code: json['code'],
      displayName: json['displayName'],
      fullName: json['fullName'],
      concentration: Concentration.fromJson(json['concentration']),
      additionalInfo: AdditionalInfo.fromJson(json['additionalInfo']),
    );
  }
}

class Concentration {
  final value;
  final String units;

  Concentration({
    required this.value,
    required this.units,
  });

  factory Concentration.fromJson(Map<String, dynamic> json) {
    return Concentration(
      value: json['value'],
      units: json['units'],
    );
  }
}

class AdditionalInfo {
  final String sources;
  final String effects;

  AdditionalInfo({
    required this.sources,
    required this.effects,
  });

  factory AdditionalInfo.fromJson(Map<String, dynamic> json) {
    return AdditionalInfo(
      sources: json['sources'],
      effects: json['effects'],
    );
  }
}

class HealthRecommendations {
  final String generalPopulation;
  final String elderly;
  final String lungDiseasePopulation;
  final String heartDiseasePopulation;
  final String athletes;
  final String pregnantWomen;
  final String children;

  HealthRecommendations({
    required this.generalPopulation,
    required this.elderly,
    required this.lungDiseasePopulation,
    required this.heartDiseasePopulation,
    required this.athletes,
    required this.pregnantWomen,
    required this.children,
  });

  factory HealthRecommendations.fromJson(Map<String, dynamic> json) {
    return HealthRecommendations(
      generalPopulation: json['generalPopulation'],
      elderly: json['elderly'],
      lungDiseasePopulation: json['lungDiseasePopulation'],
      heartDiseasePopulation: json['heartDiseasePopulation'],
      athletes: json['athletes'],
      pregnantWomen: json['pregnantWomen'],
      children: json['children'],
    );
  }
}
