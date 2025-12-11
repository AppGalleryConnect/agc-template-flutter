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
        image: _isAssetImage(url) ? AssetImage(url) : NetworkImage(url),
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

  bool _isAssetImage(String url) {
    return url.startsWith('assets/') || url.startsWith('res/');
  }
}
