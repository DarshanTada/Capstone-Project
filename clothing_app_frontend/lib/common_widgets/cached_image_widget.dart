import 'dart:io';
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:http/http.dart' as http;

class CachedImageWidget extends StatefulWidget {
  final String imageUrl;
  // final String uniqueId;
  final double? height;
  final double? width;
  final BoxFit boxFit;
  final double scale;

  const CachedImageWidget(
    this.imageUrl, {super.key, 
    // required this.uniqueId,
    this.height,
    this.width,
    this.boxFit = BoxFit.cover,
    this.scale = 1.0,
  });

  @override
  CachedImageWidgetState createState() => CachedImageWidgetState();
}

class CachedImageWidgetState extends State<CachedImageWidget> {
  String cachedImagePath = '';

  @override
  void didUpdateWidget(covariant CachedImageWidget oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (oldWidget.imageUrl != widget.imageUrl) {
      _loadImage();
    }
  }

  @override
  void initState() {
    super.initState();
    _loadImage();
  }

  Future<void> _loadImage() async {
    try {
      final String fileName = widget.imageUrl.split('/').last;
      final Directory cacheDir = await getTemporaryDirectory();
      final File imageFile = File('${cacheDir.path}/$fileName');

      if (await imageFile.exists()) {
        cachedImagePath = imageFile.path;
        setState(() {});
      } else {
        final response = await http.get(Uri.parse(widget.imageUrl));
        if (response.statusCode == 200) {
          await imageFile.writeAsBytes(response.bodyBytes);
          cachedImagePath = imageFile.path;
          setState(() {});
        }
      }
    } catch (e) {
      print('URL: ${widget.imageUrl}');
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    return cachedImagePath != ''
        ? Image.file(
            File(cachedImagePath),
            fit: BoxFit.cover,
            height: widget.height,
            width: widget.width,
            scale: widget.scale,
          )
        : Image.asset(
            'assets/placeholders/placeholder.png',
            fit: BoxFit.cover,
            height: widget.height,
            width: widget.width,
            scale: widget.scale,
          );
  }
}
