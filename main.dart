import 'dart:developer';

import 'package:bim_aktuel/aktuel.dart';
import 'package:flutter/material.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:html/parser.dart' as parser;

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'bim aktuel',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: anasayfa(),
    );
  }
}

class anasayfa extends StatefulWidget {
  const anasayfa({
    Key? key,
  }) : super(key: key);

  @override
  State<anasayfa> createState() => _anasayfaState();
}

class _anasayfaState extends State<anasayfa> {
  var url =
      Uri.parse('https://www.bim.com.tr/Categories/100/aktuel-urunler.aspx');
  bool isloading = false;
/*
     resim => 'https://www.bim.com.tr' +
          element.children[0].children[0].children[0].children[0].children[0]
              .children[0].attributes['src']
              .toString()
      isim     =>
element.children[0].children[0].children[1].children[0].text
          .toString())
      

      baslik    =>
       element.children[0].children[0].children[1].children[1].text
          .toString())
      teknik ozelik => element.children[0].children[0].children[1].children[2].text
          .toString()

         fiyat  =>element.children[0].children[0].children[1].children[3].children[0]
          .children[0].text
          .toString()
           
 */

  List<Aktuel> urunler = [];
  Future getdata() async {
    setState(() {
      isloading = true;
    });
    var res = await http.get(url);
    final Body = res.body;
    final document = parser.parse(Body);
    var respone = document
        .getElementsByClassName('container content white no-pb')[0]
        .getElementsByClassName(
            'product col-xl-3 col-lg-3 col-md-4 col-sm-6 col-12')
        .forEach((element) {
      setState(() {
        urunler.add(Aktuel(
            resim: element.children[0].children[0].children[0].children[0]
                .children[0].children[0].attributes['src']
                .toString(),
            urunisim: element
                .children[0].children[0].children[1].children[0].text
                .toString(),
            urunozelik: element
                .children[0].children[0].children[1].children[1].text
                .toString(),
            urunTeknikozelik: element
                .children[0].children[0].children[1].children[2].text
                .toString(),
            fiyat: element.children[0].children[0].children[1].children[3]
                .children[0].children[0].text
                .toString()));
      });
    });
    setState(() {
      print(urunler[12].resim.toString());
      print(urunler.length.toString());

      isloading = false;
    });
  }

  @override
  void initState() {
    super.initState();
    getdata();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('bim aktuel')),
      body: isloading
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : SafeArea(
              child: GridView.builder(
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                childAspectRatio: 0.7,
                mainAxisSpacing: 8,
                crossAxisSpacing: 1,
              ),
              itemCount: 7,
              itemBuilder: (context, index) => Card(
                elevation: 6,
                color: Colors.amber,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Flexible(
                      flex: 20,
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(5),

                        child: Image.network(
                            'https://www.bim.com.tr/' + urunler[index].resim),
                        // 'https://www.bim.com.tr/Uploads/aktuel-urunler/867_buyuk_543X467_phone.jpg'
                      ),
                    ),
                    Flexible(
                      flex: 10,
                      child: Text(
                        urunler[index].urunisim,
                        style: _renk(21),
                      ),
                    ),
                    Flexible(
                      flex: 6,
                      child: Text(
                        urunler[index].urunozelik,
                        style: _renk(16),
                      ),
                    ),
                    Flexible(
                      flex: 6,
                      child: Text(
                        urunler[index].urunTeknikozelik,
                        style: _renk(10),
                      ),
                    ),
                    Flexible(
                      flex: 6,
                      child: Text(
                        urunler[index].fiyat,
                        style: _renk(19, renk: Color.fromARGB(255, 44, 78, 45)),
                      ),
                    ),
                  ],
                ),
              ),
            )),
    );
  }
}

TextStyle _renk(double siz, {Color renk = Colors.black}) =>
    TextStyle(color: renk, fontSize: siz);







                             /* Text('kitap i    sim : ${urunler[index].fiyat}',
                              style: TextStyle(
                                fontSize: 20,
                              ),
                            ),
                              
                            Text('kitap yayinevi ${urunler[index].urunozelik}'),
                            Text(
                                'kitap fityat :${urunler[index].urunTeknikozelik} '),
                            Text('kitap yayinevi ${urunler[index].fiyat}'),*/