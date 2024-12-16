import 'dart:io';
import 'package:image_cropper/image_cropper.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  File? _image; //to store the selected image file
  String? _selectedFrame; // to store the selected frame path
  final picker = ImagePicker(); //object to pick image from gallery or camera
  bool _isPickerActive = false; //tracks if image picker is currently in use to *prevent multiple image selections*

  List<String> frames = [
    'assets/frames/asset/user_image_frame_1.png',
    'assets/frames/asset/user_image_frame_2.png',
    'assets/frames/asset/user_image_frame_3.png',
    'assets/frames/asset/user_image_frame_4.png'
  ];

  get aspectRatiopresets => null;

  get children => null;

  Future getImageGallery() async {
    if (_isPickerActive) {
      return;
    }
    setState(() {
      _isPickerActive = true;
    });

    //pick an image from gallery

    final PickedFile = await picker.pickImage(
      source: ImageSource.gallery,
      imageQuality: 80,
    );

    //if image is selected crop the image

    if (PickedFile != null) {
      CroppedFile? croppedFile = (await ImageCropper().cropImage(
        sourcePath: PickedFile.path,
        aspectRatio: CropAspectRatio(ratioX: 1.0, ratioY: 1.0),
      ));
      //if image is selected update the uI
      if (croppedFile != null) {
        setState(() {
          _image = File(croppedFile.path);
          _selectedFrame = null;
        });
      } else {
        print("No image picked");
      }
    }
    setState(() {
      _isPickerActive = false;
    });
  }
//display image with frame logic

  Widget displayImageWithFrame() {
    if (_image == null) {
      return Center(
        child: Icon(
          Icons.add_photo_alternate_outlined,
          size: 30,
        ),
      );
    }

    return Center(
      child: Stack(
        alignment: Alignment.center,
        children: [
          if (_selectedFrame != null)
            ClipRRect(
              child: Container(
                width: 100,
                height: 100,
                decoration: BoxDecoration(
                  
                  image: DecorationImage(
                    image: AssetImage(_selectedFrame!),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            ),
          ClipRRect(
            child: Image.file(
              _image!,
              fit: BoxFit.cover,
              width: 300,
              height: 300,
            ),
          )
        ],
      ),
    );
  }

//frame selector

  Widget frameSelector() {
    return SizedBox(
      height: 100,
      child: ListView.builder(
          scrollDirection: Axis.horizontal,
          itemCount: frames.length,
          itemBuilder: (context, index) {
            return GestureDetector(
              onTap: () {
                setState(() {
                  _selectedFrame = frames[index];//update the selected frame when tapped
                });
              },
              child: Container(
                margin: EdgeInsets.symmetric(horizontal: 8),
                decoration: BoxDecoration(
                    border: Border.all(
                        color: _selectedFrame == frames[index]
                            ? Colors.green
                            : Colors.transparent,
                        width: 2)),
                child: Image.asset(frames[index]),//display each frame
              ),
            );
          }),
    );
  }
  //main UI
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Add Image/Icon'),
        backgroundColor: Colors.green,
        centerTitle: true,
      ),
      body: Center(
        child: Column(
          children: [
            SizedBox(height: 20),
            InkWell(
                onTap: () {
                  getImageGallery();//trigger image selection
                },
                child: Container(
                    height: 200,
                    width: 300,
                    decoration: BoxDecoration(
                        border: Border.all(color: Colors.lightGreen)),
                    child: displayImageWithFrame())),//display the image with the selected frame


            SizedBox(
              height: 20,
            ),
            InkWell(
              onTap: () {
                getImageGallery();//trigger selection frame agiain
              },
              child: Container(
                padding: EdgeInsets.symmetric(vertical: 8, horizontal: 15),
                decoration: BoxDecoration(
                  color: Colors.green,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  'Choose from Device',
                  style: TextStyle(color: Colors.white, fontSize: 16),
                ),
              ),
            ),
            SizedBox(
              height: 20,
            ),
            //show frame selector if an image is selected
            if (_image != null) ...[
              Text("Select a frame:"),
              frameSelector(),
              SizedBox(
                height: 20,
              )
            ],
          ],
        ),
      ),
    );
  }
}
