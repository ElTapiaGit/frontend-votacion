import 'package:json_annotation/json_annotation.dart';

part 'votosUninominal_model.g.dart';

@JsonSerializable()
class VotoUninominalRequest {
  final String mesa; // ID de la mesa
  final Map<String, int> votos;
  final int votosValidos;
  final int votosBlancos;
  final int votosNulos;

  VotoUninominalRequest({
    required this.mesa,
    required this.votos,
    required this.votosValidos,
    required this.votosBlancos,
    required this.votosNulos,
  });

  factory VotoUninominalRequest.fromJson(Map<String, dynamic> json) =>
      _$VotoUninominalRequestFromJson(json);

  Map<String, dynamic> toJson() => _$VotoUninominalRequestToJson(this);
}

@JsonSerializable()
class VotoUninominalResponse {
  @JsonKey(name: '_id')
  final String id;
  final String mesa;
  final Map<String, int> votos;
  final int votosValidos;
  final int votosBlancos;
  final int votosNulos;
  final bool estado;

  VotoUninominalResponse({
    required this.id,
    required this.mesa,
    required this.votos,
    required this.votosValidos,
    required this.votosBlancos,
    required this.votosNulos,
    required this.estado,
  });

  factory VotoUninominalResponse.fromJson(Map<String, dynamic> json) =>
      _$VotoUninominalResponseFromJson(json);

  Map<String, dynamic> toJson() => _$VotoUninominalResponseToJson(this);
}
