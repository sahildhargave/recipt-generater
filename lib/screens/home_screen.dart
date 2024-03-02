import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:recipt_snap/models/product.dart';
import "package:recipt_snap/models/cart_item.dart";
import 'package:flutter_svg/svg.dart';
import 'package:recipt_snap/shared/primary_button.dart';
import '../res/pdf.dart';
import "package:recipt_snap/res/colors.dart";

import '../widgets/change_name.dart';
import '../widgets/product_select.dart';
import '../widgets/summery.dart';
import 'pdf_viewer.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<Product> productCatalog = [
    Product(id: 1, name: 'Milk Chocolate', price: 450),
    Product(id: 2, name: 'Coca Cola', price: 100),
    Product(id: 3, name: 'Redbull (Sugar Free)', price: 750),
    Product(id: 4, name: 'Fresh Milk', price: 450),
    Product(id: 5, name: 'Panadol', price: 450),
    Product(id: 6, name: 'Sprite', price: 450),
    Product(id: 7, name: 'Fried Chicken', price: 550),
  ];
  List<CartItem> cart = [];
  String businessName = "Receipt snap";

  File? selectedLogo;
  bool pdfGnerating = false;
  bool pdfGenerating = false;

  double appCharges = 45.0;
  double totalCost = 0.0;

  void generatePDF() async {
    if (cart.isEmpty) {
      return;
    }
    setState(() {
      pdfGenerating = true;
    });

    File pdfFile = await PDFGenerator.generateInvoicePDF(
        icon: selectedLogo,
        cardItems: cart,
        businessName: businessName,
        total: totalCost);

    setState(() {
      pdfGenerating = false;
    });
    if (mounted) {
      Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => PdfPreviewScreen(pdf: pdfFile),
          ));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: logoWithTitle(),
        ),
        body: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                    child: ListView(
                  children: [
                    ChangeName(
                        businessName: businessName,
                        onNameSelect: (String p0) {
                          setState(() {
                            businessName = p0;
                          });
                        }),
                    ProductSelect(
                      onAdded: (CartItem cartItem) {
                        setState(() {
                          cart.add(cartItem);
                          totalCost += cartItem.qty * cartItem.product.price;
                        });
                      },
                      onRemoved: (CartItem cartItem) {
                        setState(() {
                          cart.remove(cartItem);
                          totalCost - cartItem.qty * cartItem.product.price;
                        });
                      },
                      productCatalog: productCatalog,
                      cart: cart,
                    ),
                    Summery(
                      appCharges: appCharges,
                      total: totalCost,
                    )
                  ],
                )),
                SafeArea(
                    child: PrimaryButton(
                        label: 'Generate invoice',
                        onTap: () {
                          generatePDF();
                        },
                        child: pdfGenerating
                            ? const CupertinoActivityIndicator(
                                color: Colors.white,
                              )
                            : null))
              ],
            )));
  }

  Row logoWithTitle() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        SvgPicture.asset(
          'assets/logo.svg',
          color: AppColors.primary,
        ),
        const SizedBox(width: 5),
        Text(
          'ReceiptSnap'.toUpperCase(),
          style: TextStyle(
              color: AppColors.primary,
              letterSpacing: 2,
              fontWeight: FontWeight.w600),
        ),
      ],
    );
  }
}
