import "package:flutter/material.dart";
import "package:flutter/services.dart";
import "package:recipt_snap/shared/popup.dart";

import "../models/cart_item.dart";
import "../models/product.dart";
import "../res/colors.dart";
import "../shared/primary_button.dart";

class ProductPopUp extends StatefulWidget {
  final List<Product> productCatalog;
  final Function(CartItem) onSelect;

  const ProductPopUp({
    Key? key,
    required this.productCatalog,
    required this.onSelect,
  }) : super(key: key);
  @override
  State<ProductPopUp> createState() => _ProductPopUpState();
}

class _ProductPopUpState extends State<ProductPopUp> {
  Product? selected;
  late TextEditingController controller;

  @override
  void initState() {
    super.initState();
    controller = TextEditingController();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      child: ModalPopup(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Select products'.toUpperCase(),
              style: TextStyle(
                  color: AppColors.primary,
                  fontSize: 16,
                  fontWeight: FontWeight.w600),
            ),
            const Divider(),
            Row(
              children: [
                DropdownButton(
                    onChanged: (value) {
                      setState(() {
                        selected = value;
                      });
                    },
                    value: selected,
                    items: widget.productCatalog
                        .map(
                          (e) => DropdownMenuItem(
                            value: e,
                            child: Text(e.name),
                          ),
                        )
                        .toList()),
                const SizedBox(width: 30),
                Flexible(
                  child: TextField(
                    controller: controller,
                    inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                    decoration: const InputDecoration(
                      hintText: 'QTY',
                      border: InputBorder.none,
                    ),
                  ),
                )
              ],
            ),
            const Divider(),
            const SizedBox(height: 20),
            PrimaryButton(
              onTap: () {
                if (selected == null) {
                  Navigator.pop(context);
                  return;
                }
                widget.onSelect(
                  CartItem(
                    product: selected!,
                    qty: controller.text.isEmpty
                        ? 1
                        : int.parse(controller.text),
                  ),
                );
                Navigator.pop(context);
              },
              label: 'Add item',
            )
          ],
        ),
      ),
    );
  }
}
