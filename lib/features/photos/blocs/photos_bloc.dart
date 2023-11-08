import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_photos/models/models.dart';
import 'package:flutter_photos/repositories/repositories.dart';

part 'photos_event.dart';
part 'photos_state.dart';

class PhotosBloc extends Bloc<PhotosEvent, PhotosState> {
  PhotosBloc({required PhotosRepository photosRepository}) 
  : _photosRepository = photosRepository,
  super(PhotosState.initial()) {
    on<PhotosSearchPhotos>(_onPhotosSearchPhotos);
    on<PhotosPaginate>(_onPhotosPaginate);
  }

  final PhotosRepository _photosRepository;

  Future<void> _onPhotosSearchPhotos(
    PhotosSearchPhotos event,
    Emitter<PhotosState> emit
  ) async {
    try {
      emit(state.copyWith(query: event.query, status: PhotosStatus.loading));
      final photos = await _photosRepository.searchPhotos(query: event.query);
      emit(state.copyWith(photos: photos, status: PhotosStatus.loaded));
    } catch (_) {
      emit(
        state.copyWith(
          exception: const CustomException('Please try a different search'),
          status: PhotosStatus.error
        )
      );
    }
  }

  Future<void> _onPhotosPaginate(
    PhotosPaginate event,
    Emitter<PhotosState> emit
  ) async {

    emit(state.copyWith(status: PhotosStatus.paginating));
    final photos = List<Photo>.from(state.photos);
    var nextPhotos = <Photo>[];
    if(photos.length >= PhotosRepository.numPerPage) {
      nextPhotos = await _photosRepository.searchPhotos(query: state.query, page: state.photos.length ~/ PhotosRepository.numPerPage + 1);
    }
    emit(state.copyWith(photos: photos..addAll(nextPhotos), status: nextPhotos.isNotEmpty ? PhotosStatus.loaded : PhotosStatus.noMorePhotos));
  }
}
