import 'package:equatable/equatable.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'video.entity.g.dart';

@JsonSerializable(fieldRename: FieldRename.none)
class Video extends Equatable {

  final int? id;

  @JsonKey(name: 'video_url')
  final String? videoUrl;

  @JsonKey(name: 'video_title')
  final String? videoTitle;

  @JsonKey(name: 'video_thumb_url')
  final String? videoThumbUrl;

  @JsonKey(name: 'video_description')
  final String? videoDescription;

  const Video({
    required this.id,
    required this.videoUrl,
    required this.videoTitle,
    required this.videoThumbUrl,
    required this.videoDescription
  });

  factory Video.fromJson(Map<String, dynamic> json) => _$VideoFromJson(json);

  Map<String, dynamic> toJson() => _$VideoToJson(this);

  @override
  List<Object?> get props => [
    id,
    videoUrl,
    videoTitle,
    videoThumbUrl,
    videoDescription
  ];
}
