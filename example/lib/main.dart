import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_watch_rewards/flutter_watch_rewards.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  double currentValue = 0.5;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Watch Rewards'),
      ),
      body: Container(
        child: Stack(
          children: [
            // base
            Container(),

            // watch rewards
            Positioned(
              top: 32.0,
              right: 16.0,
              child: WatchRewards(
                radius: 32.0,
                foregroundColor: Colors.red,
                backgroundColor: Colors.pink.shade50,
                buttonColorBegin: Colors.amber,
                buttonColorEnd: Colors.pink,
                buttonTitle: 'Claim',
                value: currentValue,
                stepValue: 0.05,
                watchInteval: 5,
                icon: Icon(
                  Icons.monetization_on,
                  color: Colors.amber.shade500,
                ),
                onValueChanged: (v) {
                  setState(() {
                    currentValue = v;
                    log('${currentValue}');
                  });
                },
                onTap: () {
                  log('tap');
                },
              ),
            )
          ],
        ),
      ),
    );
  }
}
