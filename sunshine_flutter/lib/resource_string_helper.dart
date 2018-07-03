import 'package:xml/xml.dart' as xml;
import 'package:flutter/services.dart' show rootBundle;
import 'dart:async';
import 'dart:collection';

class ResourceStringHelper {
  Future<String> _resource;
  HashMap stringMap = HashMap();

  ResourceStringHelper() {
    if (_resource != null)
      return;

    _resource = getFileData("assets/strings.xml");
    _resource.then((res) {
      var document = xml.parse(res);
      var elements = document.findAllElements("string");
      for (xml.XmlElement element in elements) {
        stringMap[element.getAttribute("name")] = element.text;
      }
    });
  }

  Future<String> getFuture() {
    return _resource;
  }
  


  String getString(String resourceToFind) {
    if (stringMap != null) {
      var value = stringMap[resourceToFind];
      return value;
    }
    return null;
  }

  Future<String> getFileData(String path) async {
    return await rootBundle.loadString(path);
  }
}
