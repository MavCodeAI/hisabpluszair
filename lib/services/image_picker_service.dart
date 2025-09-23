import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';

class ImagePickerService {
  static final ImagePicker _picker = ImagePicker();

  static Future<String?> pickImage({
    ImageSource source = ImageSource.gallery,
    int imageQuality = 85,
  }) async {
    try {
      // Request permissions
      if (source == ImageSource.camera) {
        final cameraStatus = await Permission.camera.request();
        if (!cameraStatus.isGranted) {
          throw Exception('Camera permission denied');
        }
      } else {
        final storageStatus = await Permission.storage.request();
        if (!storageStatus.isGranted) {
          throw Exception('Storage permission denied');
        }
      }

      // Pick image
      final XFile? image = await _picker.pickImage(
        source: source,
        imageQuality: imageQuality,
        maxWidth: 1920,
        maxHeight: 1080,
      );

      if (image == null) return null;

      // Save image to app directory
      final String savedPath = await _saveImageToAppDirectory(image);
      return savedPath;
    } catch (e) {
      debugPrint('Error picking image: $e');
      rethrow;
    }
  }

  static Future<List<String>> pickMultipleImages({
    int imageQuality = 85,
    int? maxImages,
  }) async {
    try {
      // Request storage permission
      final storageStatus = await Permission.storage.request();
      if (!storageStatus.isGranted) {
        throw Exception('Storage permission denied');
      }

      // Pick multiple images
      final List<XFile> images = await _picker.pickMultiImage(
        imageQuality: imageQuality,
        maxWidth: 1920,
        maxHeight: 1080,
      );

      if (images.isEmpty) return [];

      // Limit number of images if specified
      final List<XFile> limitedImages = maxImages != null 
          ? images.take(maxImages).toList() 
          : images;

      // Save all images
      final List<String> savedPaths = [];
      for (final image in limitedImages) {
        final String savedPath = await _saveImageToAppDirectory(image);
        savedPaths.add(savedPath);
      }

      return savedPaths;
    } catch (e) {
      debugPrint('Error picking multiple images: $e');
      rethrow;
    }
  }

  static Future<String> _saveImageToAppDirectory(XFile image) async {
    try {
      final Directory appDir = await getApplicationDocumentsDirectory();
      final String imagesDir = '${appDir.path}/images';
      
      // Create images directory if it doesn't exist
      await Directory(imagesDir).create(recursive: true);

      // Generate unique filename
      final String timestamp = DateTime.now().millisecondsSinceEpoch.toString();
      final String extension = image.path.split('.').last;
      final String fileName = 'img_${timestamp}.$extension';
      final String savedPath = '$imagesDir/$fileName';

      // Copy file to app directory
      final File sourceFile = File(image.path);
      await sourceFile.copy(savedPath);

      return savedPath;
    } catch (e) {
      debugPrint('Error saving image: $e');
      rethrow;
    }
  }

  static Future<bool> deleteImage(String imagePath) async {
    try {
      final File imageFile = File(imagePath);
      if (await imageFile.exists()) {
        await imageFile.delete();
        return true;
      }
      return false;
    } catch (e) {
      debugPrint('Error deleting image: $e');
      return false;
    }
  }

  static Future<List<String>> getAllSavedImages() async {
    try {
      final Directory appDir = await getApplicationDocumentsDirectory();
      final String imagesDir = '${appDir.path}/images';
      final Directory imageDirectory = Directory(imagesDir);
      
      if (!await imageDirectory.exists()) {
        return [];
      }

      final List<FileSystemEntity> files = await imageDirectory.list().toList();
      final List<String> imagePaths = files
          .where((file) => file is File)
          .map((file) => file.path)
          .where((path) => _isImageFile(path))
          .toList();

      // Sort by creation time (newest first)
      imagePaths.sort((a, b) {
        final FileSystemEntity fileA = File(a);
        final FileSystemEntity fileB = File(b);
        return fileB.statSync().modified.compareTo(fileA.statSync().modified);
      });

      return imagePaths;
    } catch (e) {
      debugPrint('Error getting saved images: $e');
      return [];
    }
  }

  static bool _isImageFile(String path) {
    final String extension = path.split('.').last.toLowerCase();
    return ['jpg', 'jpeg', 'png', 'gif', 'webp'].contains(extension);
  }

  static Future<int> getImageCount() async {
    final images = await getAllSavedImages();
    return images.length;
  }

  static Future<double> getImagesFolderSize() async {
    try {
      final images = await getAllSavedImages();
      double totalSize = 0;
      
      for (final imagePath in images) {
        final file = File(imagePath);
        if (await file.exists()) {
          final size = await file.length();
          totalSize += size;
        }
      }
      
      // Return size in MB
      return totalSize / (1024 * 1024);
    } catch (e) {
      debugPrint('Error calculating folder size: $e');
      return 0;
    }
  }

  static Future<void> clearAllImages() async {
    try {
      final images = await getAllSavedImages();
      for (final imagePath in images) {
        await deleteImage(imagePath);
      }
    } catch (e) {
      debugPrint('Error clearing images: $e');
    }
  }

  static String getImageDisplayName(String imagePath) {
    final fileName = imagePath.split('/').last;
    return fileName.replaceAll(RegExp(r'img_\d+\.'), '');
  }

  static Future<void> showImagePickerBottomSheet(
    BuildContext context, {
    required Function(String) onImageSelected,
    bool allowMultiple = false,
  }) async {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                leading: const Icon(Icons.photo_camera),
                title: const Text('Take Photo'),
                onTap: () async {
                  Navigator.pop(context);
                  try {
                    final imagePath = await pickImage(source: ImageSource.camera);
                    if (imagePath != null) {
                      onImageSelected(imagePath);
                    }
                  } catch (e) {
                    if (context.mounted) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('Error: $e')),
                      );
                    }
                  }
                },
              ),
              ListTile(
                leading: const Icon(Icons.photo_library),
                title: Text(allowMultiple ? 'Choose from Gallery' : 'Choose Photo'),
                onTap: () async {
                  Navigator.pop(context);
                  try {
                    if (allowMultiple) {
                      final imagePaths = await pickMultipleImages(maxImages: 5);
                      for (final path in imagePaths) {
                        onImageSelected(path);
                      }
                    } else {
                      final imagePath = await pickImage(source: ImageSource.gallery);
                      if (imagePath != null) {
                        onImageSelected(imagePath);
                      }
                    }
                  } catch (e) {
                    if (context.mounted) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('Error: $e')),
                      );
                    }
                  }
                },
              ),
              if (!allowMultiple)
                ListTile(
                  leading: const Icon(Icons.cancel),
                  title: const Text('Cancel'),
                  onTap: () => Navigator.pop(context),
                ),
            ],
          ),
        );
      },
    );
  }
}