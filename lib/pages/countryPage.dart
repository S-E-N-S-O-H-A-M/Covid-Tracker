import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:covid_tracker/pages/search.dart';

class CountryPage extends StatefulWidget {
  @override
  _CountryPageState createState() => _CountryPageState();
}

class _CountryPageState extends State<CountryPage> {
  final String url = 'https://corona.lmao.ninja/v2/countries';
  List countryData;
  fetchCountryData() async {
    http.Response response = await http.get(url);
    setState(() {
      countryData = json.decode(response.body);
    });
  }

  @override
  void initState() {
    fetchCountryData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Country Stats'),
          actions: [
            IconButton(
                icon: Icon(Icons.search),
                onPressed: () {
                  showSearch(context: context, delegate: Search(countryData));
                })
          ],
        ),
        body: countryData == null
            ? Center(child: CircularProgressIndicator())
            : ListView.builder(
                itemCount: countryData == null ? 0 : countryData.length,
                itemBuilder: (context, index) {
                  return Card(
                      child: Container(
                          margin: EdgeInsets.symmetric(
                              horizontal: 10, vertical: 10),
                          height: 130,
                          // decoration: BoxDecoration(
                          //     color: Colors.white,
                          //     boxShadow: [
                          //       BoxShadow(
                          //           color: Colors.grey[100],
                          //           blurRadius: 10,
                          //           offset: Offset(0, 10))
                          //     ]),
                          child: Row(
                            children: [
                              Container(
                                  width: 200,
                                  margin: EdgeInsets.symmetric(horizontal: 10),
                                  child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Text(
                                          countryData[index]['country'],
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold),
                                        ),
                                        Image.network(
                                          countryData[index]['countryInfo']
                                              ['flag'],
                                          height: 50,
                                          width: 60,
                                        ),
                                      ])),
                              Expanded(
                                child: Container(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                          'CONFIRMED:' +
                                              countryData[index]['cases']
                                                  .toString(),
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              color: Colors.red)),
                                      Text(
                                          'ACTIVE:' +
                                              countryData[index]['active']
                                                  .toString(),
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              color: Colors.blue)),
                                      Text(
                                          'RECOVERED' +
                                              countryData[index]['recovered']
                                                  .toString(),
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              color: Colors.green)),
                                      Text(
                                          'DEATHS' +
                                              countryData[index]['deaths']
                                                  .toString(),
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              color: Theme.of(context)
                                                          .brightness ==
                                                      Brightness.dark
                                                  ? Colors.grey[100]
                                                  : Colors.grey[900])),
                                    ],
                                  ),
                                ),
                              )
                            ],
                          )));
                },
              ));
  }
}
