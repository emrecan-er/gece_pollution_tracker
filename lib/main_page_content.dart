import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'package:gece_pollution_tracker/air_quality_prediction.dart';
import 'package:gece_pollution_tracker/models/airquality_model.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:gece_pollution_tracker/constants.dart';
import 'package:gece_pollution_tracker/main_page/main_page.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:lottie/lottie.dart';

class MainPageContent extends StatefulWidget {
  const MainPageContent({super.key});

  @override
  State<MainPageContent> createState() => _MainPageContentState();
}

class _MainPageContentState extends State<MainPageContent> {
  @override
  void initState() {
    super.initState();
    _getCurrentLocation();
  }

  var lat;
  var long;
  bool isDataLoaded = false;
  DateTime dateTime = DateTime.parse("2024-02-20T13:00:00Z");
  DateFormat dateFormat = DateFormat('dd.MM.yyyy HH:mm');
  String formattedDateTime = '';
  AirQualityData airQualityData = AirQualityData(
    dateTime: '',
    regionCode: '',
    indexes: [],
    pollutants: [],
    healthRecommendations: HealthRecommendations(
      generalPopulation: '',
      elderly: '',
      lungDiseasePopulation: '',
      heartDiseasePopulation: '',
      athletes: '',
      pregnantWomen: '',
      children: '',
    ),
  );
  Future<void> fetchAirQualityData(String apiKey) async {
    final url =
        'https://airquality.googleapis.com/v1/currentConditions:lookup?key=$apiKey';

    log(lat.toString() + long.toString());
    final Map<String, dynamic> requestBody = {
      "universalAqi": true,
      "location": {"latitude": lat, "longitude": long},
      "extraComputations": [
        "HEALTH_RECOMMENDATIONS",
        "DOMINANT_POLLUTANT_CONCENTRATION",
        "POLLUTANT_CONCENTRATION",
        "LOCAL_AQI",
        "POLLUTANT_ADDITIONAL_INFO"
      ],
      "languageCode": "en"
    };

    try {
      final response = await http.post(
        Uri.parse(url),
        headers: {
          'Content-Type': 'application/json',
        },
        body: jsonEncode(requestBody),
      );

      if (response.statusCode == 200) {
        final responseData = jsonDecode(response.body);
        setState(() {
          airQualityData = AirQualityData.fromJson(responseData);
          isDataLoaded = true;
          formattedDateTime =
              dateFormat.format(DateTime.parse(airQualityData.dateTime));
        });
        inspect(airQualityData);
      } else {
        print('Failed to fetch air quality data: ${response.statusCode}');
      }
    } catch (e) {
      print('Error fetching air quality data: $e');
    }
  }

  File? imageURI;
  List? result;
  String? path;

