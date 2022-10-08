import 'dart:convert';
import 'dart:ffi';

import 'package:coorditots/Phonic.dart';
import 'package:firebase_database/ui/firebase_animated_list.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/rendering.dart';
import 'firebase_options.dart';
import 'package:firebase_database/firebase_database.dart';

FirebaseDatabase database = FirebaseDatabase.instance;
DatabaseReference ref = FirebaseDatabase.instance.ref();


void main() async {

  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Coorditots',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(title: 'Coorditots'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: const <Widget>[
            PhonicsGrid(),
          ],
        ),
      ),
    );
  }
}




class PhonicsGrid extends StatefulWidget {

  const PhonicsGrid({super.key});

  @override
  State<PhonicsGrid> createState() => PhonicsGridState();
}


class PhonicsGridState extends State<PhonicsGrid> {

  List<Phonic> phonics = [];

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: FirebaseDatabase.instance
      .ref()
      .child("1erVDFdI8r89ZsEaLmJ5hE_MY9ho7d6v6trH3HoD9jEE/Default Phonics")
      .onValue,
      builder: (context, snapshot) {
            if (snapshot.hasData) {
              List<dynamic> map = snapshot.data!.snapshot.value as List<dynamic>;

              phonics.clear();

             map.forEach((v) =>
                 phonics.add(Phonic(v["title"] , v["subtitle"], v['imageUrl'], v['voiceUrl']))
             );

              return GridView.builder(
                physics: NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 4,
                    mainAxisSpacing: 5,
                    crossAxisSpacing: 5,
                    childAspectRatio: 1),
                itemCount: phonics.length,
                padding: EdgeInsets.all(2.0),
                itemBuilder: (BuildContext context, int index) {
                  return     GestureDetector(
                    onTap: (){
                      print("TAPPED");
                        showModalBottomSheet(context: context, builder: (context) {
                          return ListView(
                            children: [
                             
                              Container(
                                child: 
                                Padding(
                                  padding: EdgeInsets.all(20),
                                  child: Container(
                                    decoration: BoxDecoration(
                                      image: DecorationImage(
                                        image: NetworkImage(phonics[index].imageUrl!),
                                        fit: BoxFit.contain),
                                    ),
                                  ),
                                ),
                                height: 300,
                              ),
                              Center(
                                
                                child: Padding(
                                  padding: EdgeInsets.all(20),
                                  child: Text(
                                    phonics[index].subtitle!,
                                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.w500,color: Colors.black),
                                  ),

                                )
                                 
                              )
                              
                            ],
                          );
                        });
                    },
                    child: Padding(
                      padding: EdgeInsets.all(5),
                      child: Container(
                        decoration: const BoxDecoration(
                          shape: BoxShape.rectangle,
                          borderRadius: BorderRadius.all(Radius.circular(15.0)),       
                        ),
                        child:  Padding(
                          padding: EdgeInsets.all(0),
                          child: Container(

                            decoration: BoxDecoration(
                              shape: BoxShape.rectangle,
                              borderRadius: BorderRadius.all(Radius.circular(15.0)),
                              color: Colors.lightBlue,
                            ),
                            child: Padding(
                              padding: EdgeInsets.all(10),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    phonics[index].title!,
                                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.w500,color: Colors.black),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ), /* add child content here */
                      ),
                    ),
                  );
                });
          } 
          return CircularProgressIndicator();
      });

  }
}