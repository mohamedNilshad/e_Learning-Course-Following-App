// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'course.entity.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Course _$CourseFromJson(Map<String, dynamic> json) => Course(
      id: json['id'] as int?,
      educatorId: json['educator_id'] as int?,
      topicId: json['topic_id'] as int?,
      courseName: json['courseName'] as String?,
      courseDescription: json['courseDescription'] as String?,
      coursePrice: (json['coursePrice'] as num?)?.toDouble(),
      courseThumbnail: json['courseThumbnile'] as String?,
      courseViews: json['courseViews'] as int?,
      publishCourse: json['publishCourse'] as int?,
      uploadDate: json['uploadDate'] == null
          ? null
          : DateTime.parse(json['uploadDate'] as String),
      createdAt: json['created_at'] == null
          ? null
          : DateTime.parse(json['created_at'] as String),
    );

Map<String, dynamic> _$CourseToJson(Course instance) => <String, dynamic>{
      'id': instance.id,
      'educator_id': instance.educatorId,
      'topic_id': instance.topicId,
      'courseName': instance.courseName,
      'courseDescription': instance.courseDescription,
      'coursePrice': instance.coursePrice,
      'courseThumbnile': instance.courseThumbnail,
      'courseViews': instance.courseViews,
      'publishCourse': instance.publishCourse,
      'uploadDate': instance.uploadDate?.toIso8601String(),
      'created_at': instance.createdAt?.toIso8601String(),
    };
