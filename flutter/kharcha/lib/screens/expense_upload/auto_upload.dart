import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'package:image_picker/image_picker.dart';
import 'package:kharcha/screens/expense_upload/expense_table.dart';
import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as path;
import 'package:http/http.dart' as http;
import 'dart:convert';

class AutoUploadScreen extends StatefulWidget {
  const AutoUploadScreen({super.key});

  @override
  _AutoUploadScreenState createState() => _AutoUploadScreenState();
}

class _AutoUploadScreenState extends State<AutoUploadScreen> {
  CameraController? _controller;
  Future<void>? _initializeControllerFuture;
  List<CameraDescription>? cameras;
  String? _uploadedImageUrl;
  File? _selectedImage;
  final ImagePicker _picker = ImagePicker();

  final String cloudinaryUrl =
      "https://api.cloudinary.com/v1_1/dqcp6wx8m/upload";
  final String cloudinaryPreset = "kharcha";

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
        debugPrint("No cameras available");
      }
    } catch (e) {
      debugPrint("Error initializing camera: $e");
    }
  }

  @override
  void dispose() {
    _controller?.dispose();
    super.dispose();
  }

  Future<void> _handleImage(File imageFile) async {
    setState(() {
      _selectedImage = imageFile;
      _uploadedImageUrl = null;
    });

    ScaffoldMessenger.of(
      context,
    ).showSnackBar(const SnackBar(content: Text('Uploading ...')));

    String? imageUrl = await _uploadImageToCloudinary(imageFile);

    if (imageUrl != null) {
      setState(() {
        _uploadedImageUrl = imageUrl;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Image uploaded successfully!')),
      );

      await _sendImageToBackend(imageUrl);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Upload to Cloudinary failed')),
      );
    }
  }

  Future<void> _sendImageToBackend(String imageUrl) async {
    const String backendUrl =
        "https://8f77-2401-4900-3d39-799c-60da-111a-b997-8372.ngrok-free.app/api/v1/transaction/addrecipt";

    try {
      var response = await http.post(
        Uri.parse(backendUrl),
        headers: {"Content-Type": "application/json"},
        body: json.encode({"imageUrl": imageUrl}),
      );

      if (response.statusCode == 200) {
        var jsonResponse = json.decode(response.body);
        debugPrint("Backend Response: $jsonResponse");

        // Navigate to ResponseTableScreen with jsonResponse
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ExpenseTable(responseData: jsonResponse),
          ),
        );

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Backend response: ${jsonResponse}')),
        );
      } else {
        debugPrint("Backend Upload Failed: ${response.body}");
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Failed to send image to backend')),
        );
      }
    } catch (e) {
      debugPrint("Error sending to backend: $e");
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Error: $e')));
    }
  }

  Future<void> _takePicture() async {
    if (_controller == null || !_controller!.value.isInitialized) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Camera not initialized')));
      return;
    }

    try {
      await _initializeControllerFuture;
      final directory = await getTemporaryDirectory();
      final imagePath = path.join(directory.path, '${DateTime.now()}.jpg');
      XFile image = await _controller!.takePicture();
      await image.saveTo(imagePath);
      await _handleImage(File(imagePath));
    } catch (e) {
      debugPrint("Error taking picture: $e");
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Error taking picture: $e')));
    }
  }

  Future<void> _uploadSelectedImage() async {
    if (_selectedImage == null) return;

    ScaffoldMessenger.of(
      context,
    ).showSnackBar(const SnackBar(content: Text('Uploading to Cloudinary...')));

    String? imageUrl = await _uploadImageToCloudinary(_selectedImage!);
    if (imageUrl != null) {
      setState(() {
        _uploadedImageUrl = imageUrl;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Uploaded Successfully: $imageUrl')),
      );
    } else {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Upload Failed')));
    }
  }

  Future<void> _pickImageFromGallery() async {
    final pickedFile = await _picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      await _handleImage(File(pickedFile.path));
    }
  }

  Future<String?> _uploadImageToCloudinary(File imageFile) async {
    try {
      var request = http.MultipartRequest('POST', Uri.parse(cloudinaryUrl));
      request.fields['upload_preset'] = cloudinaryPreset;
      request.files.add(
        await http.MultipartFile.fromPath('file', imageFile.path),
      );

      var streamedResponse = await request.send();
      var response = await http.Response.fromStream(streamedResponse);

      if (response.statusCode == 200) {
        var jsonResponse = json.decode(response.body);
        return jsonResponse['secure_url'];
      } else {
        debugPrint("Upload failed: ${response.body}");
        return null;
      }
    } catch (e) {
      debugPrint("Error uploading image: $e");
      return null;
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
                    ? Image.file(_selectedImage!, width: double.infinity)
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
                const SizedBox(width: 20),
                if (_selectedImage != null && _uploadedImageUrl == null)
                  ElevatedButton(
                    onPressed: _uploadSelectedImage,
                    child: const Text("Upload"),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
