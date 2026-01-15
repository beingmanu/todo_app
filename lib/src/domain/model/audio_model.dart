import 'package:equatable/equatable.dart';

class AudioModel extends Equatable {
  final String audioUrl;
  final String title;
  final String singer;
  final String imageUrl;
  final String sId;

  const AudioModel({
    required this.audioUrl,
    required this.title,
    required this.singer,
    required this.imageUrl,
    required this.sId,
  });

  /// Factory constructor to create an AudioModel from a Map (JSON).
  factory AudioModel.fromMap(Map<String, dynamic> map) => AudioModel(
    audioUrl: map['audioUrl'] ?? '',
    title: map['title'] ?? '',
    singer: map['singer'] ?? '',
    imageUrl: map['imageUrl'] ?? '',
    sId: map['id'] ?? "",
  );

  /// Converts the AudioModel instance into a Map (JSON).
  Map<String, dynamic> toMap() => {
    'audioUrl': audioUrl,
    'title': title,
    'singer': singer,
    'imageUrl': imageUrl,
    'id': sId,
  };

  @override
  List<Object?> get props => [audioUrl, title, singer, imageUrl, sId];
}
