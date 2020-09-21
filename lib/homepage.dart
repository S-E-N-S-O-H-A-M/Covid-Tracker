import 'dart:convert';

import 'package:covid_tracker/datasource.dart';
import 'package:covid_tracker/panels/infoPanel.dart';
import 'package:covid_tracker/panels/mostaffectedcountries.dart';
import 'package:covid_tracker/panels/worldwidepanel.dart';
import 'package:covid_tracker/pages/countryPage.dart';
import 'package:dynamic_theme/dynamic_theme.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:pie_chart/pie_chart.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final String url1 = 'https://corona.lmao.ninja/v2/all';
  final String url2 = 'https://corona.lmao.ninja/v2/countries?sort=cases';

  Map worldData;
  fetchWorldWideData() async {
    http.Response response = await http.get(url1);
    setState(() {
      worldData = jsonDecode(response.body);
    });
  }

  List countryData;
  fetchCountryData() async {
    http.Response response = await http.get(url2);
    setState(() {
      countryData = jsonDecode(response.body);
    });
  }

  Future fetchData() async {
    fetchWorldWideData();
    fetchCountryData();
    print('FetchData Called');
  }

  @override
  void initState() {
    fetchData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("COVID-19 TRACKER"),
        centerTitle: false,
        elevation: 10,
        actions: [
          IconButton(
              icon: Icon(Theme.of(context).brightness == Brightness.light
                  ? Icons.lightbulb_outline
                  : Icons.highlight),
              onPressed: () {
                DynamicTheme.of(context).setBrightness(
                    Theme.of(context).brightness == Brightness.light
                        ? Brightness.dark
                        : Brightness.light);
              })
        ],
      ),
      body: RefreshIndicator(
          onRefresh: fetchData,
          child: ListView(
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    alignment: Alignment.center,
                    padding: EdgeInsets.all(10),
                    height: 100,
                    color: Colors.orange[100],
                    child: Text(DataSource.quote,
                        style: TextStyle(
                            color: Colors.orange[800],
                            fontWeight: FontWeight.bold,
                            fontSize: 16.0)),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        vertical: 10.0, horizontal: 10),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "World Wide",
                          style: TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        GestureDetector(
                          onTap: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => CountryPage()));
                          },
                          child: Container(
                            decoration: BoxDecoration(
                                color: primaryBlack,
                                borderRadius: BorderRadius.circular(15)),
                            padding: EdgeInsets.all(10),
                            child: Text(
                              "Regional",
                              style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  worldData == null
                      ? CircularProgressIndicator()
                      : WorldWidePanel(
                          worldData: worldData,
                        ),
                  PieChart(
                    dataMap: {
                      'Confirmed': worldData['cases'].toDouble(),
                      'Active': worldData['active'].toDouble(),
                      'Recovered': worldData['recovered'].toDouble(),
                      'Deaths': worldData['deaths'].toDouble(),
                    },
                    colorList: [
                      Colors.red,
                      Colors.blue,
                      Colors.green,
                      Colors.grey[900],
                    ],
                  ),
                  Padding(
                    padding:
                        EdgeInsets.symmetric(horizontal: 10.0, vertical: 10),
                    child: Text(
                      "Most Affected Countries",
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  countryData == null
                      ? Container()
                      : MostAffectedPanel(countryData: countryData),
                  SizedBox(height: 20),
                  InfoPanel(),
                  SizedBox(height: 20),
                  Center(
                    child: Text('WE ARE TOGETHER IN THE FIGHT',
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 16)),
                  ),
                  SizedBox(height: 50),
                ],
              ),
            ],
          )), //we can also use SingleChildScrollView instead of ListView
    );
  }
}
