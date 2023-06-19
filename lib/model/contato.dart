import 'dart:convert';

Contato contatoFromJson(String str) => Contato.fromJson(json.decode(str));

String contatoToJson(Contato data) => json.encode(data.toJson());

class Contato {
  String? id;
  final String name;
  final String email;
  final String telefone;

  Contato({
    this.id,
    required this.name,
    required this.email,
    required this.telefone,
  });

  factory Contato.fromJson(Map<String, dynamic> json) => Contato(
    id: json["id"],
    name: json["name"],
    email: json["email"],
    telefone: json["telefone"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "name": name,
    "email": email,
    "telefone": telefone,
  };
}
