import 'dart:convert';
import 'package:bloc/bloc.dart';
import 'package:bloc_concurrency/bloc_concurrency.dart';
import 'package:equatable/equatable.dart';
import 'package:http/http.dart' as http;
import 'package:learning_bloc_infinite_list/posts/models/post.dart';
import 'package:stream_transform/stream_transform.dart';

part 'post_event.dart';
part 'post_state.dart';

const _postLimit = 20;
const throttleDuration = Duration(milliseconds: 100);

EventTransformer<E> throttleDroppable<E>(Duration duration) {
  //limita o numero de dados na stream a uma duração pré definida, ex.: 1 em 1 segundos
  return (events, mapper) {
    return droppable<E>().call(events.throttle(duration), mapper);
  };
}

class PostBloc extends Bloc<PostEvent, PostState> {
  PostBloc({required this.httpClient}) : super(const PostState()) {
    on<PostFetched>(
      _onFetched,
      transformer: throttleDroppable(
        throttleDuration,
      ), // aplicando o limitador de stream
    );
  }

  //lidando com o evento onFetched
  Future<void> _onFetched(PostFetched event, Emitter<PostState> emit) async {
    if (state.hasReachedMax) return; // se ja estiver no maximo sai do metodo

    try {
      final posts = await _fetchPosts(
        startIndex: state.posts.length,
      ); // busque a partir do ultimo post

      if (posts.isEmpty) {
        //se ja tiver buscado todos, muda o state para maximo
        return emit(state.copyWith(hasReachedMax: true));
      }

      //se nao for nenhuma das outras opções, atualiza o estado do bloc pra success
      // e atualiza a lista de posts com os novos buscados
      emit(
        state.copyWith(
          status: PostStatus.success,
          posts: [...state.posts, ...posts],
        ),
      );
    } catch (_) {
      //se der errado muda o estado para erro
      emit(state.copyWith(status: PostStatus.failure));
    }
  }

  final http.Client httpClient;

  //chama a api para retornar os exemplos
  Future<List<Post>> _fetchPosts({required int startIndex}) async {
    final response = await httpClient.get(
      Uri.https('jsonplaceholder.typicode.com', '/posts', <String, String>{
        '_start': '$startIndex',
        '_limit': '$_postLimit',
      }),
    );
    if (response.statusCode == 200) {
      final body = json.decode(response.body) as List;
      return body.map((dynamic json) {
        final map = json as Map<String, dynamic>;
        return Post(
          id: map['id'] as int,
          title: map['title'] as String,
          body: map['body'] as String,
        );
      }).toList();
    }
    throw Exception('error fetching posts');
  }
}
