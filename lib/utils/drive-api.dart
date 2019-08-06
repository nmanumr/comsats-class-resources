import 'package:googleapis/drive/v3.dart';
import 'package:googleapis_auth/auth_io.dart';
import 'dart:async' show Future;
import 'package:flutter/services.dart' show rootBundle;

class GoogleCredientialsLoader {
  final String path;

  GoogleCredientialsLoader({this.path});
  Future<ServiceAccountCredentials> load() async {
    var json = await rootBundle.loadString(this.path);
    return ServiceAccountCredentials.fromJson(json);
  }
}

class GoogleDriveApiLoader {
  Future<DriveApi> load() async {
    var credientials =
        await GoogleCredientialsLoader(path: "assets/credientials.json").load();
    const _SCOPES = const [DriveApi.DriveReadonlyScope];
    var client = await clientViaServiceAccount(credientials, _SCOPES);
    return DriveApi(client);
  }
}
