import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'screen1.dart';


class Info {
  final String userId;
  final int time;
  final String email;

  const Info({
    required this.userId,
    required this.time,
    required this.email,
  });

  factory Info.fromJson(Map<String, dynamic> json) {
    return Info(
      userId: json['userId'],
      time: json['time'],
      email: json['email'],
    );
  }
}

Future<Info> fetchInfo(String token) async {
  final response = await http
      .get(Uri.parse('http://10.0.2.2:8080/v1/info'), headers: {"Authorization": token});

  if (response.statusCode == 200) {
    // If the server did return a 200 OK response,
    // then parse the JSON.
    return Info.fromJson(jsonDecode(response.body));
  } else {
    // If the server did not return a 200 OK response,
    // then throw an exception.
    throw Exception('Failed to load info');
  }
}


void main() async {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

    @override
  State<MyApp> createState() => _MyAppState();
}


class _MyAppState extends State<MyApp> {
  bool isProgressing = false;
  bool isLoggedIn = false;
  String token = '';
  // final FlutterSecureStorage _secureStorage = const FlutterSecureStorage();

  @override
  void initState() {
    initAuth();
    super.initState();
  }

  initAuth() async {
    setLoadingState();
    setUnauthenticatedState();
  }
    setLoadingState() {
    setState(() {
      isProgressing = true;
    });
  }

  setAuthenticatedState(String newToken) {
    setState(() {
      token = newToken;
      isProgressing = false;
      isLoggedIn = true;
    });
  }

  setUnauthenticatedState() {
    setState(() {
      isProgressing = false;
      isLoggedIn = false;
    });
  }

  // @override
  // Widget build(BuildContext context) {
  //   return MaterialApp(
  //     debugShowCheckedModeBanner: false,
  //     title: 'Flutter Auth',
  //     theme: ThemeData(
  //       colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
  //       useMaterial3: true,
  //     ),
  //     home: LoginScreen(setAuth: setAuthenticatedState,),
  //   );
  // }

    @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'SocialAuthApp',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: SafeArea(
        child: Builder(
          builder: (context) {
            if (isProgressing) {
              return const CircularProgressIndicator();
            } else if (isLoggedIn) {
              return Scaffold(
                body: FutureBuilder<Info>(
                  future: fetchInfo(token),
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      return Column(children: [
                        Text("You are logged in!"),
                        Text("${snapshot.data!.userId}"),
                        Text(snapshot.data!.email),
                        Text("${snapshot.data!.time}"),
                      ]);
                    } else if (snapshot.hasError) {
                      return Text('${snapshot.error}');
                    }

              // By default, show a loading spinner.
                return const CircularProgressIndicator();
                }),);
              // Text('you are logged in!');
              // return MainScreen(
              //   setUnauthenticatedState: setUnauthenticatedState,
              //   secureStorage: _secureStorage,
              // );
            } else {
              return LoginScreen(
                setAuth: setAuthenticatedState,
              );
            }
          },
        ),
      ),
    );
  }
}