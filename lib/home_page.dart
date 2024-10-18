import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:twitter_clone/UI/Profile/profile.dart';
import 'package:twitter_clone/UI/post_page.dart';
import 'package:twitter_clone/components/my_alert_dialog.dart';
import 'package:twitter_clone/components/my_drawer.dart';
import 'package:twitter_clone/components/post_tile.dart';
import 'package:twitter_clone/services/auth/auth_provider.dart';
import 'package:twitter_clone/services/database/database_provider.dart';
import 'package:twitter_clone/theme/theme_provider.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late final themeProvider = Provider.of<ThemeProvider>(context, listen: false);
  late final authProvider = Provider.of<AuthProviders>(context, listen: false);
  late final databaseProvider =
      Provider.of<DatabaseProvider>(context, listen: false);

  @override
  Widget build(BuildContext context) {
    ColorScheme colorScheme = Theme.of(context).colorScheme;
    Provider.of<DatabaseProvider>(context);
    return Scaffold(
      appBar: AppBar(
        title: const Text('H O M E'),
        centerTitle: true,
        foregroundColor: colorScheme.primary,
        actions: const [],
      ),
      drawer: const MyDrawer(),
      body: databaseProvider.posts != null && databaseProvider.posts!.isNotEmpty
          ? ListView.builder(
              itemCount: databaseProvider.posts!.length,
              itemBuilder: (context, index) {
                var data = databaseProvider.posts![index];
                return PostTile(
                  colorScheme: colorScheme,
                  postData: data,
                  databaseProvider: databaseProvider,
                  onUserTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ProfilePage(
                          uid: data.uid,
                        ),
                      ),
                    );
                  },
                  onPostTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => PostPage(
                          post: data,
                          databaseProvider: databaseProvider,
                        ),
                      ),
                    );
                  },
                );
              })
          : const Center(
              child: Text('No Post Found !!'),
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showDialog(
              context: context,
              builder: (context) {
                return MyAlertDialog(
                  databaseProvider: databaseProvider,
                  colorScheme: colorScheme,
                  isPost: true,
                  onPressedText: 'Post',
                );
              });
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
