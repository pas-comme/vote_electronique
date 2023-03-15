import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:vote_electronique/page/resultat.dart';
import 'candidature.dart';
import 'electeurs.dart';

class Liste extends StatefulWidget{
  const Liste({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _ListeScreen();

  setState(){

  }
}
class _ListeScreen extends State<Liste>{
  List<Element> liste = [];
  bool active = false;
  final int _currentIndex0 = 0;
  final int _currentIndex1 = 0;

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
  void setState(VoidCallback fn) {
    // TODO: implement setState
    super.setState(fn);
  }
  void electionOptions(int? id, String titre,) async{
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(titre, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 25), textAlign: TextAlign.center,),
          //backgroundColor: Colors.white,
          contentPadding: EdgeInsets.zero,
          insetPadding: EdgeInsets.zero,

          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20),),
          content: Container(

            padding: const EdgeInsets.all(15),
            //decoration: const BoxDecoration(image: DecorationImage(image: AssetImage('assets/images/15.png'), fit: BoxFit.fill,),),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                BottomNavigationBar(
                  onTap: (index) async{
                    if(index == 0){
                      var route = MaterialPageRoute(builder: (BuildContext context)=>Electeurs(id, titre));
                      Navigator.of(context).push(route);
                    }
                    else if(index == 1){
                      var route = MaterialPageRoute(builder: (BuildContext context)=>Candidature(id, titre, true));
                      Navigator.of(context).push(route);
                    }
                  },
                  currentIndex: _currentIndex0,
                  elevation: 0.0,
                  //backgroundColor: Colors.transparent,
                  unselectedItemColor: Colors.black,
                  selectedItemColor: Colors.black,
                  items: const [
                    BottomNavigationBarItem(
                        icon: Icon(Icons.not_started), label:"S'incrire à cette élection" ),
                    BottomNavigationBarItem(
                        icon: Icon(Icons.notifications_active), label:"Voter à cette élection" ),
                  ],),
                BottomNavigationBar(
                  //backgroundColor: Colors.transparent,
                  onTap: (index){
                    if(index == 0){
                      var route = MaterialPageRoute(builder: (BuildContext context)=>Candidature(id, titre, false));
                      Navigator.of(context).push(route);
                    }
                    else if(index == 1){
                      var route = MaterialPageRoute(builder: (BuildContext context)=>Resultat(id, titre));
                      Navigator.of(context).push(route);
                    }
                  },
                  currentIndex: _currentIndex1,
                  elevation: 0.0,
                  unselectedItemColor: Colors.black,
                  selectedItemColor: Colors.black,
                  items: const [
                    BottomNavigationBarItem(
                        icon: Icon(Icons.accessibility_new), label:"Liste des candidats de cette élection" ),
                    BottomNavigationBarItem(
                        icon: Icon(Icons.leaderboard), label:"Voir résultat de cette élection" ),
                  ],),
              ],
            ),
          ),
        );
      },
    );
  }
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
                    electionOptions(liste[index].id, liste[index].nom.toString(), );
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