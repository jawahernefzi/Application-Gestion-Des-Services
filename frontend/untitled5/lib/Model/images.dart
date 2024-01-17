
import 'dart:convert';
import 'dart:typed_data';


class Images {
  int? id;
  String? name;
  String? type;
  String? imagePath; // Change this field to match Spring class
  Uint8List? url; // Change this field to match Spring class
  Images({this.url, this.imagePath});


  Images.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    type = json['type'];
    imagePath = json['imagePath'];
    if (json['url'] != null) {
      url = Uint8List.fromList(base64.decode(json['url']));
    }
  }
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['type'] = this.type;
    data['imagePath'] = this.imagePath;
    data['url'] =
        base64.encode(this.url!); // Encode the Uint8List as a base64 string

    return data;
  }
}