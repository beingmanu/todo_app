import 'package:equatable/equatable.dart';

class CardModel extends Equatable {
  final String imageLink;
  final String title;
  final String subTitle;
  final String price;

  const CardModel({
    required this.imageLink,
    required this.title,
    required this.price,
    required this.subTitle,
  });

  factory CardModel.fromMap(Map<String, dynamic> map) => CardModel(
    imageLink: map['image'],
    title: map['title'],
    price: map['price'],
    subTitle: map['subTitle'],
  );

  Map<String, dynamic> toMap() => {
    'image': imageLink,
    'price': price,
    'title': title,
    'subTitle': subTitle,
  };

  @override
  List<Object?> get props => [imageLink, title, price, subTitle];
}
