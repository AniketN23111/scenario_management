import 'dart:typed_data';

import '../constants/response.dart';

abstract class DataService {
  Future<Response> uploadFile(Uint8List? fileBytes, String? fileName);
}
