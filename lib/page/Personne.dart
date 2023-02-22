
import 'dart:html';

class Personne{
  int? id;
  String? anarana;
  String? fanampiny;
  String? sexe;
  String? daty;
  String? adiresy;
  String? asa;
  String? phone;
  Blob? sary;

  Personne(int? id, String? anarana, String? fanampiny, String? sexe,
      String? daty, String? adiresy, String? asa, String? phone, Blob? sary){
    this.id = id;
    this.anarana = anarana;
    this.fanampiny = fanampiny;
    this.sexe = sexe;
    this.adiresy = adiresy;
    this.phone = phone;
    this.asa = asa;
    this.daty = daty;
    this.sary = sary;
  }

  Personne.fromJson(dynamic json){
    id = json['id'];
    anarana = json['anarana'];
    fanampiny = json['fanampiny'];
    sexe = json['sexe'];
    daty = json['daty'];
    adiresy = json['adiresy'];
    phone = json['phone'];
    asa = json['asa'];
    sary = json['sary'];
  }


}
