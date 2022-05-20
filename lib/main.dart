import 'dart:async';

import 'package:flutter/material.dart';
import 'package:health_kit_reporter/health_kit_reporter.dart';
import 'package:health_kit_reporter/model/type/quantity_type.dart';

import './widgets.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  Stream<int>hbpm = const Stream<int>.empty();
  
  @override
  void initState() {
    super.initState();
    hbpm = Stream<int>.periodic(const Duration(seconds: 1), (x) => x);
  }
  
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
          appBar: AppBar(
            title: const Text('Health Example'),
          ),
          body: FutureBuilder(
            future:  HealthKitReporter.requestAuthorization([QuantityType.heartRate.identifier], []),
            builder: (context, snapshot) {
              if( snapshot.hasData && snapshot.data == true )
                return StreamBuilder(
                  stream: hbpm,
                  builder: (context, snapshot) => HBPM(),
                );
              
              return const Center(child: CircularProgressIndicator(strokeWidth: 6,));
            }
          ),
      )
    );
  }
}