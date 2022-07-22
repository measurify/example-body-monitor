
import 'package:client/Service/data_body_monitor.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:client/Service/data_body_monitor.dart' as data;

class DataMonitorPage extends StatefulWidget {
  const DataMonitorPage({Key? key}) : super(key: key);

  @override
  State<DataMonitorPage> createState() => _DataMonitorPageState();
}

class _DataMonitorPageState extends State<DataMonitorPage> {
  final Future<bool> _data = _fetchData();
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: _data,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return Scaffold(
              backgroundColor: Theme.of(context).backgroundColor,
              body: ListView(
                children: [
                  Card(
                    clipBehavior: Clip.antiAlias,
                    child: Column(children: [
                      const ListTile(
                        leading: Icon(Icons.medical_services_outlined),
                        title: Text('Pressione Sistolica'),
                      ),
                      Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Scrollbar(
                            child: ListView.builder(
                                shrinkWrap: true,
                                physics: const NeverScrollableScrollPhysics(),
                                itemCount: systolicPressure.length,
                                itemBuilder: (BuildContext context, int index) {
                                  return Padding(
                                    padding: const EdgeInsets.all(16.0),
                                    child: Text(
                                      systolicPressure[index]
                                              .toStringAsPrecision(4) +
                                          " mmHg" +
                                          " " +
                                          DateFormat('dd/MM/yyyy')
                                              .format(measurementDates[index]),
                                      style: TextStyle(
                                          color: Colors.black.withOpacity(0.6)),
                                    ),
                                  );
                                }),
                          )),
                    ]),
                  ),
                  Card(
                    clipBehavior: Clip.antiAlias,
                    child: Column(
                      children: [
                        const ListTile(
                          leading: Icon(Icons.medical_services),
                          title: Text('Pressione Diastolica'),
                        ),
                        Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: Scrollbar(
                              child: ListView.builder(
                                  shrinkWrap: true,
                                  physics: const NeverScrollableScrollPhysics(),
                                  itemCount: dyastolicPressure.length,
                                  itemBuilder:
                                      (BuildContext context, int index) {
                                    return Padding(
                                      padding: const EdgeInsets.all(16.0),
                                      child: Text(
                                        dyastolicPressure[index]
                                                .toStringAsPrecision(4) +
                                            " mmHg" +
                                            " " +
                                            DateFormat('dd/MM/yyyy').format(
                                                measurementDates[index]),
                                        style: TextStyle(
                                            color:
                                                Colors.black.withOpacity(0.6)),
                                      ),
                                    );
                                  }),
                            )),
                      ],
                    ),
                  ),
                  Card(
                    clipBehavior: Clip.antiAlias,
                    child: Column(
                      children: [
                        const ListTile(
                          leading: Icon(Icons.monitor_heart),
                          title: Text('Frequenza Cardiaca'),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Scrollbar(
                              child: ListView.builder(
                                  shrinkWrap: true,
                                  physics: const NeverScrollableScrollPhysics(),
                                  itemCount: heartRate.length,
                                  itemBuilder:
                                      (BuildContext context, int index) {
                                    return Padding(
                                        padding: const EdgeInsets.all(16.0),
                                        child: Text(
                                          heartRate[index]
                                                  .toStringAsPrecision(2) +
                                              " bpm" +
                                              " " +
                                              DateFormat('dd/MM/yyyy').format(
                                                  measurementDates[index]),
                                          style: TextStyle(
                                              color: Colors.black
                                                  .withOpacity(0.6)),
                                        ));
                                  })),
                        ),
                      ],
                    ),
                  ),
                  Card(
                    clipBehavior: Clip.antiAlias,
                    child: Column(
                      children: [
                        const ListTile(
                          leading: Icon(Icons.health_and_safety_rounded),
                          title: Text('Saturazione'),
                        ),
                        Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: Scrollbar(
                              child: ListView.builder(
                                  shrinkWrap: true,
                                  physics: const NeverScrollableScrollPhysics(),
                                  itemCount: saturation.length,
                                  itemBuilder:
                                      (BuildContext context, int index) {
                                    return Padding(
                                      padding: const EdgeInsets.all(16.0),
                                      child: Text(
                                        saturation[index]
                                                .toStringAsPrecision(2) +
                                            "%" +
                                            " " +
                                            DateFormat('dd/MM/yyyy').format(
                                                measurementDates[index]),
                                        style: TextStyle(
                                            color:
                                                Colors.black.withOpacity(0.6)),
                                      ),
                                    );
                                  }),
                            )),
                      ],
                    ),
                  ),
                  Card(
                      color: Theme.of(context).backgroundColor,
                      child: Padding(
                          padding:
                              const EdgeInsets.only(top: 10.0, bottom: 20.0),
                          child: IconButton(
                            icon: const Icon(
                              Icons.refresh,
                            ),
                            iconSize: 20,
                            onPressed: () {
                              fetchData();
                            },
                          )))
                ],
              ),
            );
          } else if (snapshot.hasError) {
            print("Errore: ${snapshot.error.toString()}");
            return const Text("Qualcosa è andato storto");
          } else {
            return Scaffold(
              backgroundColor: Theme.of(context).backgroundColor,
              body: SingleChildScrollView(
                child: ConstrainedBox(
                    constraints: const BoxConstraints(minHeight: 20),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: <Widget>[
                        Container(
                          color: Theme.of(context).backgroundColor,
                          height: 120.0,
                          alignment: Alignment.center,
                          child: const Text("Aspetta, sta caricando i dati... "),
                        ),
                        Container(
                          color: Theme.of(context).backgroundColor,
                          height: 120.0,
                          alignment: Alignment.center,
                          child: const CircularProgressIndicator(),
                        ),
                      ],
                    )),
              ),
            );
          }
        });
  }

  void fetchData() {
    data.fetchSystolic();
    data.fetchDyastolic();
    data.fetchHeartRate();
    data.fetchSaturation();
  }
}

Future<bool> _fetchData() async {
  if (data.systolicPressure.isEmpty ||
      data.dyastolicPressure.isEmpty ||
      data.heartRate.isEmpty ||
      data.saturation.isEmpty) {
    await data.fetchSystolic();
    await data.fetchDyastolic();
    await data.fetchHeartRate();
    await data.fetchSaturation();
  }

  return true;
}
