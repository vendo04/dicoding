import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:dicoding/model/product.dart';
import 'package:dicoding/featured_product.dart';
import 'package:dicoding/product_detail.dart';
import 'package:dicoding/cart_model.dart';
import 'package:dicoding/cart_screen.dart';

void main() {
  runApp(
    ChangeNotifierProvider(
      create: (ctx) => CartProvider(),
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Cemilan Homepage',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({super.key});
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String selectedCategory = "All";

  List<FeaturedProduct> get filteredProducts {
    if (selectedCategory == "All") return productList;
    return productList.where((product) => product.category == selectedCategory).toList();
  }

  @override
  Widget build(BuildContext context) {
    final cart = Provider.of<CartProvider>(context);
    int totalQuantity = cart.items.fold(0, (sum, cartItem) => sum + cartItem.quantity);

    return Scaffold(
      appBar: AppBar(
        title: Text('Toko Cemilan'),
        actions: [
          Stack(
            children: [
              CircleAvatar(
                backgroundColor: Colors.white,
                child: IconButton(
                  icon: const Icon(Icons.shopping_cart, color: Colors.black),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => CartScreen()),
                    );
                  },
                ),
              ),
              if (cart.items.isNotEmpty)
                Positioned(
                  right: 2,
                  top: 2,
                  child: CircleAvatar(
                    radius: 8,
                    backgroundColor: Colors.red,
                    child: Text(
                      '$totalQuantity',
                      style: TextStyle(fontSize: 12, color: Colors.white),
                    ),
                  ),
                ),
            ],
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _heroSection(),
            _categoriesSection(),
            _featuredProducts(context),
            _footer(),
          ],
        ),
      ),
    );
  }

  Widget _heroSection() {
    return SizedBox(
      child: Image.network(
        //'images/home-photo2.jpg',
        'https://raw.githubusercontent.com/vendo04/dicoding/fbf47dbd118c20d4a9968e4ca2f7a5b0a0059daf/images/home-photo2.jpg',
        width: double.infinity,
        fit: BoxFit.cover,
      ),
    );
  }

  Widget _categoriesSection() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        children: [
          SizedBox(height: 30),
          Text(
            'Kategori',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 30,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 30),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _categoryCard('All', Icons.category),
              _categoryCard('Chips and Nuts', Icons.circle_outlined),
              _categoryCard('Cookies', Icons.cookie),
              _categoryCard('Fruits', Icons.apple),
            ],
          ),
        ],
      ),
    );
  }

  Widget _categoryCard(String title, IconData icon) {
    return GestureDetector(
    onTap: () {
      setState(() {
        selectedCategory = title;
      });
    },
    child: Column(
      children: [
        Icon(
          icon,
          size: 50,
          color: selectedCategory == title ? Colors.blue : Colors.grey,
        ),
        SizedBox(height: 8),
        Text(
          title,
          style: TextStyle(
            fontWeight: selectedCategory == title ? FontWeight.bold : FontWeight.normal,
            color: selectedCategory == title ? Colors.blue : Colors.black,
          ),
        ),
      ],
    ),
  );
  }

  Widget _featuredProducts(BuildContext context) {

    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        children: [
          Text(
            'Produk',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 30,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 10),
          LayoutBuilder(
            builder: (context, constraints) {
            return GridView.builder(
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(), // Disable scrolling in GridView
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: (constraints.maxWidth / 200).floor().clamp(2, 6),
                  crossAxisSpacing: 16.0,
                  mainAxisSpacing: 16.0,
                ),
                itemCount: filteredProducts.length,
                itemBuilder: (context, index) {
                  if (index >= filteredProducts.length) return Container();
                  return InkWell(
                    onTap: () {
                      Navigator.push(context, MaterialPageRoute(builder: (context) {
                        return DetailScreen(
                          product: {
                            'id': filteredProducts[index].id,
                            'category': filteredProducts[index].category,
                            'name': filteredProducts[index].name,
                            'price': filteredProducts[index].price,
                            //'imageAsset': filteredProducts[index].imageAsset,
                            'imageNetwork': filteredProducts[index].imageNetwork,
                            'description': filteredProducts[index].description,
                          }
                        );
                      }));
                    },
                    child: FeaturedProduct(
                      id: filteredProducts[index].id,
                      //imageAsset: filteredProducts[index].imageAsset,
                      imageNetwork: filteredProducts[index].imageNetwork,
                      category: filteredProducts[index].category,
                      name: filteredProducts[index].name,
                      description: filteredProducts[index].description,
                      price: filteredProducts[index].price,
                    ),
                  );
                },
              );
            }
          )
        ],
      ),
    );
  }

  Widget _footer() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        children: [
          Divider(),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              IconButton(
                icon: Icon(Icons.facebook),
                onPressed: () {
                  launchUrl(Uri.parse("https://facebook.com"));
                },
              ),
              IconButton(
                icon: Icon(Icons.tiktok),
                onPressed: () {
                  launchUrl(Uri.parse("https://tiktok.com"));
                },
              ),
              IconButton(
                icon: Icon(Icons.wechat_sharp),
                onPressed: () {
                  launchUrl(Uri.parse("https://wechat.com"));
                },
              ),
            ],
          ),
          SizedBox(height: 8),
          Text('© 2025 Toko Cemilan'),
        ],
      ),
    );
  }
}
