import 'package:flutter/material.dart';

class CustomListTile extends StatelessWidget {
  final String title;
  final String subtitle;
  final String? trailing;
  final TextStyle? titleTextStyle;

  const CustomListTile({
    super.key,
    required this.title,
    required this.subtitle,
    this.trailing,
    this.titleTextStyle,
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
          maxLines: 1, // Ensure the title doesn't overflow
          overflow: TextOverflow.ellipsis, // Ellipsis for overflow
          style: titleTextStyle ??
              const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16,
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
