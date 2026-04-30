import 'dart:io';

import 'package:flutter/material.dart';

class BaseImage extends StatelessWidget {
  final String url;
  final BoxFit fit;
  final double imgRadius;
  final int downloadWithoutWlan;

  const BaseImage({
    super.key,
    this.url = '',
    this.fit = BoxFit.cover,
    this.imgRadius = 10.0,
    this.downloadWithoutWlan = 0,
  });

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(imgRadius),
      child: Image(
        image: _getImageProvider(url),
        fit: fit,
        loadingBuilder: (context, child, loadingProgress) {
          if (loadingProgress == null) return child;
          return Container(
            color: Theme.of(context).colorScheme.secondaryContainer,
            child: Center(
              child: CircularProgressIndicator(
                value: loadingProgress.expectedTotalBytes != null
                    ? loadingProgress.cumulativeBytesLoaded /
                        loadingProgress.expectedTotalBytes!
                    : null,
              ),
            ),
          );
        },
        errorBuilder: (context, error, stackTrace) {
          return Container(
            color: Theme.of(context).colorScheme.secondaryContainer,
            child: const Icon(Icons.error),
          );
        },
      ),
    );
  }


ImageProvider _getImageProvider(String url) {
    if (url.startsWith('http')) {
      return NetworkImage(url);
    } else if (url.startsWith('/') || url.startsWith('file:')) {
      final filePath = url.startsWith('file://') ? url.substring(7) : url;
      return FileImage(File(filePath));
    } else {
      // asset 资源
      return AssetImage(url);
    }
  }
}
