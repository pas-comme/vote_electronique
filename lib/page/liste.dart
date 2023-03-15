import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'candidature.dart';

class Liste extends StatefulWidget{
  const Liste({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _ListeScreen();
}
class _ListeScreen extends State<Liste>{
  List<Element> liste = [];


  Future<List<Element>> getLIST()async{
    //var reponse = await http.get(Uri.parse("http://localhost/API/polling/pollings.php?voting=1" ));
    var reponse = await http.get(Uri.parse("http://10.42.0.1/API/polling/pollings.php?voting=1" ));
    liste.clear();
    var temp = json.decode(reponse.body);
    for(Map i in temp){
      liste.add(Element.fromJson(i));
    }
    return liste;
  }
  @override

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text("Liste des éléctions disponibles pour l'instant"),
      ),
      body :  // liste.isEmpty ? const Center(child: Text("aucune éléction active pour le moment"),) :
      FutureBuilder(
        future: getLIST(),
        builder:  (context, snapshot) {
          if(!snapshot.hasData) {
            return Center(child:
            Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: const [Text("LOADING.......", style: TextStyle(fontSize: 48, fontWeight:FontWeight.bold ),),
                  CircularProgressIndicator()]));
          } else{
            return ListView.builder(
            itemCount: liste.length,
            itemBuilder: (context, index) {
              return Card(
                margin: const EdgeInsets.symmetric(vertical: 12, horizontal: 14),
                color: Theme.of(context).primaryColor,
                child: ListTile(
                  onTap: (){
                    var route = MaterialPageRoute(builder: (BuildContext context)=>Candidature(liste[index].id, liste[index].nom.toString()));
                    Navigator.of(context).push(route);

                  },
                  minVerticalPadding: 0,
                  contentPadding: const EdgeInsets.symmetric(vertical:0, horizontal: 7),
                  leading: Text(liste[index].nom.toString()),
                  title: Text(liste[index].domaine.toString()),
                  subtitle: Text(liste[index].description.toString()),
                ),
              );
            }
          );
        }
      }),
    );
  }
}
class Element {
  int? id;
  String? nom;
  String? domaine;
  String? description;
  Element({this.id,  this.domaine,  this.nom, this.description});

  Element.fromJson(dynamic json){
    id =  json['id'];
    nom = json['nom'];
    domaine = json['domaine'];
    description = json['description'];
  }
}