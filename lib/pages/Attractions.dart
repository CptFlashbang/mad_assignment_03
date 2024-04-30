//Master list
  //Read in from github repo

//Detail
import 'package:flutter/material.dart';
import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart';

class AttractionsPage extends StatefulWidget {
  const AttractionsPage({Key? key}) : super(key: key);

  static Route<dynamic> route() => MaterialPageRoute(
        builder: (context) => AttractionsPage(),
      );

  @override
  _AttractionsPageState createState() => _AttractionsPageState();
}

class _AttractionsPageState extends State<AttractionsPage> {
  final HttpService httpService = HttpService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Attractions"),
      ),
      body: FutureBuilder(
        future: httpService.getPosts(),
        builder: (BuildContext context, AsyncSnapshot<List<Post>> snapshot) {
          if (snapshot.hasData) {
            List<Post>? posts = snapshot.data;
            return ListView(
              children: posts!
                  .map(
                    (Post post) => ListTile(
                      title: Text(post.attractionTitle),
                  ),
                  )
                  .toList(),
            );
          } else {
            return Center(child: Text("Not fetching"));
          }
        },
      ),
    );
  }
}

class HttpService {
  final String postsURL = "https://CptFlashbang.github.io/mad_assignment_03/apiAttractions.json";

  Future<List<Post>> getPosts() async {
    Response res = await get(Uri.parse(postsURL));

    if (res.statusCode == 200) {
      List<dynamic> body = jsonDecode(res.body);

      List<Post> posts = body
          .map(
            (dynamic item) => Post.fromJson(item),
      )
          .toList();

      return posts;
    } else {
      throw "Unable to retrieve posts.";
    }
  }
}

class Post {
  final String attractionTitle;
  final String attractionDescription;

  Post(
      {required this.attractionTitle,
        required this.attractionDescription});

  factory Post.fromJson(Map<String, dynamic> json) {
    return Post(
        attractionTitle: json['attractionTitle'] as String,
        attractionDescription: json['attractionDescription'] as String);
  }
}


