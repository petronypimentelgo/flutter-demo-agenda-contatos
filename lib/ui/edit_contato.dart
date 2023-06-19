import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:contatos_2/model/contato.dart';
import 'package:contatos_2/ui/home_page.dart';
import 'package:flutter/material.dart';

class EditContato extends StatelessWidget {
  final Contato contato;

  final TextEditingController nomeController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController telefoneController = TextEditingController();
  final FocusNode focusNode = FocusNode();

  EditContato({super.key, required this.contato});

  @override
  Widget build(BuildContext context) {
    nomeController.text = '${contato.name}';
    emailController.text = '${contato.email}';
    telefoneController.text = '${contato.telefone}';

    return Scaffold(
      appBar: AppBar(
        title: const Text("Novo Contato"),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(height: 20),
            getTextField(
                hintText: "Nome",
                textInputType: TextInputType.text,
                controller: nomeController,
                focusNode: focusNode),
            getTextField(
                hintText: "E-mail",
                textInputType: TextInputType.emailAddress,
                controller: emailController),
            getTextField(
                hintText: "Telefone",
                textInputType: TextInputType.phone,
                controller: telefoneController),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton(
                  onPressed: () {
                    Contato contato = Contato(
                        id: this.contato.id,
                        name: nomeController.text,
                        email: emailController.text,
                        telefone: telefoneController.text);
                    updateAndNavigatorToHomePage(contato, context);
                  },
                  child: Text("Alterar"),
                  style: ElevatedButton.styleFrom(backgroundColor: Colors.blue),
                ),
                ElevatedButton(
                  onPressed: () => {
                    nomeController.text = '',
                    emailController.text = '',
                    telefoneController.text = '',
                    focusNode.requestFocus()
                  },
                  child: Text("Limpar"),
                  style:
                      ElevatedButton.styleFrom(backgroundColor: Colors.amber),
                )
              ],
            )
          ],
        ),
      ),
    );
  }

  Widget getTextField(
      {required String hintText,
      TextInputType textInputType = TextInputType.name,
      required TextEditingController controller,
      FocusNode? focusNode}) {
    return Padding(
      padding: EdgeInsets.all(10.0),
      child: TextField(
        focusNode: focusNode,
        controller: controller,
        keyboardType: textInputType,
        decoration: InputDecoration(
          hintText: 'Enter $hintText',
          labelText: hintText,
          border: const OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(5)),
          ),
        ),
      ),
    );
  }

  void updateAndNavigatorToHomePage(Contato contato, BuildContext context) {
    final collectionReference =
        FirebaseFirestore.instance.collection("contatos");
    collectionReference
        .doc(contato.id)
        .update(contato.toJson())
        .whenComplete(() {
      Navigator.pushAndRemoveUntil(
          context, MaterialPageRoute(builder: (context) => HomePage()),
          (route) => false
      );
    });
  }
}
