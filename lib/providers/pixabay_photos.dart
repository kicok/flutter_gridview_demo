import 'dart:async';
import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

const String pixaBayKey = "17368288-b20c3369024b51a2e1df52944";
const String baseUrl = "https://pixabay.com/api";

// ignore: empty_constructor_bodies
class PixabayPhotoItem {
  late final int? id;
  late final String user;
  late final int? views;
  late final int? downloads;
  late final int? likes;
  late final int? webformatHeight;
  late final int? webformatWidth;
  late final String webformatURL;

  PixabayPhotoItem({
    required this.id,
    required this.user,
    required this.views,
    required this.downloads,
    required this.likes,
    required this.webformatHeight,
    required this.webformatWidth,
    required this.webformatURL,
  });

  PixabayPhotoItem.fromJson(json) {
    id = json['id'];
    user = json['user'];
    views = json['views'];
    downloads = json['downloads'];
    likes = json['likes'];
    webformatHeight = json['webformatHeight'];
    webformatWidth = json['webformatWidth'];
    webformatURL = json['webformatURL'];
  }
}

class PixabayPhotos with ChangeNotifier {
  final String url =
      '$baseUrl/?key=$pixaBayKey&q=yellow+flowers&image_type=photo';

  final List<PixabayPhotoItem> _photos = [];

  List<PixabayPhotoItem> get photos {
    return [..._photos];
  }

  Future<void> getPixabayPhotos(int page, int perPage) async {
    try {
      final response =
          await http.get(Uri.parse("$url&page=$page&per_page=$perPage"));

      final items = json.decode(response.body)['hits'];
      items.forEach((item) {
        final newPhoto = PixabayPhotoItem.fromJson(item);
        _photos.add(newPhoto);
      });

      notifyListeners();
    } catch (error) {
      // print(error);
      rethrow;
    }
  }
}
