import 'package:flutter/material.dart';

class CustomListTile extends StatelessWidget {
  final String title;
  final String subtitle;
  final String? trailing;
  final TextStyle? titleTextStyle; // Added titleTextStyle as an optional parameter

  const CustomListTile({
    super.key,
    required this.title,
    required this.subtitle,
    this.trailing,
    this.titleTextStyle, // Made titleTextStyle optional
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 5),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20.0),
      ),
      child: ListTile(
        contentPadding: EdgeInsets.zero,
        leading: CircleAvatar(
          backgroundColor: Colors.grey.withOpacity(0.8),
          child: Text(
            title.isNotEmpty ? title[0] : '?', // Handle empty title case
            style: const TextStyle(
              color: Colors.black,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        title: Text(
          title,
          style: titleTextStyle ??
              const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16,
                maxLines: 1,
                overflow: TextOverflow.ellipsis, // Ensure text overflow handling
              ),
        ),
        subtitle: Text(
          subtitle,
          style: TextStyle(
            color: Colors.black.withOpacity(0.5),
          ),
        ),
        trailing: trailing != null
            ? Text(
          trailing!,
          style: const TextStyle(color: Colors.red),
        )
            : const SizedBox(),
      ),
    );
  }
}
