import 'package:flutter/material.dart';
import 'package:qrreaderapp/src/pages/home_page.dart';
import './src/pages/mapa_page.dart';
 
void main() => runApp(MyApp());
 
class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'QRReader',
      initialRoute: 'home',
      debugShowCheckedModeBanner: false,
      routes: {
        'home' : (BuildContext context)=>HomePage(),
        'mapa' : (BuildContext context)=>MapaPage(),
      },
      theme: ThemeData(
        primaryColor: Colors.deepPurple
      ),
    );
  }
}