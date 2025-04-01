import 'package:equatable/equatable.dart';

final class Post extends Equatable {
  //equatable evita rebuilds desnecessários e otimiza a comparação de classes
  const Post({required this.id, required this.title, required this.body});
  final int id;
  final String title;
  final String body;

  @override
  List<Object?> get props => [id, title, body];
}
