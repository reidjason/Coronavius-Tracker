import 'dart:async';
import 'dart:convert';

import 'package:covid_19_tracker/CaseAmount.dart';
import 'package:covid_19_tracker/Region.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import 'Services.dart';

Future<CaseAmount> fetchCaseAmount() async {
  final response = await http.get('https://covid19.mathdro.id/api');
  if (response.statusCode == 200) {
    return CaseAmount.fromJson(json.decode(response.body));
  } else {
    throw Exception('Unable to fetch case amounts from the REST API');
  }
}

void main() => runApp(MyApp());

class MyApp extends StatefulWidget {
  @override
  MyAppState createState() {
    return MyAppState();
  }
}

class MyAppState extends State<MyApp> {
  List<Region> regions = List();
  List<Region> filteredRegions = List();
  TextEditingController controller = new TextEditingController();
  Future<CaseAmount> caseAmount;

  void initState() {
    super.initState();
    caseAmount = fetchCaseAmount();
    Services.fetchRegions().then((regionsFromServer) {
      setState(() {
        regions = regionsFromServer;
        filteredRegions = regions;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'COVID-19 Tracker',
      theme: ThemeData(
        primarySwatch: Colors.red,
        fontFamily: 'SourceSansPro',
      ),
      home: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          title: Text('COVID-19 Tracker'),
        ),
        body: SafeArea(
          child: Column(
            children: <Widget>[
              buildGlobalCaseInfo(),
              SizedBox(
                height: 10,
              ),
              TextField(
                decoration: InputDecoration(
                    contentPadding: EdgeInsets.all(15.0),
                    hintText: 'Search by country or region',
                    icon: Icon(Icons.search)),
                onChanged: (string) {
                  setState(() {
                    filteredRegions = regions
                        .where((u) => (u.provinceState
                                .toLowerCase()
                                .contains(string.toLowerCase()) ||
                            u.countryRegion
                                .toLowerCase()
                                .contains(string.toLowerCase())))
                        .toList();
                  });
                },
              ),
              Expanded(child: regionsListView(filteredRegions)),
            ],
          ),
        ),
      ),
    );
  }

  Container buildGlobalCaseInfo() {
    return Container(
      color: Colors.white,
      child: Column(
        children: <Widget>[
          Container(
            child: Text(
              "Global COVID-19 Data",
              style: TextStyle(fontSize: 30),
            ),
          ),
          Column(
            children: <Widget>[
              Container(
                  child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  Container(
                    height: 75,
                    width: 125,
                    decoration: BoxDecoration(
                      color: Colors.red,
                      border: Border.all(
                        color: Colors.black,
                        width: 4,
                      ),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: <Widget>[
                        Text('Confirmed: ',
                            style: TextStyle(
                              fontSize: 17,
                            )),
                        FutureBuilder<CaseAmount>(
                          future: caseAmount,
                          builder: (context, snapshot) {
                            if (snapshot.hasData) {
                              return Text(
                                snapshot.data.confirmed.toString(),
                                style: TextStyle(
                                    fontSize: 20, fontWeight: FontWeight.bold),
                              );
                            } else if (snapshot.hasError) {
                              return Text("${snapshot.error}");
                            }
                            return CircularProgressIndicator();
                          },
                        ),
                      ],
                    ),
                  ),
                  Container(
                    height: 75,
                    width: 125,
                    decoration: BoxDecoration(
                      color: Colors.red,
                      border: Border.all(
                        color: Colors.black,
                        width: 4,
                      ),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: <Widget>[
                        Text('Deaths: ',
                            style: TextStyle(
                              fontSize: 17,
                            )),
                        FutureBuilder<CaseAmount>(
                          future: caseAmount,
                          builder: (context, snapshot) {
                            if (snapshot.hasData) {
                              return Text(
                                snapshot.data.deaths.toString(),
                                style: TextStyle(
                                    fontSize: 20, fontWeight: FontWeight.bold),
                              );
                            } else if (snapshot.hasError) {
                              return Text("${snapshot.error}");
                            }
                            return CircularProgressIndicator();
                          },
                        ),
                      ],
                    ),
                  ),
                  Container(
                    height: 75,
                    width: 125,
                    decoration: BoxDecoration(
                      color: Colors.red,
                      border: Border.all(
                        color: Colors.black,
                        width: 4,
                      ),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: <Widget>[
                        Text('Recovered: ',
                            style: TextStyle(
                              fontSize: 17,
                            )),
                        FutureBuilder<CaseAmount>(
                          future: caseAmount,
                          builder: (context, snapshot) {
                            if (snapshot.hasData) {
                              return Text(
                                snapshot.data.recovered.toString(),
                                style: TextStyle(
                                    fontSize: 20, fontWeight: FontWeight.bold),
                              );
                            } else if (snapshot.hasError) {
                              return Text("${snapshot.error}");
                            }
                            return CircularProgressIndicator();
                          },
                        ),
                      ],
                    ),
                  ),
                ],
              )),
            ],
          ),
          SizedBox(
            height: 10,
          )
        ],
      ),
    );
  }
}

ListTile tile(String provinceState, String countryRegion, int confirmed,
        int recovered, int deaths, int active) =>
    ListTile(
      title: Text(countryRegion + provinceState,
          style: TextStyle(fontWeight: FontWeight.w500, fontSize: 20)),
      subtitle: Text("Confirmed: " +
          confirmed.toString() +
          "   Deaths: " +
          recovered.toString() +
          "   Recovered: " +
          deaths.toString()),
    );

ListView regionsListView(filteredRegions) {
  return ListView.builder(
      itemCount: filteredRegions.length,
      itemBuilder: (context, index) {
        return tile(
            filteredRegions[index].countryRegion,
            filteredRegions[index].provinceState,
            filteredRegions[index].confirmed,
            filteredRegions[index].deaths,
            filteredRegions[index].recovered,
            filteredRegions[index].active);
      });
}
