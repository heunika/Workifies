import 'dart:io';
import 'dart:typed_data';
import 'package:file_picker/file_picker.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';

class FileService {
  static final FirebaseStorage _storage = FirebaseStorage.instance;
  static final ImagePicker _imagePicker = ImagePicker();

  // Image picking
  static Future<File?> pickImageFromGallery() async {
    try {
      final XFile? image = await _imagePicker.pickImage(
        source: ImageSource.gallery,
        maxWidth: 1920,
        maxHeight: 1080,
        imageQuality: 85,
      );

      return image != null ? File(image.path) : null;
    } catch (e) {
      rethrow;
    }
  }

  static Future<File?> pickImageFromCamera() async {
    try {
      final XFile? image = await _imagePicker.pickImage(
        source: ImageSource.camera,
        maxWidth: 1920,
        maxHeight: 1080,
        imageQuality: 85,
      );

      return image != null ? File(image.path) : null;
    } catch (e) {
      rethrow;
    }
  }

  // File picking
  static Future<File?> pickFile({
    List<String>? allowedExtensions,
    FileType type = FileType.any,
  }) async {
    try {
      FilePickerResult? result = await FilePicker.platform.pickFiles(
        type: type,
        allowedExtensions: allowedExtensions,
        allowMultiple: false,
      );

      if (result != null && result.files.single.path != null) {
        return File(result.files.single.path!);
      }

      return null;
    } catch (e) {
      rethrow;
    }
  }

  static Future<List<File>> pickMultipleFiles({
    List<String>? allowedExtensions,
    FileType type = FileType.any,
  }) async {
    try {
      FilePickerResult? result = await FilePicker.platform.pickFiles(
        type: type,
        allowedExtensions: allowedExtensions,
        allowMultiple: true,
      );

      if (result != null) {
        return result.paths
            .where((path) => path != null)
            .map((path) => File(path!))
            .toList();
      }

      return [];
    } catch (e) {
      rethrow;
    }
  }

  // Firebase Storage upload
  static Future<String> uploadFile({
    required File file,
    required String path,
    String? fileName,
    Function(double)? onProgress,
  }) async {
    try {
      final String name = fileName ?? file.path.split('/').last;
      final Reference ref = _storage.ref().child('$path/$name');

      final UploadTask uploadTask = ref.putFile(file);

      // Listen to upload progress
      if (onProgress != null) {
        uploadTask.snapshotEvents.listen((TaskSnapshot snapshot) {
          final progress = snapshot.bytesTransferred / snapshot.totalBytes;
          onProgress(progress);
        });
      }

      final TaskSnapshot snapshot = await uploadTask;
      final String downloadUrl = await snapshot.ref.getDownloadURL();

      return downloadUrl;
    } catch (e) {
      rethrow;
    }
  }

  static Future<String> uploadData({
    required Uint8List data,
    required String path,
    required String fileName,
    String? contentType,
    Function(double)? onProgress,
  }) async {
    try {
      final Reference ref = _storage.ref().child('$path/$fileName');

      final SettableMetadata metadata = SettableMetadata(
        contentType: contentType,
      );

      final UploadTask uploadTask = ref.putData(data, metadata);

      // Listen to upload progress
      if (onProgress != null) {
        uploadTask.snapshotEvents.listen((TaskSnapshot snapshot) {
          final progress = snapshot.bytesTransferred / snapshot.totalBytes;
          onProgress(progress);
        });
      }

      final TaskSnapshot snapshot = await uploadTask;
      final String downloadUrl = await snapshot.ref.getDownloadURL();

      return downloadUrl;
    } catch (e) {
      rethrow;
    }
  }

  // Firebase Storage download
  static Future<File> downloadFile({
    required String url,
    required String fileName,
    Function(double)? onProgress,
  }) async {
    try {
      final Directory appDir = await getApplicationDocumentsDirectory();
      final String filePath = '${appDir.path}/$fileName';
      final File file = File(filePath);

      final Reference ref = _storage.refFromURL(url);

      final DownloadTask downloadTask = ref.writeToFile(file);

      // Listen to download progress
      if (onProgress != null) {
        downloadTask.snapshotEvents.listen((TaskSnapshot snapshot) {
          final progress = snapshot.bytesTransferred / snapshot.totalBytes;
          onProgress(progress);
        });
      }

      await downloadTask;
      return file;
    } catch (e) {
      rethrow;
    }
  }

  static Future<Uint8List> downloadData({
    required String url,
    Function(double)? onProgress,
  }) async {
    try {
      final Reference ref = _storage.refFromURL(url);
      final Uint8List? data = await ref.getData();

      if (data == null) {
        throw Exception('Failed to download file data');
      }

      return data;
    } catch (e) {
      rethrow;
    }
  }

