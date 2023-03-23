import 'dart:convert';
import 'dart:io';
import 'dart:ui';

import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class PrefUtil {
	static late final SharedPreferences preferences;
	static bool _init = false;
	static Future init() async {
		if (_init) return;
		preferences = await SharedPreferences.getInstance();
		_init = true;
		return preferences;
	}

	static setValue(String key, Object value) {
		switch (value.runtimeType) {
			case List<String>:
				preferences.setStringList(key, value as List<String>);
				break;
			case String:
				preferences.setString(key, value as String);
				break;
			case bool:
				preferences.setBool(key, value as bool);
				break;
			case int:
				preferences.setInt(key, value as int);
				break;
			default:
		}
	}

	static Object getValue(String key, Object defaultValue) {
		switch (defaultValue.runtimeType) {
			case List:
				return preferences.getStringList(key) ?? defaultValue;
			case String:
				return preferences.getString(key) ?? defaultValue;
			case bool:
				return preferences.getBool(key) ?? defaultValue;
			case int:
				return preferences.getInt(key) ?? defaultValue;
			default:
				return defaultValue;
		}
	}
}

class StorageUtil {
	static late final Directory directory;
	static late final String path;
	static bool _init = false;
	static Future init() async {
		if(_init) return;
		_init = true;
		directory = await getApplicationDocumentsDirectory();
		path = directory.path;
	}

	static File getFile(String fileName) => File("$path/$fileName");

	static File writeString(String fileName, String content) {
		getFile(fileName).writeAsStringSync(content, mode: FileMode.write, encoding: utf8);
		return getFile(fileName);
	}

	static String readString(String fileName, String defaultValue) {
		try {
			return getFile(fileName).readAsStringSync();
		} catch (e) {
			return defaultValue;
		}
	}
}