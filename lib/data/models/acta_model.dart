import 'package:json_annotation/json_annotation.dart';

part 'acta_model.g.dart';

@JsonSerializable()
class ActaModel {
  @JsonKey(name: '_id')
  final String id;

  final dynamic mesa; // Puede ser String o un objeto MesaModel (lo dejamos dynamic por flexibilidad)
  final String foto;
  final bool observado;
  final DateTime createdAt;
  final DateTime updatedAt;

  ActaModel({
    required this.id,
    required this.mesa,
    required this.foto,
    required this.observado,
    required this.createdAt,
    required this.updatedAt,
  });

  factory ActaModel.fromJson(Map<String, dynamic> json) =>
      _$ActaModelFromJson(json);

  Map<String, dynamic> toJson() => _$ActaModelToJson(this);
}

@JsonSerializable()
class ActaRequest {
  final String mesaId;
  final String foto;
  final bool observado;

  ActaRequest({
    required this.mesaId,
    required this.foto,
    required this.observado,
  });

  factory ActaRequest.fromJson(Map<String, dynamic> json) =>
      _$ActaRequestFromJson(json);

  Map<String, dynamic> toJson() => _$ActaRequestToJson(this);
}
