import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';
import 'UI/ui.dart';

class ProductDetailPage extends StatelessWidget {
  final Razorpay _razorpay = Razorpay();
  final Map product;

  ProductDetailPage({required this.product}) {
    _razorpay.on(Razorpay.EVENT_PAYMENT_SUCCESS, _handlePaymentSuccess);
    _razorpay.on(Razorpay.EVENT_PAYMENT_ERROR, _handlePaymentError);
    _razorpay.on(Razorpay.EVENT_EXTERNAL_WALLET, _handleExternalWallet);
  }

  void startPayment(Object context) {
    var options = {
      'key': 'rzp_test_123456789',
      'amount': product['price'] * 100, // Amount in paisa
      'name': product['name'],
      'description': 'Purchase of ${product['name']}',
      'prefill': {'contact': '1234567890', 'email': 'test@example.com'},
    };
    _razorpay.open(options);
  }

  void _handlePaymentSuccess(PaymentSuccessResponse response) {
    print("Payment Success: ${response.paymentId}");
  }

  void _handlePaymentError(PaymentFailureResponse response) {
    print("Payment Error: ${response.message}");
  }

  void _handleExternalWallet(ExternalWalletResponse response) {
    print("External Wallet: ${response.walletName}");
  }

  @override
  Widget build(BuildContext context) {
    // Same as above
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

