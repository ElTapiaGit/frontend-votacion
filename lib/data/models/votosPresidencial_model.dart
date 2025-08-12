import 'package:json_annotation/json_annotation.dart';

part 'votosPresidencial_model.g.dart';

@JsonSerializable()
class VotoPresidencialRequest {
  final String mesa; // ID de la mesa
  final Map<String, int> votos;
  final int votosValidos;
  final int votosBlancos;
  final int votosNulos;

  VotoPresidencialRequest({
    required this.mesa,
    required this.votos,
    required this.votosValidos,
    required this.votosBlancos,
    required this.votosNulos,
  });

  factory VotoPresidencialRequest.fromJson(Map<String, dynamic> json) =>
      _$VotoPresidencialRequestFromJson(json);
  Map<String, dynamic> toJson() => _$VotoPresidencialRequestToJson(this);
}

@JsonSerializable()
class VotoPresidencialResponse {
  @JsonKey(name: '_id')
  final String id;
  final String mesa;
  final Map<String, int> votos;
  final int votosValidos;
  final int votosBlancos;
  final int votosNulos;
  final bool estado;

  VotoPresidencialResponse({
    required this.id,
    required this.mesa,
    required this.votos,
    required this.votosValidos,
    required this.votosBlancos,
    required this.votosNulos,
    required this.estado,
  });

  factory VotoPresidencialResponse.fromJson(Map<String, dynamic> json) =>
      _$VotoPresidencialResponseFromJson(json);
  Map<String, dynamic> toJson() => _$VotoPresidencialResponseToJson(this);
}
