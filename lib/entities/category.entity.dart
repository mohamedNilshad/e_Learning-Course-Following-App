import 'package:equatable/equatable.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'category.entity.g.dart';

@JsonSerializable(fieldRename: FieldRename.none)
class Category extends Equatable {
  final int? id;
  final String? topic;

  const Category({
    required this.id,
    required this.topic,
  });

  factory Category.fromJson(Map<String, dynamic> json) => _$CategoryFromJson(json);

  Map<String, dynamic> toJson() => _$CategoryToJson(this);

  @override
  List<Object?> get props => [
    id,
    topic,
  ];
}