  // File operations
  static Future<void> deleteFile(String url) async {
    try {
      final Reference ref = _storage.refFromURL(url);
      await ref.delete();
    } catch (e) {
      rethrow;
    }
  }

  static Future<bool> checkFileExists(String url) async {
    try {
      final Reference ref = _storage.refFromURL(url);
      await ref.getMetadata();
      return true;
    } catch (e) {
      return false;
    }
  }

  static Future<FullMetadata> getFileMetadata(String url) async {
    try {
      final Reference ref = _storage.refFromURL(url);
      return await ref.getMetadata();
    } catch (e) {
      rethrow;
    }
  }

  // Utility functions
  static String getFileExtension(String fileName) {
    return fileName.split('.').last.toLowerCase();
  }

  static String getFileSize(int bytes) {
    if (bytes < 1024) return '$bytes B';
    if (bytes < 1024 * 1024) return '${(bytes / 1024).toStringAsFixed(1)} KB';
    if (bytes < 1024 * 1024 * 1024) {
      return '${(bytes / (1024 * 1024)).toStringAsFixed(1)} MB';
    }
    return '${(bytes / (1024 * 1024 * 1024)).toStringAsFixed(1)} GB';
  }

  static bool isImageFile(String fileName) {
    final extension = getFileExtension(fileName);
    return ['jpg', 'jpeg', 'png', 'gif', 'bmp', 'webp'].contains(extension);
  }

  static bool isVideoFile(String fileName) {
    final extension = getFileExtension(fileName);
    return ['mp4', 'avi', 'mov', 'wmv', 'flv', 'webm', 'mkv'].contains(extension);
  }

  static bool isDocumentFile(String fileName) {
    final extension = getFileExtension(fileName);
    return ['pdf', 'doc', 'docx', 'txt', 'rtf', 'odt'].contains(extension);
  }

  static bool isSpreadsheetFile(String fileName) {
    final extension = getFileExtension(fileName);
    return ['xls', 'xlsx', 'csv', 'ods'].contains(extension);
  }

  static bool isPresentationFile(String fileName) {
    final extension = getFileExtension(fileName);
    return ['ppt', 'pptx', 'odp'].contains(extension);
  }

  // Permission helpers
  static Future<bool> requestStoragePermission() async {
    final permission = await Permission.storage.request();
    return permission.isGranted;
  }

  static Future<bool> requestCameraPermission() async {
    final permission = await Permission.camera.request();
    return permission.isGranted;
  }

  static Future<bool> requestPhotosPermission() async {
    final permission = await Permission.photos.request();
    return permission.isGranted;
  }

  // Save file to device
  static Future<File?> saveToDevice({
    required Uint8List data,
    required String fileName,
  }) async {
    try {
      // Request storage permission
      final hasPermission = await requestStoragePermission();
      if (!hasPermission) {
        throw Exception('Storage permission denied');
      }

      final Directory? directory = await getExternalStorageDirectory();
      if (directory == null) {
        throw Exception('Unable to access storage');
      }

      final String filePath = '${directory.path}/$fileName';
      final File file = File(filePath);

      await file.writeAsBytes(data);
      return file;
    } catch (e) {
      rethrow;
    }
  }

  // Chat file upload helpers
  static Future<String> uploadChatImage({
    required File image,
    required String conversationId,
    Function(double)? onProgress,
  }) async {
    final fileName = 'image_${DateTime.now().millisecondsSinceEpoch}.jpg';
    return await uploadFile(
      file: image,
      path: 'chat/$conversationId/images',
      fileName: fileName,
      onProgress: onProgress,
    );
  }

  static Future<String> uploadChatFile({
    required File file,
    required String conversationId,
    Function(double)? onProgress,
  }) async {
    final fileName = '${DateTime.now().millisecondsSinceEpoch}_${file.path.split('/').last}';
    return await uploadFile(
      file: file,
      path: 'chat/$conversationId/files',
      fileName: fileName,
      onProgress: onProgress,
    );
  }

  // Profile image upload
  static Future<String> uploadProfileImage({
    required File image,
    required String userId,
    Function(double)? onProgress,
  }) async {
    final fileName = 'profile_$userId.jpg';
    return await uploadFile(
      file: image,
      path: 'profiles',
      fileName: fileName,
      onProgress: onProgress,
    );
  }

  // Company logo upload
  static Future<String> uploadCompanyLogo({
    required File image,
    required String companyId,
    Function(double)? onProgress,
  }) async {
    final fileName = 'logo_$companyId.jpg';
    return await uploadFile(
      file: image,
      path: 'companies',
      fileName: fileName,
      onProgress: onProgress,
    );
  }
}