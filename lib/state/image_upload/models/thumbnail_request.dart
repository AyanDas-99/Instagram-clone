import 'dart:io';
import 'package:flutter/foundation.dart' show immutable;
import 'package:instagram_clone/state/image_upload/models/file_type.dart';

@immutable
class ThumbnailRequest {
  final File file;
  final FileType fileType;
  const ThumbnailRequest({
    required this.file,
    required this.fileType,
  });

  @override
  operator ==(Object other) =>
      identical(this, other) ||
      other is ThumbnailRequest &&
          runtimeType == other.runtimeType &&
          file == other.file &&
          fileType == other.fileType;

  @override
  // TODO: implement hashCode
  int get hashCode => Object.hashAll([
        file,
        fileType,
        runtimeType,
      ]);
}
