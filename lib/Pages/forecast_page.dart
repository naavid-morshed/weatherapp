import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../Model/Class/forecast.dart';

class ForecastPage extends StatefulWidget {
  const ForecastPage({
    super.key,
    required this.weatherData,
  });

  final MyForecast weatherData;

  @override
  State<ForecastPage> createState() => _ForecastPageState();
}

class _ForecastPageState extends State<ForecastPage> {
  late int currentDay;
  late ScrollController _scrollController;
  late double scrollToIndex;
  late String currentHour;
  @override
  void initState() {
    super.initState();
    currentHour = parse24HoursOfToday();
    currentDay = 0;
    scrollToIndex = double.parse(parse24HoursOfToday());
    _scrollController = ScrollController();
    WidgetsBinding.instance.addPostFrameCallback(
      (_) {
        _scrollController.jumpTo(
          scrollToIndex * 135,
        );
      },
    );
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  String parse24HoursOfToday() {
    String? localTime = widget.weatherData.location?.localtime;
    int? spaceIndex = localTime?.indexOf(' ');
    String? firstPart = localTime?.substring(0, spaceIndex);
    String? restPart = localTime?.substring(spaceIndex! + 1);
    if (restPart?[1] == ':') {
      restPart = '0$restPart';
    }
    restPart = ' $restPart';
    var currentHour = DateFormat('H').format(
      DateTime.parse(
        '$firstPart$restPart',
      ),
    );
    return currentHour;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        image: DecorationImage(
          image: AssetImage(
            'lib/Assets/Images/cloudy.jpeg',
          ),
          fit: BoxFit.cover,
        ),
      ),
      child: GestureDetector(
        onHorizontalDragUpdate: (details) {
          // Calculate the middle of the screen
          double middleX = MediaQuery.of(context).size.width / 2;
          // Check if the user swiped rightwards from the middle of the screen
          if (details.globalPosition.dx > middleX) {
            Navigator.pop(context);
          }
        },
        child: Scaffold(
          backgroundColor: Colors.transparent,
          appBar: AppBar(
            backgroundColor: Colors.transparent,
            shadowColor: Colors.transparent,
            leading: IconButton(
              icon: const Icon(
                Icons.arrow_back,
                size: 30,
              ),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
            centerTitle: false,
            actions: [
              Center(
                child: Padding(
                  padding: EdgeInsets.only(
                    right: MediaQuery.of(context).size.width * .04,
                  ),
                  child: Card(
                    color: Colors.black87.withOpacity(.3),
                    shadowColor: Colors.transparent,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 10),
                      child: Row(
                        children: [
                          const Text(
                            'Today : ',
                            style: TextStyle(
                              fontSize: 25,
                              color: Colors.white,
                            ),
                          ),
                          Text(
                            widget.weatherData.location?.localtime?.substring(
                                    11,
                                    widget.weatherData.location?.localtime
                                        ?.length) ??
                                '',
                            style: const TextStyle(
                              fontSize: 25,
                              color: Colors.white,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ],
            title: Text(
              '${widget.weatherData.location?.name}',
              style: const TextStyle(fontSize: 25),
            ),
          ),
          body: Column(
            children: [
              Expanded(
                flex: 1,
                child: Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: MediaQuery.of(context).size.width * .05,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        currentDay == 0
                            ? 'Today'
                            : DateFormat('EEEE').format(
                                DateTime.parse(
                                  '${widget.weatherData.forecast?.forecastday?[currentDay].date}',
                                ),
                              ),
                        style: const TextStyle(
                          fontSize: 25,
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        DateFormat('MMMM, d').format(
                          DateTime.parse(
                            '${widget.weatherData.forecast?.forecastday?[currentDay].date}',
                          ),
                        ),
                        style: const TextStyle(
                          fontSize: 25,
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Expanded(
                flex: 5,
                child: ListView.separated(
                  physics: const BouncingScrollPhysics(),
                  separatorBuilder: (context, index) => Container(),
                  controller: _scrollController,
                  scrollDirection: Axis.horizontal,
                  itemCount: widget.weatherData.forecast?.forecastday?[currentDay].hour?.length ?? 0,
                  itemBuilder: (context, index) {
                    Hour? hour = widget.weatherData.forecast?.forecastday?[currentDay].hour?[index];
                    String? hourInterval = hour?.time?.substring((hour.time!.length) - 5,).substring(0, 2);
                    return Container(
                      width: 120,
                      margin: const EdgeInsets.only(left: 15),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(15),
                        color: (hourInterval == currentHour && currentDay == 0)
                                ? Colors.indigo.withOpacity(.7)
                                : Colors.blueGrey.withOpacity(.7),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Text(
                            '${hour?.tempC} °C',
                            style: TextStyle(
                                color: Colors.black.withOpacity(.7),
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                            ),
                          ),
                          Image.network(
                            'https:${hour?.condition?.icon}',
                            scale: .75,
                          ),
                          SizedBox(
                            height: 120,
                            child: Center(
                              child: Text(
                                hour?.condition?.text ?? '',
                                style: TextStyle(
                                  color: Colors.black.withOpacity(.7),
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                ),
                                maxLines: 3,
                                textAlign: TextAlign.center,
                              ),
                            ),
                          ),
                          Text(
                            hour?.time?.substring((hour.time!.length) - 5,) ?? '',
                            style: TextStyle(
                              color: Colors.black.withOpacity(.7),
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ),
              Expanded(
                flex: 1,
                child: Padding(
                  padding: EdgeInsets.symmetric(
                      horizontal: MediaQuery.of(context).size.width * .05,
                  ),
                  child: Center(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'Next Forecast',
                          style: TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Card(
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                          ),
                          color: Colors.black.withOpacity(.2),
                          shadowColor: Colors.transparent,
                          elevation: .5,
                          child: const Padding(
                            padding: EdgeInsets.all(2.0),
                            child: Icon(
                              Icons.calendar_month_outlined,
                              size: 35,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              Expanded(
                flex: 5,
                child: Center(
                  child: ListView.builder(
                    itemCount: widget.weatherData.forecast?.forecastday?.length,
                    itemBuilder: (context, index) {
                      return currentDay != index ? Padding(
                              padding: EdgeInsets.symmetric(horizontal: MediaQuery.of(context).size.width * .05),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    DateFormat('MMMM, d').format(
                                      DateTime.parse(
                                        '${widget.weatherData.forecast?.forecastday?[index].date}',
                                      ),
                                    ),
                                    style: const TextStyle(fontSize: 25),
                                  ),
                                  Image.network(
                                    'https:${widget.weatherData.forecast?.forecastday?[index].day?.condition?.icon}',
                                    scale: .75,
                                  ),
                                  Text(
                                    '${widget.weatherData.forecast?.forecastday?[index].day?.avgtempC}°C',
                                    style: const TextStyle(fontSize: 25),
                                  ),
                                  InkWell(
                                    onTap: () {
                                      setState(() {
                                        currentDay = index;
                                        currentDay == 0
                                            ? WidgetsBinding.instance
                                                .addPostFrameCallback((_) {
                                                _scrollController.animateTo(
                                                    scrollToIndex * 135,
                                                    curve: Curves.easeInOut,
                                                    duration: const Duration(
                                                        milliseconds: 300));
                                              })
                                            : null;
                                      });
                                    },
                                    child: Card(
                                      shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(8)),
                                      color: Colors.blueGrey.withOpacity(.7),
                                      shadowColor: Colors.transparent,
                                      elevation: .5,
                                      child: const Padding(
                                        padding: EdgeInsets.all(2.0),
                                        child: Icon(
                                          Icons.bar_chart,
                                          size: 35,
                                        ),
                                      ),
                                    ),
                                  )
                                ],
                              ),
                            )
                          : Container();
                    },
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
