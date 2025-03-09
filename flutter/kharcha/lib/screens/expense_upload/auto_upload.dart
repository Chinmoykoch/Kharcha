import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as path;

class AutoUploadScreen extends StatefulWidget {
  const AutoUploadScreen({super.key});

  @override
  _AutoUploadScreenState createState() => _AutoUploadScreenState();
}

class _AutoUploadScreenState extends State<AutoUploadScreen> {
  CameraController? _controller;
  Future<void>? _initializeControllerFuture;
  List<CameraDescription>? cameras;
  File? _selectedImage;
  final ImagePicker _picker = ImagePicker();

  @override
  void initState() {
    super.initState();
    _initializeCamera();
  }

  Future<void> _initializeCamera() async {
    try {
      cameras = await availableCameras();
      if (cameras != null && cameras!.isNotEmpty) {
        _controller = CameraController(
          cameras![0],
          ResolutionPreset.high,
          enableAudio: false,
        );
        _initializeControllerFuture = _controller!.initialize();
        setState(() {});
      } else {
        print("No cameras available");
      }
    } catch (e) {
      print("Error initializing camera: $e");
    }
  }

  @override
  void dispose() {
    _controller?.dispose();
    super.dispose();
  }

  Future<void> _takePicture() async {
    try {
      await _initializeControllerFuture;
      final directory = await getTemporaryDirectory();
      final imagePath = path.join(directory.path, '${DateTime.now()}.jpg');
      XFile image = await _controller!.takePicture();
      await image.saveTo(imagePath);

      setState(() {
        _selectedImage = File(imagePath);
      });

      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Photo saved to $imagePath')));
    } catch (e) {
      print("Error taking picture: $e");
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Error taking picture: $e')));
    }
  }

  Future<void> _pickImageFromGallery() async {
    final pickedFile = await _picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _selectedImage = File(pickedFile.path);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Expanded(
            child:
                _selectedImage != null
                    ? Image.file(
                      _selectedImage!,
                      fit: BoxFit.cover,
                      width: double.infinity,
                    )
                    : FutureBuilder<void>(
                      future: _initializeControllerFuture,
                      builder: (context, snapshot) {
                        if (snapshot.connectionState == ConnectionState.done) {
                          return _controller != null &&
                                  _controller!.value.isInitialized
                              ? CameraPreview(_controller!)
                              : const Center(
                                child: Text('Error initializing camera'),
                              );
                        } else {
                          return const Center(
                            child: CircularProgressIndicator(),
                          );
                        }
                      },
                    ),
          ),
          Padding(
            padding: const EdgeInsets.all(20.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                FloatingActionButton(
                  onPressed: _takePicture,
                  backgroundColor: Colors.white,
                  child: const Icon(Icons.camera_alt, color: Colors.black),
                ),
                const SizedBox(width: 20),
                FloatingActionButton(
                  onPressed: _pickImageFromGallery,
                  backgroundColor: Colors.white,
                  child: const Icon(Icons.photo_library, color: Colors.black),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
