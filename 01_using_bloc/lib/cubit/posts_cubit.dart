import 'package:bloc/bloc.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meta/meta.dart';
import 'package:using_bloc/data/models/post.dart';
import 'package:using_bloc/data/repositories/posts_repository.dart';

part 'posts_state.dart';

class PostsCubit extends Cubit<PostsState> {
  PostsCubit(this.repository) : super(PostsInitial());

  static PostsCubit get(context) => BlocProvider.of(context);

  int page = 1;
  final PostsRepository repository;

  void loadPosts() {
    if (state is PostsLoading) return;

    final currentState = state;

    var oldPosts = <Post>[];
    if (currentState is PostsLoaded) {
      oldPosts = currentState.posts;
    }

    emit(PostsLoading(oldPosts, isFirstFetch: page == 1));

    repository.fetchPosts(page).then((newPosts) {
      page++;

      final posts = (state as PostsLoading).oldPosts;
      posts.addAll(newPosts);

      emit(PostsLoaded(posts));
    });
  }
}
