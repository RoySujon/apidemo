import 'dart:convert';

import 'package:apidemo/modelclass.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String link =
      "https://raw.githubusercontent.com/codeifitech/fitness-app/master/exercises.json?fbclid=IwAR2dcq-xBH13wH4pKR7VYlEy3NMWcU9cL5ySVNtCyvY9YiTNNQI54x-kT-M";
  List<Exercises> allData = [];
  late Exercises exercises;
  fetchData() async {
    try {
      var response = await http.get(Uri.parse('${link}'));
      print('response is ${response.statusCode}');
      if (response.statusCode == 200) {
        var data = jsonDecode(response.body)["exercises"];
        for (var i in data) {
          exercises = Exercises(
              id: i['id'],
              gif: i['gif'],
              seconds: i['seconds'],
              thumbnail: i['thumbnail'],
              title: i['title']);

          setState(() {
            allData.add(exercises);
          });
        }
      }
    } catch (e) {
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView.separated(
        itemBuilder: (context, index) => Card(
          child: Container(
            height: 180,
            width: double.infinity,
            child: Stack(
              children: [
                CachedNetworkImage(
                  imageUrl: allData[index].thumbnail.toString(),
                  placeholder: (context, url) => Image.network(
                      'https://cdn.pixabay.com/photo/2015/10/05/22/37/blank-profile-picture-973460_1280.png'),
                  errorWidget: (context, url, error) => Icon(Icons.error),
                ),
              ],
            ),
          ),
        ),
        itemCount: allData.length,
        separatorBuilder: (BuildContext context, int index) => SizedBox(
          height: 16,
        ),
      ),
    );
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    fetchData();
  }
}
