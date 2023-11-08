import 'package:equatable/equatable.dart';
import 'user_model.dart';
class Photo extends Equatable {
  const Photo({required this.id, required this.url, required this.description, required this.user});
  final String id;
  final String url;
  final String description;
  final User user;
  @override
  // TODO: implement props
  List<Object> get props => [id, url, description];

  @override
  bool get stringify => true;

  factory Photo.fromMap(Map<String, dynamic> map) {
    return Photo(
      id: map['id'],
      url: map['urls']['regular'],
      description: map['description'] ?? 'No description',
      user: User.fromMap(map['user'])
    );
  }
}