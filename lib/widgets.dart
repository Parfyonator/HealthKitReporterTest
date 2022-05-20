import 'dart:async';

import 'package:flutter/material.dart';
import 'package:health_kit_reporter/health_kit_reporter.dart';
import 'package:health_kit_reporter/model/payload/quantity.dart';
import 'package:health_kit_reporter/model/predicate.dart';
import 'package:health_kit_reporter/model/type/quantity_type.dart';

Future<List<Quantity>> getData() async {
  final now = DateTime.now();
  final prefUnits = await HealthKitReporter.preferredUnits([QuantityType.heartRate]);
  final hrUnits = prefUnits.first.unit;
  final hbQuery = await HealthKitReporter.quantityQuery(
    QuantityType.heartRate,
    hrUnits,
    Predicate(now.subtract(Duration(seconds: 120)), now)
  );
  hbQuery.sort(((Quantity a, Quantity b) => b.endTimestamp.compareTo(a.endTimestamp)));

  print(hbQuery.map((e) => e.harmonized.value));

  return hbQuery;
}

class HBPM extends StatelessWidget {  
  HBPM({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: getData(),
      // initialData: InitialData,
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        if( !snapshot.hasData ){
          print('Snapshot is empty.');
          return const Center(
            child: Text(
              'Snapshot is empty.',
              style: TextStyle(
                fontSize: 20,
              ),
            ),
          );
        }
        
        final healthData = snapshot.data as List<Quantity>;
        if( healthData.isNotEmpty ){
          final hb = healthData.first;
          print('#####################');
          print('HBPM: ${hb.harmonized.value}');
          print('#####################');
          return Center(
            child: Text(
              'HBPM: ${hb.harmonized.value}',
              style: const TextStyle(
                fontSize: 20,
              ),
            ),
          );
        }

        print('No heartbeat data.');
        return const Center(
          child: Text(
            'No heartbeat data available',
            style: TextStyle(
              fontSize: 20,
            ),
          ),
        );
      },
    );
  }
}