import 'dart:io';
import 'package:course_mate/constant/constants.dart';
import 'package:course_mate/main_layout.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mime/mime.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UploadProfile extends StatefulWidget {
  const UploadProfile({super.key});

  @override
  _UploadProfileState createState() => _UploadProfileState();
}

class _UploadProfileState extends State<UploadProfile> {
  File? _imageFile;

  Future<void> _selectImage() async {
    {
      showModalBottomSheet<void>(
        context: context,
        isScrollControlled: true,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(30.0),
            topRight: Radius.circular(30.0),
          ),
        ),
        builder: (BuildContext c) {
          return SizedBox(
            height: 140,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                const SizedBox(height: 20),
                Container(
                  width: 60,
                  height: 6,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(3.0),
                    color: Theme.of(context).brightness == Brightness.dark
                        ? Colors.grey.shade500
                        : const Color(0xFFE0E0E0),
                  ),
                ),
                const SizedBox(
                  height: 20.0,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    InkWell(
                      onTap: () {
                        Navigator.of(context).pop();
                        _pickImage(ImageSource.camera);
                      },
                      child: SizedBox(
                        child: Column(
                          children: const [
                            Icon(Icons.camera_alt_rounded),
                            SizedBox(
                              height: 3,
                            ),
                            Text(
                              'Camera',
                            )
                          ],
                        ),
                      ),
                    ),
                    Container(
                        width: 2,
                        height: 60,
                        color: Theme.of(context).brightness == Brightness.dark
                            ? Colors.grey.shade500
                            : const Color(0xFFE0E0E0)),
                    InkWell(
                      onTap: () {
                        Navigator.of(context).pop();
                        _pickImage(ImageSource.gallery);
                      },
                      child: SizedBox(
                        child: Column(
                          children: const [
                            Icon(
                              Icons.photo_library_rounded,
                            ),
                            SizedBox(
                              height: 3,
                            ),
                            Text(
                              'Gallery',
                            ),
                          ],
                        ),
                      ),
                    )
                  ],
                )
              ],
            ),
          );
        },
      );
    }
  }

  Future<void> _uploadImage() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    var uID = (prefs.getInt('userId').toString());

    if (_imageFile == null) {
      debugPrint('Please select an image');
      return;
    }


    final url = '${fullURL}profilePic'; // Replace with your API endpoint
    //
    final mimeType = lookupMimeType(_imageFile!.path);
    final fileStream = http.ByteStream(Stream.castFrom(_imageFile!.openRead()));
    //
    final request = http.MultipartRequest('POST', Uri.parse(url));

    final multipartFile = http.MultipartFile(
      'profileImage',
      fileStream,
      _imageFile!.lengthSync(),
      filename: _imageFile!.path.split('/').last,
      contentType: MediaType.parse(mimeType!),
    );
    final userId =
    //
    request.files.add(multipartFile);
    request.fields['id'] = uID;
    //
    final response = await request.send();
    if (response.statusCode == 200) {
      // Handle successful response
      debugPrint('Image uploaded successfully');
    } else {
      // Handle error response
      debugPrint('Failed to upload image');
    }
  }

  _pickImage(ImageSource source) async {
    XFile? pickedFile = await ImagePicker().pickImage(
      source: source,
    );
    if (pickedFile != null) {
      setState(() {
        _imageFile = File(pickedFile.path);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Image Uploader'),
        backgroundColor: primaryColor,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (_imageFile != null)
              SizedBox(height: 200, child: Image.file(_imageFile!)),
            const SizedBox(height: 16.0),
            ElevatedButton(
              onPressed: _selectImage,
              child: const Text('Select Image'),
            ),
            const SizedBox(height: 16.0),
            ElevatedButton(
              onPressed: _uploadImage,
              child: const Text('Upload Image'),
            ),
          ],
        ),
      ),
    );
  }
}
