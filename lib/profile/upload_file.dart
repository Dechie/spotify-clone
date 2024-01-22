import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:provider/provider.dart';
import 'package:spotify_clone/providers/song_upload.dart';
import '../constants.dart';
import '../models/user.dart';

class UploadNewScreen extends StatefulWidget {
  const UploadNewScreen({
    super.key,
    required this.user,
  });

  final User user;
  @override
  _UploadNewScreenState createState() => _UploadNewScreenState();
}

class _UploadNewScreenState extends State<UploadNewScreen> {
  File? selectedFile;
  TextEditingController titleController = TextEditingController();
  TextEditingController filePathController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  String songTitle = '';
  String selectedGenre = 'EDM';
  String filePath = '';
  var extension;

  String getFileExtension(String filePath) {
    String ext = filePath.split('.').last;
    print(ext);
    return ext;
  }

  Future<void> sendFormData(BuildContext context) async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();

      Map<String, dynamic> data = {
        "artist": widget.user.name,
        "title": songTitle,
        "genre": selectedGenre,
        "audio_file": await MultipartFile.fromFile(selectedFile!.path),
        "approved": false,
        "file_extension": extension,
        "release_date": '2023-12-12',
      };

      //Navigator.pop(context, user);
      bool success = false;
      String error = '';
      if (mounted) {
        (success, error) =
            await Provider.of<UploadProvider>(context, listen: false)
                .uploadNewSong(data, widget.user);
      }

      if (success) {
        if (mounted) {
          Navigator.pop(context);
        }
      } else {
        if (mounted) {
          showDialog(
            context: context,
            builder: (context) => AlertDialog(
              content: SizedBox(
                height: 400,
                width: 250,
                child: Column(
                  children: [
                    const Text('Failed to send data'),
                    Wrap(
                      children: [
                        Text(error),
                      ],
                    )
                  ],
                ),
              ),
            ),
          );
        }
      }
    }
  }

  Future<void> _pickAudioFile() async {
    try {
      FilePickerResult? result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['mp3', 'wav', 'aac'], // Add more if needed
        allowMultiple: false,
      );

      if (result != null) {
        setState(() {
          selectedFile = File(result.files.single.path!);
          extension = getFileExtension(selectedFile!.path);
        });

        // Show the selected file in a dialog
        _showSelectedFileDialog();
      }
    } catch (e) {
      print('Error picking audio file: $e');
    }
  }

  Future<void> _showSelectedFileDialog() async {
    return showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Selected File'),
          content: ListTile(
            title: Text(selectedFile!.path),
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                setState(() {
                  filePathController.text = selectedFile!.path;
                });
                Navigator.of(context).pop();
              },
              child: Text('OK'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    print('user has token? ${widget.user.token}');
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: ListView(
            children: [
              Row(
                children: [
                  IconButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    icon: Icon(
                      Icons.arrow_back,
                    ),
                  ),
                  const Spacer(),
                ],
              ),
              Form(
                key: _formKey,
                child: Column(
                  children: [
                    const SizedBox(height: 20),
                    Text('Upload Your work'),
                    const SizedBox(height: 40),
                    TextFormField(
                      controller: titleController,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(
                          borderSide:
                              const BorderSide(color: AppConstants.mainGreen),
                          borderRadius: BorderRadius.circular(14),
                        ),
                        label: const Text('Enter Title'),
                      ),
                      validator: (value) {
                        if (value == null ||
                            value.isEmpty ||
                            value.trim().length <= 1 ||
                            value.trim().length >= 50) {
                          return 'Please enter a title';
                        }
                        return null;
                      },
                      onSaved: (value) {
                        songTitle = value!;
                      },
                    ),
                    const SizedBox(height: 10),
                    TextFormField(
                      controller: filePathController,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(
                          borderSide:
                              const BorderSide(color: AppConstants.mainGreen),
                          borderRadius: BorderRadius.circular(14),
                        ),
                        label: const Text('enter file path'),
                      ),
                      validator: (value) {
                        if (filePathController.text.isNotEmpty) {
                          return null;
                        }
                        if (value == null ||
                            value.isEmpty ||
                            value.trim().length <= 1 ||
                            value.trim().length >= 50) {
                          return 'Please enter a file path';
                        }
                        return null;
                      },
                      onChanged: (value) {
                        filePath = value;
                      },
                      onSaved: (value) {
                        filePath = value!;
                      },
                    ),
                    const SizedBox(height: 10),
                    DropdownButtonFormField<String>(
                      value: "EDM",
                      items: ['EDM', 'Ethiopian', 'English'].map((genre) {
                        return DropdownMenuItem<String>(
                          value: genre,
                          child: Text(genre),
                        );
                      }).toList(),
                      onChanged: (String? value) {
                        setState(() {
                          selectedGenre = value!;
                        });
                      },
                      decoration: InputDecoration(
                        border: OutlineInputBorder(
                          borderSide:
                              const BorderSide(color: AppConstants.mainGreen),
                          borderRadius: BorderRadius.circular(14),
                        ),
                        label: const Text('Choose Genre'),
                      ),
                    ),
                    const SizedBox(height: 20),
                    ElevatedButton(
                      onPressed: _pickAudioFile,
                      child: Text('Browse Audio File'),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 30),
              SizedBox(
                height: 40,
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    sendFormData(context);
                  },
                  child: Text('Sumit'),
                ),
                // child: DecoratedBox(
                //   decoration: BoxDecoration(
                //     color: AppConstants.mainGreen,
                //   ),
                //   child: Text('Submit'),
                // ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
