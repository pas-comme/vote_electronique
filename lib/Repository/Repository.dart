import 'dart:convert';
import 'package:http/http.dart' as http;
import 'Personne.dart';

class CandidatRepository{
  int? id_election;
  CandidatRepository(this.id_election);
  Future<List<Personne>>  getCandidat()async{

    String? ids = "";
    List<Candidat> candidatsLIST = [];

    var reponse = await http.get(Uri.parse("http://10.42.0.1/API/polling/candidats.php?id=$id_election"));
    //var reponse = await http.get(Uri.parse("http://localhost/API/polling/candidats.php?id=$id_election"));

    var temp = json.decode(reponse.body);
    for(Map i in temp){
      candidatsLIST.add(Candidat.fromJson(i));
    }

    for(Candidat temp in candidatsLIST){
      if (ids == "") {
        ids = "${temp.idPRS}";
      } else{
        ids = "$ids||id=${temp.idPRS}";
      }
    }

    var response1 = await http.get(Uri.parse("http://10.42.0.1/API/citizens/specials.php?id=$ids"));
    //var response1 = await http.get(Uri.parse("http://localhost/API/citizens/specials.php?id=$ids"));

    List prs = json.decode(response1.body);
    if(prs.isEmpty){
      return [];
    }
    return prs.map((e) => Personne.fromJson(e)).toList();
  }

}

class Candidat{
  int idPRS = 0;
  int? id_election;
  int vato = 0;
  Candidat(this.idPRS, this.id_election, this.vato);
  Candidat.fromJson(dynamic json){
    idPRS = json['idPRS'];
    id_election = json['id_election'];
    vato = json['vato'];
  }
}

