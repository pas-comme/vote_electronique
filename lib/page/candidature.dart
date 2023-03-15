
import 'dart:typed_data';

import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:http/http.dart' as http;
import '../Repository/Personne.dart';
import '../Repository/Repository.dart';
import '../bloc/candidat_bloc.dart';

class Candidature extends StatefulWidget{
  int? id;
  String? nom_election;
  bool voting;

  Candidature(this.id, this.nom_election, this.voting,{Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => CandidaturePage(id, nom_election, voting);
}

class CandidaturePage extends State<Candidature>{
  int? id;
  String? ids;
  String? nom_election;
  bool voting;
  String retour = "";

  CandidaturePage(this.id, this.nom_election, this.voting);
  @override
  void setState(VoidCallback fn) {
    // TODO: implement setState
    super.setState(fn);
  }
  void voter(String idCandidat) async{
    await FlutterBarcodeScanner.scanBarcode('#ff6666', 'Cancel', true, ScanMode.QR).then((value) => retour = value);
    if(retour!=""){
      //Uri url = Uri.parse("http://localhost/API/polling/voter.php");
      Uri url = Uri.parse("http://10.42.0.1/API/polling/voter.php");
      final Map<String, dynamic> data = <String, dynamic>{};
      data['idPRS'] = retour;
      data['id_candidat'] = idCandidat.toString();
      data['id_election'] = id.toString();
      print("candidat : $idCandidat");
      var reponse = await http.post(url, body: data);
      if(reponse.statusCode == 200){
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(reponse.body,
            textAlign: TextAlign.center), shape: const BeveledRectangleBorder(borderRadius:BorderRadius.all(Radius.circular(3)))));
      }
      else {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("statuscode = ${reponse.statusCode} and response = ${reponse.body}",
            textAlign: TextAlign.center), shape: const BeveledRectangleBorder(borderRadius:BorderRadius.all(Radius.circular(3)))));
      }

    }
  }

  @override
  Widget build(BuildContext context) {
    final avatarSize = MediaQuery.of(context).size.width * 0.2;
    return MultiBlocProvider(
        providers: [
          BlocProvider<CandidatBloc>(create:(BuildContext context) => CandidatBloc(CandidatRepository(id)),)],
        child: Scaffold(
          appBar: AppBar(
            centerTitle: true,
            title: Text("Liste des candidtas \npour $nom_election", textAlign: TextAlign.center),
          ),
          body : BlocProvider(
            create: (context) => CandidatBloc(CandidatRepository(id))..add(GetALlCandidat(id)),
            child: BlocBuilder<CandidatBloc, CandidatState>(
                builder: (context, state) {
                  if(state is CandidatInitial){
                    return const Center( child: CircularProgressIndicator());
                  }
                  else if(state is CandidatVideState){
                    return const Center(child: Text("aucun candidat inscrit pour le moment"));
                  }
                  else if(state is CandidatLoadedState){
                    List<Personne> personneLIST = state.candidats;
                    return  ListView.builder(
                        itemCount: personneLIST.length,
                        itemBuilder: (context, index) {
                          return Padding(
                            padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 7),
                            child: Card(
                              semanticContainer: false,
                              margin: const EdgeInsets.symmetric(vertical: 0, horizontal: 0),
                              color: Theme.of(context).primaryColor,
                              child: ListTile(
                                  leading:
                                  Row(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    mainAxisSize: MainAxisSize.min,
                                    children : [ CircleAvatar(
                                        //backgroundImage : MemoryImage( Uint8List.fromList(Personne.base64Decoder(personneLIST[index].image))),
                                        foregroundImage: MemoryImage( Uint8List.fromList(Personne.base64Decoder(personneLIST[index].image))),
                                        radius: avatarSize / 2 ,
                                    ),
                                  ],),
                                  contentPadding: const EdgeInsets.symmetric(vertical: 0, horizontal: 0),
                                  horizontalTitleGap: -avatarSize / 14,
                                  title: Text("${personneLIST[index].anarana} ${personneLIST[index].fanampiny} "),
                                  subtitle: Text("AGE : ${personneLIST[index].daty}       SEXE : ${personneLIST[index].sexe.toString()} \n"
                                      "PROFESSION : ${personneLIST[index].asa}      ADRESSE : ${personneLIST[index].adiresy}      CONTACT : ${personneLIST[index].phone}",),

                                trailing: voting ? ElevatedButton(
                                  style: ElevatedButton. styleFrom(
                                    primary: Colors.green,
                                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20),),
                                    elevation: 5,

                                  ),
                                  onPressed: (){
                                    voter(personneLIST[index].id.toString());},
                                  child: const Text("Voter"),
                                ) : null,
                              ),
                            ),
                          );
                        });
                  }
                  else if(state is CandidatErrorState){
                    return  Center(child: Text(state.erreur),);
                  }
                  else{
                    return const Center(child: Text("aucun candidat inscrit pour le moment"),);
                  }
                }

            ),),
        ));
  }
}


