// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'video.entity.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Video _$VideoFromJson(Map<String, dynamic> json) => Video(
      id: json['id'] as int?,
      videoUrl: json['video_url'] as String?,
      videoTitle: json['video_title'] as String?,
      videoThumbUrl: json['video_thumb_url'] as String?,
      videoDescription: json['video_description'] as String?,
    );

Map<String, dynamic> _$VideoToJson(Video instance) => <String, dynamic>{
      'id': instance.id,
      'video_url': instance.videoUrl,
      'video_title': instance.videoTitle,
      'video_thumb_url': instance.videoThumbUrl,
      'video_description': instance.videoDescription,
    };
