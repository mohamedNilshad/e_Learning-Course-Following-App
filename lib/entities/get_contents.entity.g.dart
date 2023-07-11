// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'get_contents.entity.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

GetContents _$GetContentsFromJson(Map<String, dynamic> json) => GetContents(
      video: (json['video'] as List<dynamic>)
          .map((e) => Video.fromJson(e as Map<String, dynamic>))
          .toList(),
      docs: (json['docs'] as List<dynamic>)
          .map((e) => Doc.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$GetContentsToJson(GetContents instance) =>
    <String, dynamic>{
      'video': instance.video,
      'docs': instance.docs,
    };
