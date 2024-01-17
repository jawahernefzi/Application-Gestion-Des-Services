import 'dart:convert';
import 'package:http/http.dart' as http;

import '../../Services/env.dart';

class Category {
  int? id;
  String? name;

  @override
  String toString() {
    return 'Category{id: $id, name: $name}';
  }

  Category( {this.id, this.name});
  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is Category && id == other.id && name == other.name;
  }

  // Add this hashcode override
  @override
  int get hashCode => id.hashCode ^ name.hashCode;

  Category.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    return data;
  }
}
Future<List<Category>> fetchCategories() async {
  final response = await http.get(Uri.parse(VPNURL+'api/categories'),
      headers: {
  'Content-Type': 'application/json; charset=utf-8'
  },);

  if (response.statusCode == 200) {
    final List<dynamic> data = json.decode(utf8.decode(response.bodyBytes));

    List<Category> categories = data.map((category) => Category.fromJson(category)).toList();
 return categories;
  } else {
    throw Exception('Failed to load categories');
  }
}




