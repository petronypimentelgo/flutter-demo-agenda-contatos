import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:contatos_2/ui/add_contato.dart';
import 'package:contatos_2/ui/edit_contato.dart';
import 'package:flutter/material.dart';

import '../model/contato.dart';
import 'dialog_yes_no.dart';

class HomePage extends StatelessWidget {
  HomePage({super.key});

  final CollectionReference _reference = FirebaseFirestore.instance.collection("contatos");

  //List<Contato> contatos = [
  //  Contato(id: "1", email: "petronypimentel@hotmail.com", name: "Petrony", telefone: "62998168840"),
  //  Contato(id: "2", email: "jaco@hotmail.com", name: "Jaco", telefone: "62998168840")
  //];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Agenda"),
        centerTitle: true,
        backgroundColor: Colors.red,
      ),
      backgroundColor: Colors.white,
      body: FutureBuilder<QuerySnapshot>(
        future: _reference.get(),
        builder: (context, snapshot) {
          if(snapshot.hasError) {
            return Center(
              child: Text("Erro"),
            );
          }

          if(snapshot.hasData) {
            QuerySnapshot querySnapshot = snapshot.data!;
            List<QueryDocumentSnapshot> documents = querySnapshot.docs;
            List<Contato> contatos = documents.map((e) => Contato(id: e['id'], name: e['name'], email: e['email'], telefone: e['telefone'])).toList();
            return createBody(contatos);
          }else {
            //show Loading
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: (){
          Navigator.push(context, MaterialPageRoute(builder: (context) => const AddContato()));
        },
        child: Icon(Icons.add),
        backgroundColor: Colors.red,
      ),
    );
  }

  Widget createBody(contatos) {
    return contatos.isEmpty ? Center(child: Text("Sem informações cadastradas", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),)) :
    ListView.builder(
        itemCount: contatos.length,
        itemBuilder: (context, index) => Card(
          child: ListTile(
            leading: CircleAvatar(
              radius: 25,
              child: Text("${contatos[index].name.substring(0, 1)}"),
            ),
            title: Text(contatos[index].name),
            subtitle: Text(contatos[index].email),
            trailing: SizedBox(
              width: 60,
              child: Row(
                children: [
                  InkWell(
                      child: Icon(Icons.edit),
                      onTap: (){
                        Navigator.push(context, MaterialPageRoute(builder: (context) => EditContato(contato: contatos[index])));
                      }
                  ),
                  InkWell(child: Icon(Icons.delete, color: Colors.red), onTap: () async {
                    bool confirmed = await showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return ConfirmationDialog();
                      },
                    );

                    if(confirmed) {
                      this._reference.doc(contatos[index].id).delete();
                      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=> HomePage()));
                    }
                  })
                ],
              ),
            ),
          ),
        )
    );
  }

  Future<bool> confirmaDelete(context) async {
    bool confirmed = await showDialog(
      context: context,
      builder: (BuildContext context) {
        return ConfirmationDialog();
      },
    );

    return confirmed;
  }
}
