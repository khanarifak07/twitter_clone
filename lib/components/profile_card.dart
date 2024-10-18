import 'package:flutter/material.dart';
import 'package:twitter_clone/services/database/database_provider.dart';

class ProfileCard extends StatelessWidget {
  const ProfileCard({
    super.key,
    required this.colorScheme,
    required this.databaseProvider,
    required this.title,
    required this.isBio,
    required this.ontap,
  });
  final String title;
  final bool isBio;
  final Function() ontap;
  final ColorScheme colorScheme;
  final DatabaseProvider databaseProvider;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.maxFinite,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
          color: colorScheme.secondary,
          borderRadius: BorderRadius.circular(10)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                title,
                style:
                    const TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
              ),
              InkWell(
                onTap: ontap,
                child: Icon(
                  Icons.edit_outlined,
                  size: 20,
                  color: colorScheme.primary,
                ),
              )
            ],
          ),
          const SizedBox(height: 6),
          isBio
              ? Text(databaseProvider.user!.bio.isEmpty
                  ? "NA"
                  : databaseProvider.user!.bio)
              : Row(
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Email',
                          style: TextStyle(
                            fontSize: 12,
                            color: colorScheme.primary,
                          ),
                        ),
                        Text(
                          databaseProvider.user!.email,
                          style: const TextStyle(),
                        ),
                      ],
                    ),
                    SizedBox(width: MediaQuery.of(context).size.width * 0.2),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Full Name',
                          style: TextStyle(
                            fontSize: 12,
                            color: colorScheme.primary,
                          ),
                        ),
                        Text(
                          databaseProvider.user!.name,
                          style: const TextStyle(
                              // fontSize: 12,
                              // color: colorScheme.primary,
                              ),
                        ),
                      ],
                    ),
                  ],
                )
        ],
      ),
    );
  }
}
