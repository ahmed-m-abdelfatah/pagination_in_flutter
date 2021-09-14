import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:using_bloc/cubit/posts_cubit.dart';
import 'package:using_bloc/data/models/post.dart';

class PostsScreen extends StatelessWidget {
  final ScrollController scrollController = ScrollController();

  void setupScrollController(context) {
    scrollController.addListener(() {
      if (scrollController.position.atEdge) {
        if (scrollController.position.pixels != 0) {
          PostsCubit.get(context).loadPosts();
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    setupScrollController(context);
    PostsCubit.get(context).loadPosts();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Posts'),
      ),
      body: _postsList(),
    );
  }

  Widget _postsList() {
    return BlocBuilder<PostsCubit, PostsState>(
      builder: (context, state) {
        if (state is PostsLoading && state.isFirstFetch) {
          return _loadingIndicator();
        }

        List<Post> posts = [];
        bool isLoading = false;

        if (state is PostsLoading) {
          posts = state.oldPosts;
          isLoading = true;
        } else if (state is PostsLoaded) {
          posts = state.posts;
        }

        return ListView.separated(
          controller: scrollController,
          itemBuilder: (context, index) {
            if (index < posts.length) {
              return _post(posts[index], context);
            } else {
              Timer(Duration(milliseconds: 30), () {
                scrollController
                    .jumpTo(scrollController.position.maxScrollExtent);
              });
              return _loadingIndicator();
            }
          },
          separatorBuilder: (context, index) {
            return Divider(color: Colors.grey[400]);
          },
          itemCount: posts.length + (isLoading ? 1 : 0),
        );
      },
    );
  }

  Widget _loadingIndicator() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Center(child: CircularProgressIndicator()),
    );
  }

  Widget _post(Post post, BuildContext context) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.all(10.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '${post.id} . ${post.title}',
            style: const TextStyle(
              fontSize: 18.0,
              color: Colors.black,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 10.0),
          Text(post.body),
        ],
      ),
    );
  }
}
