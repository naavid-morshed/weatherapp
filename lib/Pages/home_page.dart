import 'package:flutter/material.dart';
import 'package:weatherapp/Model/Class/forecast.dart';
import 'package:weatherapp/Pages/waiting_page.dart';
import 'package:weatherapp/ViewModel/fetch_forecast_data.dart';
import 'package:intl/intl.dart';

import 'forecast_page.dart';
class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late String? city;
  late String qParameter;
  late TextEditingController _latController;
  late TextEditingController _longController;
  late TextEditingController _locationBySearchController;
  String? location;
  late DateTime today;

  @override
  void initState() {
    super.initState();
    city = 'Placeholder';
    qParameter = 'auto';
    today = DateTime.now();
    _latController = TextEditingController();
    _longController = TextEditingController();
    _locationBySearchController = TextEditingController();
  }

  @override
  void dispose() {
    super.dispose();

    _latController.dispose();
    _longController.dispose();
    _locationBySearchController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Material App',
      debugShowCheckedModeBanner: false,
      home: StreamBuilder<MyForecast>(
        stream: qParameter == 'auto'
            ? fetchForecastResult()
            : qParameter == 'longlat'
                ? fetchForecastResult(
                    latitude: _latController.text,
                    longitude: _longController.text,
                  )
                : qParameter == 'location'
                    ? fetchForecastResult(location: location)
                    : fetchForecastResult(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            MyForecast weatherData = snapshot.data as MyForecast;
            city = weatherData.location?.name;
            return Container(
              decoration: const BoxDecoration(
                image: DecorationImage(
                  image: AssetImage(
                    'lib/Assets/Images/cloudy.jpeg',
                  ),
                  fit: BoxFit.cover,
                ),
              ),
              child: Scaffold(
                backgroundColor: Colors.transparent,
                appBar: AppBar(
                  backgroundColor: Colors.transparent,
                  shadowColor: Colors.transparent,
                  actions: const [
                    Icon(
                      Icons.notifications_none_rounded,
                      size: 30,
                    ),
                    SizedBox(
                      width: 20,
                    ),
                  ],
                  leading: InkWell(
                    onTap: () => showModalBottomSheet(
                        // backgroundColor: Colors.transparent,
                        context: context,
                        builder: (BuildContext context) {
                          return Column(
                            children: [
                              Card(
                                child: TextField(
                                  controller: _latController,
                                  keyboardType: const TextInputType.numberWithOptions(
                                    decimal: true,
                                  ),
                                  decoration: const InputDecoration(
                                    hintText: '  latitude',
                                    border: InputBorder.none,
                                  ),
                                  enableSuggestions: true,
                                  onTapOutside: (event) {
                                    FocusScope.of(context).unfocus();
                                  },
                                ),
                              ),
                              Card(
                                // color: Colors.transparent,
                                child: TextField(
                                  controller: _longController,
                                  keyboardType: const TextInputType.numberWithOptions(
                                    decimal: true,
                                  ),
                                  decoration: const InputDecoration(
                                    hintText: '  longitude',
                                    border: InputBorder.none,
                                  ),
                                  enableSuggestions: true,
                                ),
                              ),
                              ElevatedButton(
                                onPressed: () {
                                  if (_latController.text.isNotEmpty && _longController.text.isNotEmpty) {
                                    setState(() {
                                      qParameter = 'longlat';
                                    });
                                    Navigator.pop(context);
                                  }
                                },
                                child: const Text(
                                  'Search',
                                ),
                              ),
                            ],
                          );
                        }),
                    child: const Icon(
                      Icons.location_on_outlined,
                      size: 30,
                    ),
                  ),
                  title: Center(
                      widthFactor: 1,
                      child: Row(
                        children: [
                          SizedBox(
                            width: MediaQuery.of(context).size.width * .01,
                          ),
                          Text('${city!} '),
                          SizedBox(
                            width: MediaQuery.of(context).size.width * .01,
                          ),
                          const Icon(
                            Icons.arrow_drop_down_outlined,
                          ),
                        ],
                      ),
                  ),
                ),
                body: Stack(
                  children: [
                    SingleChildScrollView(
                      child: Column(
                        children: [
                          Align(
                            alignment: Alignment.topCenter,
                            child: Image.network(
                              'https:' '${weatherData.current?.condition?.icon}',
                              scale: MediaQuery.of(context).size.aspectRatio * 1,
                            ),
                          ),
                          GestureDetector(
                            onHorizontalDragUpdate: (details) {
                              // Calculate the middle of the screen
                              double screenWidth = MediaQuery
                                  .of(context)
                                  .size
                                  .width;
                              double middleX = screenWidth / 2;

                              // Check if the user swiped leftwards from the middle of the screen
                              if (details.globalPosition.dx < middleX) {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => ForecastPage(weatherData: weatherData),),
                                );
                              }
                            },
                            child: Padding(
                              padding: EdgeInsets.only(top: MediaQuery.of(context).size.height * .08),
                              child: Align(
                                alignment: Alignment.center,
                                child: Container(
                                  height: MediaQuery.of(context).size.height * .5,
                                  width: MediaQuery.of(context).size.width * .8,
                                  decoration: BoxDecoration(
                                    color: Colors.white.withOpacity(
                                      .5,
                                    ),
                                    borderRadius: const BorderRadius.all(
                                      Radius.elliptical(
                                        35,
                                        35
                                      ),
                                    ),
                                    border: Border.all(
                                      width: .3,
                                      color: Colors.black87,
                                    ),
                                  ),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.center,
                                    children: [
                                      Expanded(
                                        flex: 1,
                                        child: Padding(
                                          padding: EdgeInsets.only(top: MediaQuery.of(context).size.height * .035),
                                          child: Text(
                                            'Today, ${DateFormat('d MMMM').format(today)}',
                                            style: const TextStyle(
                                              fontSize: 30
                                            ),
                                          ),
                                        ),
                                      ),
                                      Expanded(
                                        flex: 2,
                                        child: Center(
                                          child: Text(
                                            '${weatherData.current?.tempC.toString()}°C',
                                            style: const TextStyle(
                                              fontSize: 50,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ),
                                      ),
                                      Expanded(
                                        flex: 1,
                                        child: Container(
                                          width: MediaQuery.of(context).size.width * .7,
                                          padding: EdgeInsets.only(left: MediaQuery.of(context).size.width * .02),
                                          child: Text(
                                            '${weatherData.current?.condition?.text}',
                                            style: const TextStyle(
                                              fontSize: 30,
                                            ),
                                            maxLines: 3,
                                            textAlign: TextAlign.center,
                                          ),
                                        ),
                                      ),
                                      Expanded(
                                        flex: 1,
                                        child: Padding(
                                          padding: EdgeInsets.only(left: MediaQuery.of(context).size.height * .05),
                                          child: Row(
                                            children: [
                                              Padding(
                                                padding: EdgeInsets.only(
                                                    right: MediaQuery
                                                        .of(context)
                                                        .size
                                                        .height * .01),
                                                child: const Icon(Icons.air_rounded),
                                              ),
                                              const Text(
                                                'wind  ',
                                                style: TextStyle(
                                                    fontSize: 30
                                                ),
                                              ),
                                              const VerticalDivider(width: 1,color: Colors.black87,indent: 22,endIndent: 22, thickness: 1.5),
                                              Text(
                                                '  ${weatherData.current?.windKph} km/h',
                                                style: const TextStyle(
                                                    fontSize: 30
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                      Expanded(
                                        flex: 1,
                                        child: Padding(
                                            padding: EdgeInsets.only(left: MediaQuery.of(context).size.height * .05,
                                            ),
                                          child: Row(
                                            children: [
                                              Padding(
                                                padding: EdgeInsets.only(
                                                    right: MediaQuery
                                                        .of(context)
                                                        .size
                                                        .height * .01),
                                                child: const Icon(Icons.water_drop_outlined),
                                              ),
                                              const Text(
                                                'Hum  ',
                                                style: TextStyle(
                                                    fontSize: 30
                                                ),
                                              ),
                                              const VerticalDivider(width: 1,
                                                  color: Colors.black87,
                                                  indent: 22,
                                                  endIndent: 22,
                                                  thickness: 1.5),

                                              Text(
                                                '  ${weatherData.current?.humidity} %',
                                                style: const TextStyle(
                                                    fontSize: 30
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Align(
                      alignment: Alignment.bottomCenter,
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 100),
                        margin: EdgeInsets.only(
                          bottom: MediaQuery.of(context).viewInsets.bottom == 0 ? MediaQuery.of(context).size.height * .03 : 0,
                          left: MediaQuery.of(context).size.width * .02,
                          right: MediaQuery.of(context).size.width * .02,
                        ),
                        decoration: BoxDecoration(
                          border: Border.all(width: .3),
                          borderRadius: const BorderRadius.all(
                            Radius.circular(
                                15,
                            ),
                          ),
                          color: Colors.white.withOpacity(.5),
                        ),
                        child: Row(
                          children: [
                            SizedBox(
                              width: MediaQuery.of(context).size.width * .04,
                            ),
                            Expanded(
                              child: TextField(
                                controller: _locationBySearchController,
                                style: const TextStyle(
                                  color: Colors.black87,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 20
                                ),
                                decoration: const InputDecoration(
                                  hintText: 'Search by city',
                                  hintStyle: TextStyle(
                                    color: Colors.black87,
                                    fontSize: 20,
                                  ),
                                  border: InputBorder.none,
                                ),
                                onTapOutside: (event) {
                                  FocusScope.of(context).unfocus();
                                },
                                onSubmitted: (value) {
                                  if (_locationBySearchController.text.isNotEmpty) {
                                    setState(() {
                                      location = _locationBySearchController.text;
                                      qParameter = 'location';
                                    });
                                  }
                                },
                              ),
                            ),
                            ElevatedButton(
                              onPressed: () {
                                if (_locationBySearchController
                                    .text.isNotEmpty) {
                                  setState(() {
                                    location =
                                        _locationBySearchController.text;
                                    qParameter = 'location';
                                  });
                                }
                              },
                              style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.teal.withOpacity(.8),
                                shadowColor: Colors.transparent,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8)
                                )
                              ),
                              child: const Icon(
                                Icons.search_rounded,
                                size: 33,
                              ),
                            ),
                            SizedBox(
                              width: MediaQuery
                                  .of(context)
                                  .size
                                  .width * .015,
                            ),
                          ],
                        ),
                      ),
                    )
                  ],
                ),
              ),
            );
          } else if (snapshot.connectionState == ConnectionState.waiting) {
            return const WaitingPage();
          }
          else{
            return const HomePage();
          }
        },
      ),
    );
  }
}