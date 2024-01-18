import 'dart:convert';

import 'package:e_commerce_app/viewmodel/provider/cartprovider.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';

class RazorPayIntegration {
  CartProvider? cartProvider;
   Razorpay razorpay = Razorpay();
  // final _razorpay = Razorpay();
  String apiKey = 'rzp_test_zQPlZarshPvJdu';
  String apiSecret = '2wIuMR5iDGn93AYpI4jHyPsv';
  paymentResponse(context){
     void showAlertDialog(BuildContext context, String title, String message) {
    // set up the buttons
    Widget continueButton = ElevatedButton(
      child: const Text("Continue"),
      onPressed: () {
        Navigator.pop(context);
      },
    );
    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      title: Text(title),
      content: Text(message),
      actions: [
        continueButton,
      ],
    );
    // show the dialog
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }
void handlePaymentErrorResponse(PaymentFailureResponse response) {
    /*
    * PaymentFailureResponse contains three values:
    * 1. Error Code
    * 2. Error Description
    * 3. Metadata
    * */
    showAlertDialog(context, "Payment Failed",
        "Code: ${response.code}\nDescription: ${response.message}\nMetadata:${response.error.toString()}");
  }

  void handlePaymentSuccessResponse(PaymentSuccessResponse response) {
    /*
    * Payment Success Response contains three values:
    * 1. Order ID
    * 2. Payment ID
    * 3. Signature
    * */
    showAlertDialog(
        context, "Payment Successful", "Payment ID: ${response.paymentId}");
    Provider.of<CartProvider>(context, listen: false).placeOrder(context);
  }

  void handleExternalWalletSelected(ExternalWalletResponse response) {
    showAlertDialog(
        context, "External Wallet Selected", "${response.walletName}");
  }

   razorpay.on(
                    Razorpay.EVENT_PAYMENT_ERROR, handlePaymentErrorResponse);
                razorpay.on(Razorpay.EVENT_PAYMENT_SUCCESS,
                    handlePaymentSuccessResponse);
                razorpay.on(Razorpay.EVENT_EXTERNAL_WALLET,
                    handleExternalWalletSelected);
 }
 razorPayFunction(int totalPrice){
   
                var options = {
                  'key': 'rzp_test_zQPlZarshPvJdu',
                  'amount': totalPrice * 8000,
                  'name': 'Acme Corp.',
                  'description': 'Fine T-Shirt',
                  'retry': {'enabled': true, 'max_count': 1},
                  'send_sms_hash': true,
                  'prefill': {
                    'contact': '8888888888',
                    'email': 'test@razorpay.com'
                  },
                  'external': {
                    'wallets': ['paytm']
                  }
                };
              
                razorpay.open(options);



                
 }
 



  // Future<void> initiatePayment(int totalPrize) async {
  //   Map<String, dynamic> paymentData = {
  //     'amount':
  //         totalPrize * 8000, // amount in paise (e.g., 1000 paise = Rs. 10)
  //     'currency': 'INR',
  //     'receipt': 'order_receipt',
  //     'payment_capture': '1',
  //   };

  //   String apiUrl = 'https://api.razorpay.com/v1/orders';
  //   // Make the API request to create an order
  //   http.Response response = await http.post(
  //     Uri.parse(apiUrl),
  //     headers: {
  //       'Content-Type': 'application/json',
  //       'Authorization':
  //           'Basic ${base64Encode(utf8.encode('$apiKey:$apiSecret'))}',
  //     },
  //     body: jsonEncode(paymentData),
  //   );

  //   if (response.statusCode == 200) {
  //     // Parse the response to get the order ID
  //     var responseData = jsonDecode(response.body);
  //     String orderId = responseData['id'];

  //     // Set up the payment options
  //     var options = {
  //       'key': apiKey,
  //       'amount': paymentData['amount'],
  //       'name': 'EasyBuy Payment',
  //       'order_id': orderId,
  //       'prefill': {'contact': '1234567890', 'email': 'test@example.com'},
  //       'external': {
  //         'wallets': ['paytm'] // optional, for adding support for wallets
  //       }
  //     };

  //     // Open the Razorpay payment form
  //     _razorpay.open(options);
  //   } else {
  //     // Handle error response
  //     debugPrint('Error creating order: ${response.body}');
  //   }
  // }

  // paymentHandling(context) {
  //   void showAlertDialog(BuildContext context, String title, String message) {
  //     // set up the buttons
  //     Widget continueButton = ElevatedButton(
  //       child: const Text("Continue"),
  //       onPressed: () {
  //         // Navigator.push(
  //         //     context, MaterialPageRoute(builder: (context) => OrderPage(orderedItems: ,)));
  //       },
  //     );
  //     // set up the AlertDialog
  //     AlertDialog alert = AlertDialog(
  //       title: Text(title),
  //       content: Text(message),
  //       actions: [
  //         continueButton,
  //       ],
  //     );
  //     // show the dialog
  //     showDialog(
  //       context: context,
  //       builder: (BuildContext context) {
  //         return alert;
  //       },
  //     );
  //   }

  //   void _handlePaymentError(PaymentFailureResponse response) {
  //     /*
  //   * PaymentFailureResponse contains three values:
  //   * 1. Error Code
  //   * 2. Error Description
  //   * 3. Metadata
  //   * */
  //     showAlertDialog(context, "Payment Failed",
  //         "Code: ${response.code}\nDescription: ${response.message}\nMetadata:${response.error.toString()}");
  //   }

  //   void _handlePaymentSuccess(PaymentSuccessResponse response) {
  //     /*
  //   * Payment Success Response contains three values:
  //   * 1. Order ID
  //   * 2. Payment ID
  //   * 3. Signature
  //   * */
  //     showAlertDialog(
  //         context, "Payment Successful", "Payment ID: ${response.paymentId}");
  //     cartProvider?.placeOrder(context);
  //     cartProvider?.totalPrice = 0;
  //   }

  //   void _handleExternalWallet(ExternalWalletResponse response) {
  //     showAlertDialog(
  //         context, "External Wallet Selected", "${response.walletName}");
  //   }
  // }
}
