import "package:flutter/material.dart";
import "package:flutter/services.dart";
import "package:recipt_snap/widgets/product_select_popup.dart";

import "../models/cart_item.dart";
import "../models/product.dart";
import "../res/colors.dart";
import "../shared/decorated_container.dart";

class ProductSelect extends StatelessWidget {
  final Function(CartItem) onAdded;
  final Function(CartItem) onRemoved;

  final List<Product> productCatalog;
  final List<CartItem> cart;

  const ProductSelect({
    Key? key,
    required this.onAdded,
    required this.onRemoved,
    required this.productCatalog,
    required this.cart,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return DecoratedContainer(
      label: 'Products',
      onTap: () {
        showDialog(
          context: context,
          builder: (context) {
            return ProductPopUp(
              onSelect: (p0) {
                onAdded(p0);
              },
              productCatalog: productCatalog,
            );
          },
        );
      },
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: cart.map((e) => productRow(e)).toList(),
      ),
    );
  }

  Widget productRow(CartItem e) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Dismissible(
        onDismissed: (direction) {
          onRemoved(e);
        },
        key: UniqueKey(),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              "${e.product.name} x ${e.qty}",
              style: TextStyle(
                  color: AppColors.primary, fontWeight: FontWeight.w600),
            ),
            Text(
              "${e.product.price * e.qty} LKR",
              style: const TextStyle(fontWeight: FontWeight.w600),
            ),
          ],
        ),
      ),
    );
  }
}
