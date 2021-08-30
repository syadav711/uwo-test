import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'package:webview_flutter/webview_flutter.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.

  Future init() async {
    var pref = await SharedPreferences.getInstance();
    pref.setString('email', 'sandeep@gmail.com');
    pref.setString('password', '12345678');
  }

  @override
  Widget build(BuildContext context) {
    init();
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _counter = 0;

  void _incrementCounter() {
    setState(() {
      _counter++;
    });
  }

  Future printCredentials() async {
    var pref = await SharedPreferences.getInstance();
    print(pref.getString('email'));
    print(pref.getString('password'));
  }

  getCredentials() async {
    var pref = await SharedPreferences.getInstance();
    return {
      "email": pref.getString('email'),
      "password": pref.getString('password')
    };
  }

  Future<void> onOpenWeb() async {
    await beforeOpenWeb();
  }

  Future rgisterUser() async {
    var cred = await getCredentials();

    return http.post(Uri.parse('https://9587a691c7c8.ngrok.io/api/users'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(cred));
  }

  Future beforeOpenWeb() async {
    var cred = await getCredentials();

    try {
      var loginResponse = await http.post(
          Uri.parse('https://9587a691c7c8.ngrok.io/api/auth/login'),
          headers: <String, String>{
            'Content-Type': 'application/json; charset=UTF-8',
          },
          body: jsonEncode(cred));

      if (loginResponse.statusCode == 404) {
        var response = await rgisterUser();
        if (response.statusCode == 200) {
          var token = jsonDecode(response.body)["_id"];
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => SafeArea(
                          child: WebView(
                        initialUrl:
                            'https://9587a691c7c8.ngrok.io/api/auth/status',
                        onWebViewCreated: (controller) async {
                          await controller.evaluateJavascript(
                              'document.cookie = "token=$token; path=/"');
                          print(token);
                        },
                      ))));
        }
        return;
      }
      // save id to preferences
      var id = jsonDecode(loginResponse.body)["_id"];
      print(id);
      Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => SafeArea(
                      child: WebView(
                    initialUrl: 'https://9587a691c7c8.ngrok.io/api/auth/status',
                    javascriptMode: JavascriptMode.unrestricted,
                    onWebViewCreated: (controller) async {
                      await controller.loadUrl(
                          "https://9587a691c7c8.ngrok.io/api/auth/status",
                          headers: {'token': id});
                      print(id);
                    },
                  ))));
    } catch (e) {
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: Text(widget.title),
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              ElevatedButton(
                  onPressed: () => {printCredentials()},
                  child: Text("show credentials")),
              ElevatedButton(
                  onPressed: () => {onOpenWeb()}, child: Text("Open Web")),
            ],
          ),
        ),
      ),
    );
  }
}
