import 'package:equatable/equatable.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:course_mate/entities/category.entity.dart';

part 'course.entity.g.dart';

@JsonSerializable(fieldRename: FieldRename.none)
class Course extends Equatable {
  final int? id;
  @JsonKey(name: 'educator_id')
  final int? educatorId;
  @JsonKey(name: 'topic_id')
  final int? topicId;
  final String? courseName;
  final String? courseDescription;
  final double? coursePrice;
  @JsonKey(name: 'courseThumbnile')
  final String? courseThumbnail;
  final int? courseViews;
  final int? publishCourse;
  final DateTime? uploadDate;
  @JsonKey(name: 'created_at')
  final DateTime? createdAt;

  const Course({
    required this.id,
    required this.educatorId,
    required this.topicId,
    required this.courseName,
    required this.courseDescription,
    required this.coursePrice,
    required this.courseThumbnail,
    required this.courseViews,
    required this.publishCourse,
    required this.uploadDate,
    required this.createdAt,
  });

  factory Course.fromJson(Map<String, dynamic> json) => _$CourseFromJson(json);

  Map<String, dynamic> toJson() => _$CourseToJson(this);

  @override
  List<Object?> get props => [
        id,
        educatorId,
        topicId,
        courseName,
        courseDescription,
        coursePrice,
        courseThumbnail,
        courseViews,
        publishCourse,
        uploadDate,
        createdAt,
      ];
}
