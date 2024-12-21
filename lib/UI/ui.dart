import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;


class ProductListPage extends StatefulWidget {
  @override
  _ProductListPageState createState() => _ProductListPageState();
}

class _ProductListPageState extends State<ProductListPage> {
  List products = [];

  @override
  void initState() {
    super.initState();
    fetchProducts();
  }

  Future<void> fetchProducts() async {
    final response = await http.get(Uri.parse('http://10.0.2.2:5000/api/products'));

    if (response.statusCode == 200) {
      setState(() {
        products = json.decode(response.body);
      });
    } else {
      throw Exception('Failed to load products');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Cloth Shop")),
      body: products.isEmpty
          ? Center(child: CircularProgressIndicator())
          : ListView.builder(
        itemCount: products.length,
        itemBuilder: (context, index) {
          final product = products[index];
          return ListTile(
            title: Text(product['name']),
            subtitle: Text("\$${product['price']}"),
            leading: Image.network(product['image']),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => ProductDetailPage(product: product),
                ),
              );
            },
          );
        },
      ),
    );
  }
}

class ProductDetailPage extends StatelessWidget {
  final Map product;

  ProductDetailPage({required this.product});

  void startPayment(BuildContext context) {
    // Payment gateway integration logic
    // Example: Razorpay, Stripe
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        content: Text("Payment initiated for ${product['name']}"),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(product['name'])),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Image.network(product['image'], height: 250),
            SizedBox(height: 16),
            Text(product['name'], style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
            SizedBox(height: 8),
            Text("\$${product['price']}", style: TextStyle(fontSize: 18, color: Colors.green)),
            SizedBox(height: 16),
            Text(product['description']),
            Spacer(),
            ElevatedButton(
              onPressed: () => startPayment(context),
              child: Text("Buy Now"),
            ),
          ],
        ),
      ),
    );
  }
}
