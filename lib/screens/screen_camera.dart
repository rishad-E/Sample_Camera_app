import 'package:camera_project/db/functions/db_functions.dart';
import 'package:camera_project/db/model/db_model.dart';
import 'package:camera_project/widgets/image_card.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:image_picker/image_picker.dart';

class CameraScreen extends StatefulWidget {
  const CameraScreen({Key? key}) : super(key: key);

  @override
  State<CameraScreen> createState() => _CameraScreenState();
}

class _CameraScreenState extends State<CameraScreen> {
  @override
  void initState() {
    getAllImage();
    super.initState();
  }

  late String _imageData;
  late int length;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor:const Color.fromARGB(255, 79, 165, 82),
        centerTitle: true,
        title: const Text(
          'Camera App',
        ),
        actions: [
          IconButton(
            onPressed: () {
              delete();
            },
            icon: const Icon(
              Icons.delete_outline,
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor:const Color.fromARGB(255, 79, 165, 82),
        onPressed: () {
          getImage();
        },
        child: const Icon(
          Icons.camera_alt_outlined,
          
        ),
      ),
      body: ValueListenableBuilder(
        valueListenable: galleryImageNotifier,
        builder: (
          BuildContext context,
          List<GallaryModel> galleryList,
          Widget? child,
        ) {
          length = galleryList.length;
          return (length == 0)
              ? const Center(
                  child: Text(
                    'No Photos in Gallery',
                  ),
                )
              : GridView.builder(
                  itemCount: galleryList.length,
                  gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
                    maxCrossAxisExtent: 150,
                    crossAxisSpacing: 1,
                    mainAxisSpacing: 1,
                  ),
                  itemBuilder: (
                    BuildContext context,
                    int index,
                  ) {
                    final data = galleryList[index];
                    return Padding(
                      padding: const EdgeInsets.only(
                        top: 20,
                      ),
                      child: ImageCard(
                        path: data.image,
                      ),
                    );
                  },
                );
        },
      ),
    );
  }

  Future<void> getImage() async {
    final image = await ImagePicker().pickImage(
      source: ImageSource.camera,
    );
    if (image == null) {
      return;
    }
    _imageData = image.path;
    final picture = GallaryModel(
      image: _imageData,
    );
    addImage(picture);
  }

  Future<void> delete() async {
    deleteAllImage();
  }



  Future<void> getAllImage() async {
  final galaryDB = await Hive.openBox<GallaryModel>('galary_db');
  galleryImageNotifier.value.clear();
  galleryImageNotifier.value.addAll(galaryDB.values);
  galleryImageNotifier.notifyListeners();
}

// ValueNotifier<List<GallaryModel>> galleryImageNotifier = ValueNotifier([]);
// Future<void> addImage(GallaryModel value) async {
//   final galaryDB = await Hive.openBox<GallaryModel>('galary_db');
//   final id = await galaryDB.add(value);
//   value.id = id;
//   galleryImageNotifier.value.add(value);
//   await galaryDB.put(id, value);
//   galleryImageNotifier.notifyListeners();
//   getAllImage();
// }

// Future<void> deleteAllImage() async {
//   final galaryDB = await Hive.openBox<GallaryModel>('galary_db');
//   galleryImageNotifier.value.clear();
//   galaryDB.clear();
//   galleryImageNotifier.notifyListeners();
// }


}