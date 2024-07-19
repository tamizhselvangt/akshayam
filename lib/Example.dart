import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class YouTubeThumbnail extends StatelessWidget {
  final String videoId;

  YouTubeThumbnail({required this.videoId});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => _launchYouTubeVideo(videoId),
      child: Image.network(
        'https://img.youtube.com/vi/$videoId/mqdefault.jpg',
        fit: BoxFit.cover,
      ),
    );
  }

  void _launchYouTubeVideo(String videoId) async {
    final Uri url = Uri.parse('https://www.youtube.com/watch?v=$videoId');
    if (!await launchUrl(url, mode: LaunchMode.externalApplication)) {
      throw Exception('Could not launch $url');
    }
  }
}

// Usage example
class ExamplePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('YouTube Thumbnail Example')),
      body: Center(
        child: YouTubeThumbnail(videoId: 'dQw4w9WgXcQ'),
      ),
    );
  }
}

//
String? getYouTubeVideoId(String url) {
  // Regular expressions to match various YouTube URL formats
  final regExp = RegExp(
      r'^https:\/\/(?:www\.|m\.)?youtube\.com\/watch\?v=([_\-a-zA-Z0-9]{11}).*$|'
      r'^https:\/\/(?:www\.|m\.)?youtube(?:-nocookie)?\.com\/embed\/([_\-a-zA-Z0-9]{11}).*$|'
      r'^https:\/\/youtu\.be\/([_\-a-zA-Z0-9]{11}).*$'
  );

  if (url.isEmpty) {
    return null;
  }

  final match = regExp.firstMatch(url);
  if (match != null && match.groupCount >= 1) {
    return match.group(1) ?? match.group(2) ?? match.group(3);
  }

  return null;
}
