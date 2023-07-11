import 'package:course_mate/entities/doc.entity.dart';
import 'package:course_mate/entities/video.entity.dart';
import 'package:equatable/equatable.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'get_contents.entity.g.dart';

@JsonSerializable(fieldRename: FieldRename.snake)
class GetContents extends Equatable {
  final List<Video> video;
  final List<Doc> docs;

  const GetContents({
    required this.video,
    required this.docs,
  });

  factory GetContents.fromJson(Map<String, dynamic> json) => _$GetContentsFromJson(json);

  Map<String, dynamic> toJson() => _$GetContentsToJson(this);

  @override
  List<Object?> get props => [
    video,
    docs,
  ];
}
