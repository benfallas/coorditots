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
              print(map);

              phonics.clear();

             map.forEach((v) =>
                 phonics.add(Phonic(v["title"] , v["subtitle"], v['imageUrl'], v['voiceUrl']))
             );

              return GridView.builder(
                physics: NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    mainAxisSpacing: 40,
                    crossAxisSpacing: 24,
                    childAspectRatio: 0.75),
                itemCount: phonics.length,
                padding: EdgeInsets.all(2.0),
                itemBuilder: (BuildContext context, int index) {
                  return     GestureDetector(
                    onTap: (){
                        print("TAPPED");
                    },
                    child: Padding(
                      padding: EdgeInsets.all(5),
                      child: Container(

                        width: 100,
                        height: 150,
                        decoration: BoxDecoration(

                          shape: BoxShape.rectangle,
                          borderRadius: BorderRadius.all(Radius.circular(15.0)),
                          image: DecorationImage(
                            image: NetworkImage(phonics[index].imageUrl!),
                            fit: BoxFit.cover,
                          ),
                        ),
                        child:  Padding(
                          padding: EdgeInsets.all(0),
                          child: Container(

                            decoration: BoxDecoration(
                              shape: BoxShape.rectangle,
                              borderRadius: BorderRadius.all(Radius.circular(15.0)),
                              gradient: new LinearGradient(
                                  colors: [
                                    Colors.black,
                                    const Color(0x19000000),
                                  ],
                                  begin: const FractionalOffset(0.0, 1.0),
                                  end: const FractionalOffset(0.0, 0.0),
                                  stops: [0.0, 1.0],
                                  tileMode: TileMode.clamp),
                            ),
                            child: Padding(
                              padding: EdgeInsets.all(10),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  Text(
                                    phonics[index].title!,
                                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.w500,color: Colors.white),
                                  ),
                                  Text('Rs. ${phonics[index].subtitle }'
                                    ,
                                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.w200,color: Colors.white),
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