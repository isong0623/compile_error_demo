import 'dart:io';

import 'package:device_info/device_info.dart';
import 'package:flutter/foundation.dart';
import 'package:package_info/package_info.dart';
import 'package:path_provider/path_provider.dart';

class PlatformHelper{
  static void _(){}

  PlatformHelper(
      this.doOnAndroid,
      this.doOnIOS,
      [
        this.doOnWeb     =_,
        this.doOnLinux   =_,
        this.doOnWindows =_,
        this.doOnFuchsia =_,
        this.doOnMacOS   =_,
        this.doOnOther   =_
      ]
  );

  @protected final dynamic Function() doOnAndroid;
  @protected final dynamic Function() doOnIOS;
  @protected final dynamic Function() doOnWeb;
  @protected final dynamic Function() doOnWindows;
  @protected final dynamic Function() doOnLinux;
  @protected final dynamic Function() doOnMacOS;
  @protected final dynamic Function() doOnFuchsia;
  @protected final dynamic Function() doOnOther;
  dynamic exec(){
    if(kIsWeb)                  return doOnWeb();
    else if(Platform.isAndroid) return doOnAndroid();
    else if(Platform.isIOS)     return doOnIOS();
    else if(Platform.isWindows) return doOnWindows();
    else if(Platform.isLinux)   return doOnLinux();
    else if(Platform.isMacOS)   return doOnMacOS();
    else if(Platform.isFuchsia) return doOnFuchsia();
    else                        return doOnOther();
  }

  // ignore: non_constant_identifier_names
  static String _Dir_Path;
  static Future<String> getDirPath() async =>  _Dir_Path ??= (await getExternalStorageDirectory()).path;

  static PackageInfo _packageInfo;
  static bool _bPackageInfoLocker = false;
  static Future<PackageInfo> getPackageInfo () async {
    if(_packageInfo==null){
      if(_bPackageInfoLocker){
       return await Future.delayed(Duration(milliseconds: 300),()=>getPackageInfo());
      }
      _bPackageInfoLocker = true;
      _packageInfo = await PackageInfo.fromPlatform();
      _bPackageInfoLocker = false;
    }
    return _packageInfo;
  }

  static Future<String> appName() async => (await getPackageInfo ()).appName;
  static Future<String> packageName() async => (await getPackageInfo ()).packageName;
  static Future<String> version() async => (await getPackageInfo ()).version;
  static Future<String> buildNumber() async => (await getPackageInfo ()).buildNumber;

  static DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();

  static Future getDeviceInfo() async {
    if(Platform.isIOS){
      return deviceInfo.iosInfo;
    }else if(Platform.isAndroid){
      return deviceInfo.androidInfo;
    }
  }

}