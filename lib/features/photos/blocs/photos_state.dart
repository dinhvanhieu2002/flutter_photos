part of 'photos_bloc.dart';

enum PhotosStatus { initial, loading, loaded, paginating, noMorePhotos, error }

class PhotosState extends Equatable {
  const PhotosState({
    required this.query,
    required this.photos,
    required this.status,
    required this.exception
  });

  factory PhotosState.initial() {
    return const PhotosState(
      query: '', 
      photos: [], 
      status: PhotosStatus.initial, 
      exception: null);
  }

  final String query;
  final List<Photo> photos;
  final PhotosStatus status;
  final CustomException? exception;
  
  @override
  // TODO: implement props
  List<Object?> get props => [query, photos, status, exception];

  @override
  bool get stringify => true;

  PhotosState copyWith({
    String? query,
    List<Photo>? photos,
    PhotosStatus? status,
    CustomException? exception
  }) {
    return PhotosState(
      query: query ?? this.query, 
      photos: photos ?? this.photos, 
      status: status ?? this.status, 
      exception: exception ?? this.exception
    );
  }

}

