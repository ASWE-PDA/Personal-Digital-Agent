import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:luna/UseCases/news/news_use_case.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  SharedPreferences.setMockInitialValues({});
  group("use case", () {
    test("delete preferences", () async {
      SharedPreferences.setMockInitialValues({"preferences": "Test"});
      await NewsUseCase.instance.deletePreferences();
      SharedPreferences sharedPreferences =
          await SharedPreferences.getInstance();
      var preferences = sharedPreferences.getStringList("preferences");
      expect(preferences, []);
    });
  });
}
