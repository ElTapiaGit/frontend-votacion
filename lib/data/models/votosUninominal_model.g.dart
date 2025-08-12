// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'votosUninominal_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

VotoUninominalRequest _$VotoUninominalRequestFromJson(
        Map<String, dynamic> json) =>
    VotoUninominalRequest(
      mesa: json['mesa'] as String,
      votos: Map<String, int>.from(json['votos'] as Map),
      votosValidos: (json['votosValidos'] as num).toInt(),
      votosBlancos: (json['votosBlancos'] as num).toInt(),
      votosNulos: (json['votosNulos'] as num).toInt(),
    );

Map<String, dynamic> _$VotoUninominalRequestToJson(
        VotoUninominalRequest instance) =>
    <String, dynamic>{
      'mesa': instance.mesa,
      'votos': instance.votos,
      'votosValidos': instance.votosValidos,
      'votosBlancos': instance.votosBlancos,
      'votosNulos': instance.votosNulos,
    };

VotoUninominalResponse _$VotoUninominalResponseFromJson(
        Map<String, dynamic> json) =>
    VotoUninominalResponse(
      id: json['_id'] as String,
      mesa: json['mesa'] as String,
      votos: Map<String, int>.from(json['votos'] as Map),
      votosValidos: (json['votosValidos'] as num).toInt(),
      votosBlancos: (json['votosBlancos'] as num).toInt(),
      votosNulos: (json['votosNulos'] as num).toInt(),
      estado: json['estado'] as bool,
    );

Map<String, dynamic> _$VotoUninominalResponseToJson(
        VotoUninominalResponse instance) =>
    <String, dynamic>{
      '_id': instance.id,
      'mesa': instance.mesa,
      'votos': instance.votos,
      'votosValidos': instance.votosValidos,
      'votosBlancos': instance.votosBlancos,
      'votosNulos': instance.votosNulos,
      'estado': instance.estado,
    };