  Future getImageFromGallery() async {
    final returnedImage =
        await ImagePicker().pickImage(source: ImageSource.gallery);
    if (returnedImage == null) return;
    setState(() {
      path = returnedImage.path;
    });
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => AirQualityPrediction(
          photoPath: path.toString(),
        ),
      ),
    );
  }

  Future<void> _getCurrentLocation() async {
    Position position = await _determinePosition();
    setState(() {
      lat = position.latitude;
      long = position.longitude;
    });

    List<Placemark> placemarks = await placemarkFromCoordinates(lat, long);
    inspect(placemarks);
    setState(() {
      currentCity = placemarks[0].subAdministrativeArea.toString();
    });
    fetchAirQualityData('AIzaSyAfru0bt0utI6kNTjgz105qvbOScAlXB6g');
  }

  Future<Position> _determinePosition() async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      return Future.error('Location services are disabled.');
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return Future.error('Location permissions are denied');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      return Future.error(
          'Location permissions are permanently denied, we cannot request permissions.');
    }

    return await Geolocator.getCurrentPosition();
  }

  @override
  Widget build(BuildContext context) {
    return isDataLoaded
        ? SingleChildScrollView(
            child: Column(
              children: [
                SizedBox(
                  width: MediaQuery.of(context).size.width,
                  height: 370,
                  child: Stack(
                    children: [
                      Positioned(
                        top: 0,
                        left: 0,
                        right: 0,
                        child: Container(
                          height: 200,
                          decoration: BoxDecoration(
                            color: Color(0xffe6f4ed),
                            image: DecorationImage(
                                image: AssetImage('assets/forest.png'),
                                fit: BoxFit.cover,
                                opacity: 0.3),
                            borderRadius: BorderRadius.only(
                              bottomLeft: Radius.circular(32),
                              bottomRight: Radius.circular(32),
                            ),
                          ),
                          child: SafeArea(
                            child: Column(
                              children: [
                                Padding(
                                  padding: EdgeInsets.all(8.0),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        'Welcome, Emrecan 👋🏻',
                                        style: GoogleFonts.varelaRound(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 18,
                                        ),
                                      ),
                                      CircleAvatar(
                                        backgroundColor: Colors.white,
                                        child: Icon(
                                          Icons.forest,
                                        ),
                                      )
                                    ],
                                  ),
                                )
                              ],
                            ),
                          ),
                        ),
                      ),
                      Positioned.fill(
                        top: 150,
                        child: SingleChildScrollView(
                          physics: NeverScrollableScrollPhysics(),
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Container(
                              height: 200,
                              decoration: BoxDecoration(
                                color: Color(0xff079450),
                                borderRadius: BorderRadius.circular(16),
                              ),
                              child: Column(
                                children: [
                                  Container(
                                    width: MediaQuery.of(context).size.width,
                                    height: 160,
                                    decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.circular(16),
                                    ),
                                    child: Column(
                                      children: [
                                        Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.start,
                                            children: [
                                              Icon(Icons.location_on_outlined),
                                              SizedBox(
                                                width: 5,
                                              ),
                                              Text(
                                                currentCity,
                                                style: GoogleFonts.varelaRound(
                                                    fontWeight: FontWeight.bold,
                                                    fontSize: 17),
                                              ),
                                            ],
                                          ),
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.only(
                                              left: 8, right: 8),
                                          child: Divider(),
                                        ),
                                        Row(
                                          children: [
                                            Padding(
                                              padding:
                                                  const EdgeInsets.all(8.0),
                                              child: Text(
                                                airQualityData
                                                    .indexes[0].category,
                                                style: GoogleFonts.varelaRound(
                                                    fontSize: 20),
                                              ),
                                            ),
                                            Spacer(),
                                            Padding(
                                              padding:
                                                  const EdgeInsets.all(8.0),
                                              child: Container(
                                                width: 70,
                                                height: 70,
                                                decoration: BoxDecoration(
                                                  borderRadius:
                                                      BorderRadius.circular(16),
                                                  color: Color(0xff079450),
                                                  image: DecorationImage(
                                                    image: AssetImage(
                                                        'assets/a.png'),
                                                    fit: BoxFit.cover,
                                                    opacity: 0.1,
                                                  ),
                                                ),
                                                child: Column(
                                                  children: [
                                                    Expanded(
                                                      flex: 1,
                                                      child: Text(
                                                        airQualityData
                                                            .indexes[0].code,
                                                        style: GoogleFonts
                                                            .varelaRound(
                                                                color: Colors
                                                                    .white,
                                                                fontSize: 12),
                                                      ),
                                                    ),
                                                    Expanded(
                                                      flex: 2,
                                                      child: Text(
                                                        airQualityData
                                                            .indexes[0].aqi
                                                            .toString(),
                                                        style: GoogleFonts
                                                            .varelaRound(
                                                          color: Colors.white,
                                                          fontWeight:
                                                              FontWeight.bold,
                                                          fontSize: 25,
                                                        ),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ),
                                            Padding(
                                              padding:
                                                  const EdgeInsets.all(8.0),
                                              child: Container(
                                                width: 70,
                                                height: 70,
                                                decoration: BoxDecoration(
                                                  borderRadius:
                                                      BorderRadius.circular(16),
                                                  color: Color(0xff079450),
                                                  image: DecorationImage(
                                                    image: AssetImage(
                                                        'assets/a.png'),
                                                    fit: BoxFit.cover,
                                                    opacity: 0.1,
                                                  ),
                                                ),
                                                child: Column(
                                                  children: [
                                                    Expanded(
                                                      flex: 1,
                                                      child: Text(
                                                        airQualityData
                                                            .indexes[1]
                                                            .displayName,
                                                        style: GoogleFonts
                                                            .varelaRound(
                                                                fontSize: 12,
                                                                color: Colors
                                                                    .white),
                                                      ),
                                                    ),
                                                    Expanded(
                                                      flex: 2,
                                                      child: Text(
                                                        airQualityData
                                                            .indexes[1].aqi
                                                            .toString(),
                                                        style: GoogleFonts
                                                            .varelaRound(
                                                          color: Colors.white,
                                                          fontWeight:
                                                              FontWeight.bold,
                                                          fontSize: 25,
                                                        ),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ),
                                          ],
                                        )
                                      ],
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Row(
                                      children: [
                                        Text(
                                          'Last Updated : ' + formattedDateTime,
                                          style: GoogleFonts.varelaRound(
                                              color: Colors.white),
                                        )
                                      ],
                                    ),
                                  )
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: [
                      MetricCard(
                        backgroundColor: Colors.red,
                        metric: airQualityData.pollutants[0].displayName,
                        metricValue: airQualityData
                            .pollutants[0].concentration.value
                            .toString(),
                      ),
                      MetricCard(
                        backgroundColor: Colors.blue,
                        metric: airQualityData.pollutants[1].displayName,
                        metricValue: airQualityData
                            .pollutants[1].concentration.value
                            .toString(),
                      ),
                      MetricCard(
                        backgroundColor: Colors.orange,
                        metric: airQualityData.pollutants[2].displayName,
                        metricValue: airQualityData
                            .pollutants[2].concentration.value
                            .toString(),
                      ),
                      MetricCard(
                        backgroundColor: Colors.lime,
                        metric: airQualityData.pollutants[3].displayName,
                        metricValue: airQualityData
                            .pollutants[3].concentration.value
                            .toString(),
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  height: 10,
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Health Recommendations',
                        style: GoogleFonts.varelaRound(
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                        ),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: ListTile(
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16)),
                    tileColor: Colors.white,
                    leading: Icon(
                      Icons.person_3,
                    ),
                    title: Text(
                      airQualityData.healthRecommendations.generalPopulation,
                      style: GoogleFonts.varelaRound(fontSize: 14),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: ListTile(
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16)),
                    tileColor: Colors.white,
                    leading: Icon(
                      Icons.elderly,
                    ),
                    title: Text(
                      airQualityData.healthRecommendations.elderly,
                      style: GoogleFonts.varelaRound(fontSize: 14),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    children: [
                      Text(
                        'Air Quality Prediction',
                        style: GoogleFonts.varelaRound(
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                        ),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Container(
                    width: MediaQuery.of(context).size.width,
                    height: 150,
                    decoration: BoxDecoration(
                      color: Colors.indigo.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                            'Using AI,we can predict air quality around you from photo and give you recommendations.',
                            style: GoogleFonts.varelaRound(fontSize: 16),
                            textAlign: TextAlign.center,
                          ),
                        ),
                        ElevatedButton(
                          onPressed: () {
                            getImageFromGallery();
                          },
                          child: Text(
                            'Select Photo',
                            style: GoogleFonts.varelaRound(
                              fontSize: 14,
                              color: Colors.black,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          )
        : Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              LottieBuilder.asset('assets/world.json'),
              Text(
                'Loading...',
                style: GoogleFonts.varelaRound(
                    fontSize: 20, fontWeight: FontWeight.bold),
              )
            ],
          );
  }
}
