import 'package:equatable/equatable.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'doc.entity.g.dart';

@JsonSerializable(fieldRename: FieldRename.snake)
class Doc extends Equatable {
  final int? id;
  final int? courseId;
  final int? videoId;
  final String? docUrl;

  const Doc({
    required this.id,
    required this.courseId,
    required this.videoId,
    required this.docUrl,
  });

  factory Doc.fromJson(Map<String, dynamic> json) => _$DocFromJson(json);

  Map<String, dynamic> toJson() => _$DocToJson(this);

  @override
  List<Object?> get props => [
        id,
        courseId,
        videoId,
        docUrl,
      ];
}
