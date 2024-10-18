import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:twitter_clone/UI/Profile/profile.dart';
import 'package:twitter_clone/UI/Settings/settings.dart';
import 'package:twitter_clone/services/auth/auth_provider.dart';
import 'package:twitter_clone/Utilities/utilities.dart';
import 'package:twitter_clone/theme/theme_provider.dart';

class MyDrawer extends StatelessWidget {
  const MyDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    ColorScheme colorScheme = Theme.of(context).colorScheme;
    ThemeProvider themeProvider = Provider.of<ThemeProvider>(context);
    final authProvider = Provider.of<AuthProviders>(context);
    final auth = FirebaseAuth.instance;
    return Drawer(
      backgroundColor: colorScheme.surface,
      child: SafeArea(
        child: Column(
          children: [
            Icon(
              Icons.person,
              color: colorScheme.primary,
              size: 100,
            ),
            Divider(
              indent: 25,
              endIndent: 25,
              color: colorScheme.secondary,
            ),
            DrawerTile(
              colorScheme: colorScheme,
              title: 'Profile',
              icon: Icons.home,
              iconColor: colorScheme.primary,
              trailingWidget: Icon(Icons.arrow_forward_ios,
                  color: colorScheme.primary, size: 20),
              ontap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) =>
                        ProfilePage(uid: auth.currentUser!.uid),
                  ),
                );
              },
            ),
            DrawerTile(
              colorScheme: colorScheme,
              title: 'Settings',
              icon: Icons.settings,
              iconColor: colorScheme.primary,
              trailingWidget: Icon(Icons.arrow_forward_ios,
                  color: colorScheme.primary, size: 20),
              ontap: () {
                Utilities.navigateScreen(context, const Settings());
              },
            ),
            DrawerTile(
              colorScheme: colorScheme,
              title: 'Home',
              icon: Icons.home,
              iconColor: colorScheme.primary,
              trailingWidget: Icon(Icons.arrow_forward_ios,
                  color: colorScheme.primary, size: 20),
            ),
            DrawerTile(
              colorScheme: colorScheme,
              title: themeProvider.isDarkMode ? 'Light Mode' : 'Dark Mode',
              icon:
                  themeProvider.isDarkMode ? Icons.light_mode : Icons.dark_mode,
              iconColor: colorScheme.primary,
              ontap: () {
                // themeProvider.toggleTheme();
              },
              trailingWidget: CupertinoSwitch(
                value: themeProvider.isDarkMode,
                onChanged: (value) {
                  themeProvider.toggleTheme();
                },
              ),
            ),
            const Spacer(),
            DrawerTile(
              colorScheme: colorScheme,
              title: 'Logout',
              icon: Icons.logout,
              iconColor: Colors.red,
              trailingWidget: Icon(Icons.arrow_forward_ios,
                  color: colorScheme.primary, size: 20),
              ontap: () {
                authProvider.logout();
              },
            ),
          ],
        ),
      ),
    );
  }
}

class DrawerTile extends StatelessWidget {
  const DrawerTile({
    super.key,
    required this.colorScheme,
    required this.title,
    required this.icon,
    this.ontap,
    this.iconColor,
    required this.trailingWidget,
  });

  final ColorScheme colorScheme;
  final String title;
  final IconData icon;
  final Function()? ontap;
  final Widget trailingWidget;
  final Color? iconColor;

  @override
  Widget build(BuildContext context) {
    return ListTile(
        onTap: ontap,
        leading: Icon(
          icon,
          color: iconColor,
          size: 30,
        ),
        title: Text(
          title,
          style: TextStyle(
            color: colorScheme.primary,
            fontSize: 20,
          ),
        ),
        trailing: trailingWidget);
  }
}
