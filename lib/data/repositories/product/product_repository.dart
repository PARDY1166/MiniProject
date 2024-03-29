import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';

import '../../../features/shop/models/product_model.dart';

class ProductRepository extends GetxController {
  static ProductRepository get instance => Get.find();

  //firestore instance for database interaction
  final _db = FirebaseFirestore.instance;

  //get limited featured products

//upload  dummy data  to the cloud firebase
  /// Upload dummy data to the Cloud Firebase
  Future<void> uploadDummyData(List<ProductModel> products) async {
    try {
      // Upload all the products along with their images
      final storage = Get.put(TFirebaseStorageService());
      // Loop through each product
      for (var product in products) {
        // Get image data link from local assets
        final thumbnail = await storage.getImageDataFromAssets(product.thumbnail);
        // Upload image and get its URL
        final url = await storage.uploadImageData('Products/Images', thumbnail, product.thumbnail.toString());
        // Assign URL to product.thumbnail attribute
        product.thumbnail = url;
        // Product list of images
        if (product.images != null && product.images!.isNotEmpty) {
          List<String> imagesUrl = [];
          for (var image in product.images!) {
            // Get image data link from local assets
            final assetImage = await storage.getImageDataFromAssets(image);
            // Upload image and get its URL
            final url = await storage.uploadImageData('Products/Images', assetImage, image);
            // Assign URL to product.thumbnail attribute
            imagesUrl.add(url);
          }
          product.images!.clear();
          // Add uploaded image URLs to product.images list
          product.images!.addAll(imagesUrl);
        }
      }
    } catch (e) {
      // Handle any errors that occur during upload
      print('Error uploading dummy data: $e');
    }
  }

}
