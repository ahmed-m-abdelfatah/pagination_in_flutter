import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:using_bloc/cubit/posts_cubit.dart';
import 'package:using_bloc/data/repositories/posts_repository.dart';
import 'package:using_bloc/data/services/posts_service.dart';
import 'package:using_bloc/presentation/posts_screen.dart';

void main() => runApp(
      MyApp(
        repository: PostsRepository(PostsService()),
      ),
    );

class MyApp extends StatelessWidget {
  final PostsRepository repository;

  const MyApp({Key? key, required this.repository}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Material App',
      debugShowCheckedModeBanner: false,
      home: BlocProvider(
        create: (context) => PostsCubit(repository),
        child: PostsScreen(),
      ),
    );
  }
}
