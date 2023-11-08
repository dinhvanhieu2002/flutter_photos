import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_photos/features/features.dart';
import 'package:flutter_photos/repositories/photos_repository.dart';
import 'package:flutter_photos/ui/photos/photos.dart';

class PhotosScreen extends StatelessWidget {
  const PhotosScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => PhotosBloc(
        photosRepository: context.read<PhotosRepository>(),
      )..add(const PhotosSearchPhotos(query: 'programming')),
      child: const PhotosView(),
    );
  }
}

class PhotosView extends StatefulWidget {
  const PhotosView({super.key});

  @override
  State<PhotosView> createState() => _PhotosViewState();
}

class _PhotosViewState extends State<PhotosView> {
  late ScrollController _scrollController;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _scrollController = ScrollController()..addListener(() {
      if(_scrollController.offset == _scrollController.position.maxScrollExtent && 
        context.read<PhotosBloc>().state.status != PhotosStatus.paginating) {
          context.read<PhotosBloc>().add(PhotosPaginate());
        }
    });
  }

  @override
  void dispose() {
    // TODO: implement dispose
    _scrollController.dispose();
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Photos'),
        ),
        body: BlocConsumer<PhotosBloc, PhotosState>(
          listener: (context, state) {
            switch(state.status) {
              case PhotosStatus.paginating:
                ScaffoldMessenger.of(context)
                  ..hideCurrentSnackBar()
                  ..showSnackBar(
                    const SnackBar(
                      backgroundColor: Colors.green,
                      content: Text('Loading more photos...'),
                      duration: Duration(seconds: 1),
                    )
                  );
                  break;
              case PhotosStatus.noMorePhotos:
                ScaffoldMessenger.of(context)
                  .showSnackBar(
                    const SnackBar(
                      backgroundColor: Colors.red,
                      content: Text('No more photos...'),
                      duration: Duration(milliseconds: 1500),
                    )
                  );
                  break;
              case PhotosStatus.error:
                showDialog(
                  context: context, 
                  builder: (context) => AlertDialog(
                    title: const Text('Search error'),
                    content: Text(state.exception!.message),
                    actions: [
                      TextButton(
                        onPressed: () => Navigator.of(context).pop(), 
                        child: const Text('OK')
                      )
                    ],
                  )
                );
                break;
              default:
                break;
            }
          },
          
          builder: (context, state) {
            return Stack(alignment: Alignment.center, children: [
              Column(
                children: [
                  TextField(
                    decoration: const InputDecoration(
                        hintText: 'Search',
                        fillColor: Colors.white,
                        filled: true),
                    onSubmitted: (val) {
                      if (val.trim().isNotEmpty) {
                        context.read<PhotosBloc>().add(PhotosSearchPhotos(query: val.trim()));
                      }
                    },
                  ),
                  Expanded(

                        child: state.photos.isNotEmpty ? GridView.builder(
                          controller: _scrollController,
                          padding: const EdgeInsets.all(20),
                          gridDelegate:
                              const SliverGridDelegateWithFixedCrossAxisCount(
                                  mainAxisSpacing: 15.0,
                                  crossAxisSpacing: 15.0,
                                  crossAxisCount: 2,
                                  childAspectRatio: 0.8),
                          itemCount: state.photos.length,
                          itemBuilder: (context, index) {
                            final photo = state.photos[index];
                            return PhotoCard(
                                photos: state.photos, index: index, photo: photo);
                          },
                        ) : const Center(child: Text('No results'),)
                      

                  )
                ],
              ),
              if(state.status == PhotosStatus.loading) 
                const CircularProgressIndicator()
            ]);
          },
        ),
      ),
    );
  }
}
