import 'package:json_annotation/json_annotation.dart';

part 'mesa_model.g.dart';

@JsonSerializable()
class MesaModel {
  @JsonKey(name: '_id')
  final String id;

  final int codigoMesa;
  final String numMesa;
  final int? numeroMesa;

  final UbicacionSimple? pais;
  final UbicacionSimple? departamento;
  final UbicacionSimple? provincia;
  final UbicacionSimple? circunscripcion;
  final UbicacionSimple? municipio;
  final UbicacionSimple? localidad;
  final UbicacionSimple? distrito;
  final UbicacionSimple? zona;
  final UbicacionSimple? recinto;

  MesaModel({
    required this.id,
    required this.codigoMesa,
    required this.numMesa,
    this.numeroMesa,
    this.pais,
    this.departamento,
    this.provincia,
    this.circunscripcion,
    this.municipio,
    this.localidad,
    this.distrito,
    this.zona,
    this.recinto,
  });

  factory MesaModel.fromJson(Map<String, dynamic> json) => _$MesaModelFromJson(json);
  Map<String, dynamic> toJson() => _$MesaModelToJson(this);
}

@JsonSerializable()
class UbicacionSimple {
  final int id;
  final String nombre;

  UbicacionSimple({
    required this.id,
    required this.nombre,
  });

  factory UbicacionSimple.fromJson(Map<String, dynamic> json) => _$UbicacionSimpleFromJson(json);
  Map<String, dynamic> toJson() => _$UbicacionSimpleToJson(this);
}
