import 'package:flutter/material.dart';
import 'package:weatherapp/Pages/home_page.dart';

class ErrorPage extends StatelessWidget {
  const ErrorPage({
    super.key,
    required this.city,
  });

  final String? city;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        image: DecorationImage(
            image: AssetImage('lib/Assets/Images/cloudy.jpeg'),
            fit: BoxFit.cover),
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
          leading: const Icon(
            Icons.location_on_outlined,
            size: 30,
          ),
          title: Center(
            widthFactor: 1,
            child: Row(
              children: [
                Text(
                  city!,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const Icon(
                  Icons.arrow_drop_down_outlined,
                  size: 30,
                ),
              ],
            ),
          ),
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const Text(
                'Location Not Found',
              ),
              const SizedBox(
                height: 80,
              ),
              ElevatedButton(
                onPressed: () {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const HomePage(),
                    ),
                  );
                },
                child: const Text(
                  'Auto',
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
