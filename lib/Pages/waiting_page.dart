import 'package:flutter/material.dart';

class WaitingPage extends StatelessWidget {
  const WaitingPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        image: DecorationImage(
            image: AssetImage('lib/Assets/Images/cloudy.jpeg'),
            fit: BoxFit.cover
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
          leading: const Icon(
            Icons.location_on_outlined,
            size: 30,
          ),
          title: const Center(
            widthFactor: 1,
            child: Row(
              children: [
                SizedBox(width: 30),
                CircularProgressIndicator(),
                SizedBox(width: 50),
                Icon(
                  Icons.arrow_drop_down_outlined,
                  size: 30,
                ),
              ],
            ),
          ),
        ),
        body: const Column(
          children: [
            Text('Loading',),
          ],
        ),
      ),
    );
  }
}
