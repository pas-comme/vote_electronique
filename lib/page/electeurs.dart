import 'dart:convert';
import 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import 'Personne.dart';

class Electeurs extends StatefulWidget{
  int? id;
  String? nom_election;
  Electeurs(this.id, this.nom_election,{Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => ElecteurPage(id, nom_election);
}

class ElecteurPage extends State<Electeurs>{
  int? id_election;
  String? ids;
  String? nom_election;

  ElecteurPage(id, this.nom_election){
    id_election = id;
  }

  List<Electeur> electeursLIST = [];
  List<Personne> personneLIST = [];
  Void? newCandidat(){
    return null;
  }
  Future<List<Personne>> getCandidat()async{
    var reponse = await http.get(Uri.parse("http://localhost/API/polling/electeurs.php?id=$id_election"));
    electeursLIST.clear();
    var temp = json.decode(reponse.body);
    for(Map i in temp){
      electeursLIST.add(Electeur.fromJson(i));
    }
    for(Electeur temp in electeursLIST){
      if (ids == "") {
        ids = "$temp.idPRS";
      } else{
        ids = "$ids||id=$temp.idPRS";
      }
    }
    print("candidat : $electeursLIST");
    print("personne : $personneLIST");
    if(ids != null){
      var reponse1 = await http.get(Uri.parse("http://localhost/citizens/specials.php?id=$ids"));
      var prs = json.decode(reponse1.body);
      for(Map i in prs){
        personneLIST.add(Personne.fromJson(i));
      }
    }
    return personneLIST;
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text("LISTE DES ÉLECTEURS pour $nom_election"),
      ),
      body :  FutureBuilder(
          future: getCandidat(),
          builder:  (context, snapshot) {
            if(!snapshot.hasData) {
              return Center(child:
              Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: const [Text("LOADING.......", style: TextStyle(fontSize: 48, fontWeight:FontWeight.bold ),),
                    CircularProgressIndicator()]));
            } else{
              return
                ListView.builder(
                    itemCount: personneLIST.length,
                    itemBuilder: (context, index) {
                      return ListTile(
                        //leading: ,//Text(candidatsLIST[index].nom.toString()),
                          title: Text(personneLIST[index].anarana.toString() + personneLIST[index].fanampiny.toString()),
                          subtitle: Text(personneLIST[index].sexe.toString()),
                          trailing: Text("Profession : ${personneLIST[index].asa}  Adresse : ${personneLIST[index].adiresy} Contact : ${personneLIST[index].phone}",)
                      );
                    });

            }
          }
      ),
      bottomSheet: Center(
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(
            padding: const EdgeInsets.fromLTRB(50, 15, 50, 15),
            elevation: 5,
          ),
          onPressed: newCandidat,
          child: const Text("ajouter un nouveau candidat"),
        ),
      ),

    );

  }

}
class Electeur{
  int? idPRS;
  String? id_election;

  Electeur({int? idPRS, String? id_election, Double? vato}){
    this.idPRS = idPRS;
    this.id_election = id_election;
  }
  Electeur.fromJson(dynamic json){
    idPRS = json['idPRS'];
    id_election = json['id_election'];
  }
}
