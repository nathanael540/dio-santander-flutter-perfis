import 'dart:convert';

class Contato {
  String? id;
  String nome;
  String telefone;
  String foto;

  Contato({
    required this.nome,
    required this.telefone,
    required this.foto,
    this.id,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'nome': nome,
      'telefone': telefone,
      'foto': foto,
      if (id != null) 'objectId': id
    };
  }

  factory Contato.fromMap(Map<String, dynamic> map) {
    return Contato(
      nome: map['nome'] as String,
      telefone: map['telefone'] as String,
      foto: map['foto'] as String,
      id: map['objectId'] as String?,
    );
  }

  String toJson() => json.encode(toMap());

  factory Contato.fromJson(String source) =>
      Contato.fromMap(json.decode(source) as Map<String, dynamic>);
}
