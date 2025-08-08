// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'mesa_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

MesaModel _$MesaModelFromJson(Map<String, dynamic> json) => MesaModel(
      id: json['_id'] as String,
      codigoMesa: (json['codigoMesa'] as num).toInt(),
      numMesa: json['numMesa'] as String,
      numeroMesa: (json['numeroMesa'] as num?)?.toInt(),
      pais: json['pais'] == null
          ? null
          : UbicacionSimple.fromJson(json['pais'] as Map<String, dynamic>),
      departamento: json['departamento'] == null
          ? null
          : UbicacionSimple.fromJson(
              json['departamento'] as Map<String, dynamic>),
      provincia: json['provincia'] == null
          ? null
          : UbicacionSimple.fromJson(json['provincia'] as Map<String, dynamic>),
      circunscripcion: json['circunscripcion'] == null
          ? null
          : UbicacionSimple.fromJson(
              json['circunscripcion'] as Map<String, dynamic>),
      municipio: json['municipio'] == null
          ? null
          : UbicacionSimple.fromJson(json['municipio'] as Map<String, dynamic>),
      localidad: json['localidad'] == null
          ? null
          : UbicacionSimple.fromJson(json['localidad'] as Map<String, dynamic>),
      distrito: json['distrito'] == null
          ? null
          : UbicacionSimple.fromJson(json['distrito'] as Map<String, dynamic>),
      zona: json['zona'] == null
          ? null
          : UbicacionSimple.fromJson(json['zona'] as Map<String, dynamic>),
      recinto: json['recinto'] == null
          ? null
          : UbicacionSimple.fromJson(json['recinto'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$MesaModelToJson(MesaModel instance) => <String, dynamic>{
      '_id': instance.id,
      'codigoMesa': instance.codigoMesa,
      'numMesa': instance.numMesa,
      'numeroMesa': instance.numeroMesa,
      'pais': instance.pais,
      'departamento': instance.departamento,
      'provincia': instance.provincia,
      'circunscripcion': instance.circunscripcion,
      'municipio': instance.municipio,
      'localidad': instance.localidad,
      'distrito': instance.distrito,
      'zona': instance.zona,
      'recinto': instance.recinto,
    };

UbicacionSimple _$UbicacionSimpleFromJson(Map<String, dynamic> json) =>
    UbicacionSimple(
      id: (json['id'] as num).toInt(),
      nombre: json['nombre'] as String,
    );

Map<String, dynamic> _$UbicacionSimpleToJson(UbicacionSimple instance) =>
    <String, dynamic>{
      'id': instance.id,
      'nombre': instance.nombre,
    };
