// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'doc.entity.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Doc _$DocFromJson(Map<String, dynamic> json) => Doc(
      id: json['id'] as int?,
      courseId: json['course_id'] as int?,
      videoId: json['video_id'] as int?,
      docUrl: json['doc_url'] as String?,
    );

Map<String, dynamic> _$DocToJson(Doc instance) => <String, dynamic>{
      'id': instance.id,
      'course_id': instance.courseId,
      'video_id': instance.videoId,
      'doc_url': instance.docUrl,
    };
