// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'acta_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ActaModel _$ActaModelFromJson(Map<String, dynamic> json) => ActaModel(
      id: json['_id'] as String,
      mesa: json['mesa'],
      foto: json['foto'] as String,
      observado: json['observado'] as bool,
      createdAt: DateTime.parse(json['createdAt'] as String),
      updatedAt: DateTime.parse(json['updatedAt'] as String),
    );

Map<String, dynamic> _$ActaModelToJson(ActaModel instance) => <String, dynamic>{
      '_id': instance.id,
      'mesa': instance.mesa,
      'foto': instance.foto,
      'observado': instance.observado,
      'createdAt': instance.createdAt.toIso8601String(),
      'updatedAt': instance.updatedAt.toIso8601String(),
    };

ActaRequest _$ActaRequestFromJson(Map<String, dynamic> json) => ActaRequest(
      mesaId: json['mesaId'] as String,
      foto: json['foto'] as String,
      observado: json['observado'] as bool,
    );

Map<String, dynamic> _$ActaRequestToJson(ActaRequest instance) =>
    <String, dynamic>{
      'mesaId': instance.mesaId,
      'foto': instance.foto,
      'observado': instance.observado,
    };
