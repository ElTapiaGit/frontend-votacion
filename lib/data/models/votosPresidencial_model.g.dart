// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'votosPresidencial_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

VotoPresidencialRequest _$VotoPresidencialRequestFromJson(
        Map<String, dynamic> json) =>
    VotoPresidencialRequest(
      mesa: json['mesa'] as String,
      votos: Map<String, int>.from(json['votos'] as Map),
      votosValidos: (json['votosValidos'] as num).toInt(),
      votosBlancos: (json['votosBlancos'] as num).toInt(),
      votosNulos: (json['votosNulos'] as num).toInt(),
    );

Map<String, dynamic> _$VotoPresidencialRequestToJson(
        VotoPresidencialRequest instance) =>
    <String, dynamic>{
      'mesa': instance.mesa,
      'votos': instance.votos,
      'votosValidos': instance.votosValidos,
      'votosBlancos': instance.votosBlancos,
      'votosNulos': instance.votosNulos,
    };

VotoPresidencialResponse _$VotoPresidencialResponseFromJson(
        Map<String, dynamic> json) =>
    VotoPresidencialResponse(
      id: json['_id'] as String,
      mesa: json['mesa'] as String,
      votos: Map<String, int>.from(json['votos'] as Map),
      votosValidos: (json['votosValidos'] as num).toInt(),
      votosBlancos: (json['votosBlancos'] as num).toInt(),
      votosNulos: (json['votosNulos'] as num).toInt(),
      estado: json['estado'] as bool,
    );

Map<String, dynamic> _$VotoPresidencialResponseToJson(
        VotoPresidencialResponse instance) =>
    <String, dynamic>{
      '_id': instance.id,
      'mesa': instance.mesa,
      'votos': instance.votos,
      'votosValidos': instance.votosValidos,
      'votosBlancos': instance.votosBlancos,
      'votosNulos': instance.votosNulos,
      'estado': instance.estado,
    };
