import 'package:channeler/backend/post.dart';
import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:url_launcher/url_launcher.dart';

class FeedCardTextBody extends StatelessWidget {
  const FeedCardTextBody(
      {super.key, required this.post, required this.padding});
  final Post post;
  final EdgeInsets padding;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Padding(
      padding: padding,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (post.title.isNotEmpty)
            Text(
              post.title,
              softWrap: true,
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
          if (post.title.isNotEmpty) const SizedBox(height: 10),
          Markdown(
            padding: EdgeInsets.zero,
            data: post.content,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            styleSheet:
                MarkdownStyleSheet.fromTheme(Theme.of(context)).copyWith(
              blockquotePadding: const EdgeInsets.all(20),
              blockquoteDecoration: BoxDecoration(
                color: colorScheme.primary.withOpacity(0.1),
                borderRadius: BorderRadius.circular(5),
              ),
              a: TextStyle(
                color: colorScheme.primary,
                decoration: TextDecoration.underline,
                decorationColor: colorScheme.primary,
              ),
            ),
            onTapLink: (text, href, title) {
              String url = href ?? '';
              if (url.isNotEmpty) {
                if (url.startsWith('/')) {
                  url = 'https://boards.4channel.org$href';
                }
                launchUrl(
                  Uri.parse(url),
                  mode: LaunchMode.externalApplication,
                );
              }
            },
          ),
        ],
      ),
    );
  }
}
