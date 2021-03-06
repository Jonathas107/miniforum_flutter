import 'package:flutter/material.dart';
import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;

void main(){
  runApp(MaterialApp(
    home: Home(),
  ));
}

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  Future<List<User>> _getData() async {
    var data = await http.get("https://www.json-generator.com/api/json/get/cfwZmvEBbC?indent=2");
    var jsonData = json.decode(data.body);

    List<User> users = [];

    for(var u in jsonData){
      User user = User(u["index"], u["about"], u["name"], u["email"], u["picture"]);
      users.add(user);
    }
    print(users.length);

    return users;
    
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Chat do blablabla"),
        centerTitle: true,
      ),
      body: Container(
        child: FutureBuilder(
          future: _getData(),
          builder: (BuildContext context, AsyncSnapshot snapshot){
            if(snapshot.data == null){
              return Container(
                child: Center(child: Text("carregando...")),
              );
            }else{
              return ListView.builder(
                itemCount: snapshot.data.length,
                itemBuilder: (BuildContext context, int index){
                return ListTile(
                  title: Text(snapshot.data[index].name),
                  leading: CircleAvatar(backgroundImage: NetworkImage(snapshot.data[index].picture)),
                  subtitle: Text(snapshot.data[index].email),
                  onTap: (){
                    Navigator.push(context, new MaterialPageRoute(
                      builder: (context) => DetailPage(snapshot.data[index])
                    ));
                  },
                  );
                },
              );
            }
          },
        ),
      ),
    );
  }
}

class DetailPage extends StatelessWidget {
  final User user;
  DetailPage(this.user);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(user.name)),
    );
  }
}

class User{
  final int index;
  final String about;
  final String name;
  final String email;
  final String picture;

  User(this.index, this.about, this.name, this.email, this.picture);
}