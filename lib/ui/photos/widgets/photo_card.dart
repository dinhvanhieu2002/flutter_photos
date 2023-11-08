import 'package:flutter/material.dart';
import 'package:flutter_photos/models/models.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter_photos/ui/photos/photos.dart';

class PhotoCard extends StatelessWidget {
  const PhotoCard({super.key, required this.photos, required this.index, required this.photo});

  final List<Photo> photos;
  final int index;
  final Photo photo;
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => Navigator.of(context).push(
        MaterialPageRoute(builder: (_) => PhotoViewerScreen(photos: photos, currentIndex: index))
      ),
      child: Hero(
        tag: Key('${index}_${photo.id}'),
        child: Container(
          decoration: BoxDecoration(
            color: Colors.grey[50],
            borderRadius: BorderRadius.circular(10.0),
            boxShadow: const [
              BoxShadow(
                color: Colors.black26,
                offset: Offset(0, 2),
                blurRadius: 4.0
              )
            ],
            image: DecorationImage(
              image: CachedNetworkImageProvider(photo.url),
              fit: BoxFit.cover
            )
          ),
        ),
      ),
    );
  }
}
