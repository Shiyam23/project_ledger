import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';
import 'package:archive/archive_io.dart';
import 'package:crypto/crypto.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart';
import 'package:hive/hive.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';
import '../components/LoadingDialog.dart';
import 'package:convert/convert.dart';

import 'HiveDatabase.dart';


Future<void> createBackup(LoadingProgress progress) async {
  Directory documentsDirectory = await getApplicationDocumentsDirectory();
  String tempPath = (await getTemporaryDirectory()).path;
  List<File> backupFiles = [];
  documentsDirectory.listSync()
    .where((element) => element.path.endsWith("hive"))
    .map((element) => File(element.path))
    .forEach(backupFiles.add);
  ZipFileEncoder encoder = ZipFileEncoder();
  String backupFileName = join(tempPath, "backup.zip");
  encoder.create(backupFileName);
  backupFiles.sort((f1,f2) => basename(f1.path).compareTo(basename(f2.path)));
  AccumulatorSink<Digest> output = AccumulatorSink<Digest>();
  ByteConversionSink input = sha256.startChunkedConversion(output);
  int backupFileNum = backupFiles.length;
  progress.initialize(backupFileNum + 1);
  for(int i = 0; i < backupFileNum; i++) {
    File file = backupFiles[i];
    encoder.addFile(file);
    Uint8List bytes = file.readAsBytesSync();
    input.add(bytes);    
    progress.update(basenameWithoutExtension(file.path), i + 1);
  }
  String checkSumPath = join(tempPath,"backup.checksum");
  File checksumFile = File(checkSumPath);
  input.close();
  Digest digest = output.events.single;
  checksumFile.writeAsBytesSync(digest.bytes);
  encoder.addFile(checksumFile);
  encoder.close();
  progress.update('checksum', backupFileNum + 1);
  Share.shareFiles([backupFileName]);
}

Future<String?> openFile(LoadingProgress progress) async {
  FilePickerResult? result = await FilePicker.platform.pickFiles(
    allowMultiple: false,
    allowedExtensions: ['zip'],
    type: FileType.custom,
  );
  return result?.files.single.path;
}

Future<List<File>?> checksum(String backupFilePath, LoadingProgress progress) async {
  File backupFile = File(backupFilePath);
  Uint8List bytes = backupFile.readAsBytesSync();
  Archive archive = ZipDecoder().decodeBytes(bytes);
  Directory backupFolder = Directory(join(backupFile.parent.path, 'backup/'));
  if (backupFolder.existsSync()) backupFolder.deleteSync(recursive: true);
  backupFolder.createSync();
  for (ArchiveFile archiveFile in archive) {
    File file = File(join(backupFolder.path, archiveFile.name));
    if (!file.existsSync()) file.createSync();
    file.writeAsBytesSync(archiveFile.content);
  }
  List<File> backupFiles = backupFolder.listSync()
    .map((file) => File(file.path)).toList();
  File checksumFile;
  try {
    checksumFile = backupFiles
      .singleWhere((file) => basename(file.path) == 'backup.checksum');
  } on StateError {
    return null;
  }
  backupFiles.remove(checksumFile);
  backupFiles.sort((f1,f2) => basename(f1.path).compareTo(basename(f2.path)));
  AccumulatorSink<Digest> output = AccumulatorSink<Digest>();
  ByteConversionSink input = sha256.startChunkedConversion(output);
  int backupFileNum = backupFiles.length;
  progress.initialize(backupFileNum + 1);
  for(int i = 0; i < backupFileNum; i++) {
    File file = backupFiles[i];
    Uint8List bytes = file.readAsBytesSync();
    input.add(bytes);    
    progress.update(basenameWithoutExtension(file.path), i + 1);
  }
  input.close();
  Digest digest = output.events.single;
  bool backupIsValid = listEquals(digest.bytes, checksumFile.readAsBytesSync());
  if (backupIsValid) {
    return backupFiles;
  } else {
    return null;
  }
}

Future<void> copyBackupFiles(LoadingProgress progress, List<File> backupFiles) async {
  progress.reset();
  await Hive.close();
  final appDocumentDir = await getApplicationDocumentsDirectory();
  List<File> originalFiles = appDocumentDir
    .listSync()
    .map((f) => File(f.path))
    .toList();
  for (File file in originalFiles) file.deleteSync();
  for (File file in backupFiles) {
    file.copySync(join(appDocumentDir.path, basename(file.path)));
  }
  HiveDatabase().reset();
}