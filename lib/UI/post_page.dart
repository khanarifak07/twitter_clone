import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:twitter_clone/components/post_tile.dart';
import 'package:twitter_clone/models/post_model.dart';
import 'package:twitter_clone/services/database/database_provider.dart';

class PostPage extends StatefulWidget {
  const PostPage(
      {super.key, required this.post, required this.databaseProvider});

  final PostModel post;
  final DatabaseProvider databaseProvider;

  @override
  State<PostPage> createState() => _PostPageState();
}

class _PostPageState extends State<PostPage> {
  @override
  Widget build(BuildContext context) {
    ColorScheme colorScheme = Theme.of(context).colorScheme;
    late final databaseProvider = Provider.of<DatabaseProvider>(context);
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          widget.post.username,
          style: TextStyle(color: colorScheme.primary),
        ),
        automaticallyImplyLeading: false,
      ),
      body: PostTile(
        colorScheme: colorScheme,
        postData: widget.post,
        databaseProvider: databaseProvider,
      ),
    );
  }
}
