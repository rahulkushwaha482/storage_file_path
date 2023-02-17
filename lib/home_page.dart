import 'dart:io';
import 'dart:typed_data';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:image_picker_plus/image_picker_plus.dart' as imagePickerPlus;
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:ux_images_picker/images_picker.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late final ImagePicker _picker;
  var pathOne ='';
  var pathTwo = '';
  var pathThree = '';
  var pathFour = '';
  var pathFIve = '';


  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _picker = ImagePicker();
    checkPermission();
  }

  void checkPermission() async {
    if (await Permission.storage.request().isGranted) {
    } else {
      await Permission.storage.request();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Container(
          width: MediaQuery.of(context).size.width,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              ElevatedButton(
                  onPressed: () {
                    openGallery();
                  },
                  child: const Text('Get FilePath using Image Picker')),
              Text(
                'Path :-$pathOne',
                style: const TextStyle(
                  fontSize: 12,
                  fontStyle: FontStyle.italic,
                ),
              ),
              ElevatedButton(
                  onPressed: () {
                    openGalleryUsingFilePicker();
                  },
                  child: const Text('Get FilePath Using File Picker')),
              Text(
                'Path :-$pathTwo',
                style: const TextStyle(
                  fontSize: 12,
                  fontStyle: FontStyle.italic,
                ),
              ),
              ElevatedButton(
                  onPressed: () {
                    openFileUsingImagesPicker();
                  },
                  child: const Text('Get FilePath Using Images Picker')),

              Text(
                'Path :-$pathThree',
                style: const TextStyle(
                  fontSize: 12,
                  fontStyle: FontStyle.italic,
                ),
              ),

              ElevatedButton(
                  onPressed: () {
                    openFilesUsingImagePickerPlus();
                  },
                  child: const Text('Get FilePath Using Images Picker Plus')),

              Text(
                'Path :-$pathFour',
                style: const TextStyle(
                  fontSize: 12,
                  fontStyle: FontStyle.italic,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }


  openFilesUsingImagePickerPlus() async{
    imagePickerPlus.ImagePickerPlus picker = imagePickerPlus.ImagePickerPlus(context);

    imagePickerPlus.SelectedImagesDetails? details =
        await picker.pickImage(source: imagePickerPlus.ImageSource.both);




    setState(() {
      pathFour = details!.selectedFiles.first.selectedFile.path;
    });
  }

  openGalleryUsingFilePicker() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles();

    if (result != null) {
      File file = File(result.files.single.path.toString());
      setState(() {
        pathTwo = file.path;
      });
    } else {
      // User canceled the picker
    }
  }

  openFileUsingImagesPicker()async{
    List<Media>? res = await ImagesPicker.pick(
      count: 3,
      pickType: PickType.image,
    );
    setState(() {
      pathThree = res!.first.path;
    });
  }

  openGallery() async {
    // List<Media>? res = await ImagesPicker.pick(
    //   count: 3,
    //   pickType: PickType.image,
    // );
    //
    // print(res?.first.path);

    // String? selectedDirectory = await FilePicker.platform.getDirectoryPath();
    // print('directory path$selectedDirectory');
    // if (selectedDirectory == null) {
    //   // User canceled the picker
    // }

    final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
    setState(() {
      pathOne = image!.path;
    });

    //getFilePath(image.readAsBytes());
  }

  Future<String> getFilePath(Future<Uint8List> asdasd) async {
    //print(asdasd);
    if (asdasd != null) {
      Uint8List? imageInUnit8List;
      imageInUnit8List =
          await asdasd.then((value) => value); // store unit8List image here ;

      final tempDir = await getExternalStorageDirectory();
      File file = await File('${tempDir!.path}/${1}.png').create();
      file.writeAsBytesSync(imageInUnit8List!);
      print('filepath');
      print(file.path);
      return file.path;
    } else {
      return 'null';
    }
  }
}
