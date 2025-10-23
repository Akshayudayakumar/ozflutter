import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:ozone_erp/constants/constant.dart';
import 'package:ozone_erp/models/general_details.dart';
import 'package:ozone_erp/screens/neworder/controller/new_order_controller.dart';
import 'package:ozone_erp/screens/newsale/controller/new_sale_controller.dart';
import 'package:ozone_erp/screens/salesreturn/controller/sales_return_controller.dart';
import 'package:ozone_erp/screens/stockTransfer/controller/stock_transfer_controller.dart';
import 'package:ozone_erp/utils/utils.dart';
import 'package:ozone_erp/widgets/add_item_pop_up.dart';
import 'package:ozone_erp/widgets/open_item.dart';

import '../data/app_data.dart';
import '../models/currency.dart';

class ItemCard extends StatefulWidget {
  final Items item;
  final NewSaleController? newSaleController;
  final StockTransferController? stockTransferController;
  final NewOrderController? newOrderController;
  final SalesReturnController? salesReturnController;
  final bool openCart;
  final String preventMessage;
  final VoidCallback addToCart;
  final void Function(String value) onTotalChanged;
  final void Function(String value) onQuantityChanged;

  const ItemCard({
    // A standard Flutter parameter that helps the framework identify and manage widgets efficiently.
    super.key,
    // `item`: An instance of the `Items` class. This is a required parameter and contains all the data about the product to be displayed, such as its name, price, and available quantity.
    required this.item,
    // `onTotalChanged`: A required callback function that is triggered whenever the total price changes (e.g., when the user enters a quantity). It passes the new total as a string.
    required this.onTotalChanged,
    // `onQuantityChanged`: A required callback function that is triggered when the user types in the quantity field. It passes the entered quantity as a string.
    required this.onQuantityChanged,
    // `addToCart`: A required callback function that is executed when the user performs an action to add the item to the cart.
    required this.addToCart,
    // `newSaleController`: An optional controller from the 'New Sale' screen. If provided, this widget can directly interact with the state of the new sale (e.g., adding an item to the sale's list).
    this.newSaleController,
    // `stockTransferController`: An optional controller for 'Stock Transfer' functionality. Its presence would allow this card to be used in a stock transfer context.
    this.stockTransferController,
    // `newOrderController`: An optional controller for the 'New Order' screen.
    this.newOrderController,
    // `salesReturnController`: An optional controller for the 'Sales Return' screen.
    this.salesReturnController,
    // `openCart`: A boolean flag that defaults to `true`. It likely controls whether certain actions, like "Edit Details", are enabled. If `false`, the functionality might be restricted.
    this.openCart = true,
    // `preventMessage`: A string that defaults to empty. If `openCart` is `false`, this message is shown to the user when they try to perform the restricted action.
    this.preventMessage = '',
  });

  @override
  State<ItemCard> createState() => _ItemCardState();
}

class _ItemCardState extends State<ItemCard> {
  final TextEditingController _quantityController = TextEditingController();
  final TextEditingController _freeQtyController = TextEditingController();
  String _enteredQuantity = '0';
  bool _freeQuantityEnabled = true;

  @override
  void dispose() {
    _quantityController.dispose();
    _freeQtyController.dispose();
    super.dispose();
  }

  bool get isQuantityEntered => _quantityController.text.isNotEmpty && double.tryParse(_quantityController.text) != null && double.parse(_quantityController.text) > 0;

  void quantityChanged(String value) {
    setState(() {
      _enteredQuantity = value.isEmpty ? '0' : value;
      _freeQuantityEnabled = value.isNotEmpty && double.tryParse(value) != null && double.parse(value) > 0;
      if (!_freeQuantityEnabled) {
        _freeQtyController.clear();
      }
    });
    widget.onQuantityChanged(_enteredQuantity);

    if (value.isNotEmpty && double.tryParse(value) != null) {
      double quantity = double.parse(value);
      double rate = double.tryParse(widget.item.srate ?? '0') ?? 0;
      double total = quantity * rate;
      widget.onTotalChanged(total.toString());
    }
  }

  void onFreeQtyChanged(String value) {
    setState(() {
    });
  }

  @override
  Widget build(BuildContext context) {
    Color quantityColor =
        double.parse(widget.item.itemQty!) <= 10 ? Colors.red : Colors.black;

    return Card(
      elevation: 2.0,
      margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: SizeConstant.screenWidth * .35,
              height: SizeConstant.screenWidth * .35,
              clipBehavior: Clip.antiAlias,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8),
                image: DecorationImage(image: AssetImage(
                  AssetConstant.delivery,
                ))


              ),
            ),
            const SizedBox(width: 30),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.only(right: 8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.item.name ?? '',
                      textAlign: TextAlign.left,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(height: 10),
                    Row(
                      children: [
                        Text(
                          'Available Quantity: ',
                          textAlign: TextAlign.left,
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w500,
                            color: quantityColor,
                          ),
                        ),
                        Text(
                          widget.item.itemQty.toString(),
                          textAlign: TextAlign.left,
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                            color: quantityColor,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Text(
                              'Quantity: ',
                              textAlign: TextAlign.left,
                              style: TextStyle(
                                fontSize: 13,
                                fontWeight: FontWeight.w500,
                                color: Colors.black87,
                              ),
                            ),
                            const SizedBox(width: 8),
                            Container(
                              width: 80,
                              height: 35,
                              child: TextField(
                                controller: _quantityController,
                                keyboardType: TextInputType.numberWithOptions(
                                  decimal: true,
                                ),
                                inputFormatters: [
                                  FilteringTextInputFormatter.allow(
                                    RegExp(r'^\d*\.?\d*'),
                                  ),
                                ],
                                onChanged: quantityChanged,
                                decoration: InputDecoration(
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(4),
                                    borderSide: BorderSide(
                                      color: Colors.grey.shade400,
                                    ),
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(4),
                                    borderSide: BorderSide(color: Colors.blue),
                                  ),
                                  contentPadding: EdgeInsets.symmetric(
                                    horizontal: 8,
                                    vertical: 8,
                                  ),
                                  hintText: '0',
                                  hintStyle: TextStyle(
                                    fontSize: 12,
                                    color: Colors.grey,
                                  ),
                                ),
                                style: TextStyle(fontSize: 12),
                              ),
                            ),
                            const SizedBox(width: 8),
                            // GestureDetector(
                            //   onTap: () {
                            //     if (_enteredQuantity != '0' &&
                            //         _enteredQuantity.isNotEmpty) {
                            //       Utils().showToast(
                            //         'Quantity confirmed: $_enteredQuantity',
                            //       );
                            //     } else {
                            //       Utils().showToast('Please enter quantity');
                            //     }
                            //   },
                            //   child: Container(
                            //     width: 30,
                            //     height: 30,
                            //     decoration: BoxDecoration(
                            //       color: Colors.black,
                            //       borderRadius: BorderRadius.circular(4),
                            //     ),
                            //     child: Icon(
                            //       Icons.check,
                            //       color: Colors.white,
                            //       size: 16,
                            //     ),
                            //   ),
                            // ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        if(AppData().getFreeQuantity())
                        Row(
                          children: [
                            Text(
                              'Free Qty: ',
                              textAlign: TextAlign.left,
                              style: TextStyle(
                                fontSize: 13,
                                fontWeight: FontWeight.w500,
                                color: Colors.black87,
                              ),
                            ),
                            const SizedBox(width: 8),
                            Container(
                              width: 80,
                              height: 35,
                              child: TextField(
                                controller: _freeQtyController,
                                enabled: isQuantityEntered,
                                keyboardType: TextInputType.numberWithOptions(
                                  decimal: true,
                                ),
                                inputFormatters: [
                                  FilteringTextInputFormatter.allow(
                                    RegExp(r'^\d*\.?\d*'),
                                  ),
                                ],
                                onChanged: onFreeQtyChanged,
                                decoration: InputDecoration(
                                  border: OutlineInputBorder(
                                    borderSide: BorderSide(
                                      color: Colors.grey.shade400,
                                    ),
                                    borderRadius: BorderRadius.circular(4),
                                  ),
                                  disabledBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(4),
                                    borderSide: BorderSide(color: Colors.grey.shade300),
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(4),
                                    borderSide: BorderSide(color: Colors.blue),
                                  ),
                                  contentPadding: EdgeInsets.symmetric(
                                    horizontal: 8,
                                    vertical: 8,
                                  ),
                                  hintText: '0',
                                  hintStyle: const TextStyle(
                                    fontSize: 12,
                                    color: Colors.grey,
                                  ),
                                ),
                                style: const TextStyle(fontSize: 12),
                              ),
                            ),
                            const SizedBox(width: 8),
                            // GestureDetector(
                            //   onTap: () {
                            //     if (_enteredFreeQty != '0' &&
                            //         _enteredFreeQty.isNotEmpty) {
                            //       Utils().showToast(
                            //         'Free Qty confirmed: $_enteredFreeQty',
                            //       );
                            //     } else {
                            //       Utils()
                            //           .showToast('Please enter free quantity');
                            //     }
                            //   },
                            //   child: Container(
                            //     width: 30,
                            //     height: 30,
                            //     decoration: BoxDecoration(
                            //       color: Colors.black,
                            //       borderRadius: BorderRadius.circular(4),
                            //     ),
                            //     child: Icon(
                            //       Icons.check,
                            //       color: Colors.white,
                            //       size: 16,
                            //     ),
                            //   ),
                            // ),
                          ],
                        ),
                      ],
                    ),
                    // Row(
                    // children: [
                    //   Text(
                    //     'Quantity: ',
                    //     textAlign: TextAlign.left,
                    //     style: TextStyle(
                    //       fontSize: 12,
                    //       fontWeight: FontWeight.w500,
                    //       color: Colors.black87,
                    //     ),
                    //   ),
                    //   const SizedBox(width: 8),
                    //   Text(
                    //     'F Qty: ',
                    //     textAlign: TextAlign.left,
                    //     style: TextStyle(
                    //       fontSize: 12,
                    //       fontWeight: FontWeight.w500,
                    //       color: Colors.black87,
                    //     ),
                    //   ),

                    //   Container(
                    //     width: 80,
                    //     height: 35,
                    //     child: TextField(
                    //       controller: _quantityController,
                    //       keyboardType: TextInputType.numberWithOptions(
                    //         decimal: true,
                    //       ),
                    //       inputFormatters: [
                    //         FilteringTextInputFormatter.allow(
                    //           RegExp(r'^\d*\.?\d*'),
                    //         ),
                    //       ],
                    //       onChanged: _onQuantityChanged,
                    //       decoration: InputDecoration(
                    //         border: OutlineInputBorder(
                    //           borderRadius: BorderRadius.circular(4),
                    //           borderSide: BorderSide(
                    //             color: Colors.grey.shade400,
                    //           ),
                    //         ),
                    //         focusedBorder: OutlineInputBorder(
                    //           borderRadius: BorderRadius.circular(4),
                    //           borderSide: BorderSide(color: Colors.blue),
                    //         ),
                    //         contentPadding: EdgeInsets.symmetric(
                    //           horizontal: 8,
                    //           vertical: 8,
                    //         ),
                    //         hintText: '0',
                    //         hintStyle: TextStyle(
                    //           fontSize: 12,
                    //           color: Colors.grey,
                    //         ),
                    //       ),
                    //       style: TextStyle(fontSize: 12),
                    //     ),
                    //   ),
                    //   const SizedBox(width: 8),
                    //   GestureDetector(
                    //     onTap: () {
                    //       // Handle tick button action
                    //       if (_enteredQuantity != '0' &&
                    //           _enteredQuantity.isNotEmpty) {
                    //         Utils().showToast(
                    //           'Quantity confirmed: $_enteredQuantity',
                    //         );
                    //         // You can add your custom logic here
                    //       } else {
                    //         Utils().showToast('Please enter quantity');
                    //       }
                    //     },
                    //     child: Container(
                    //       width: 30,
                    //       height: 30,
                    //       decoration: BoxDecoration(
                    //         color: Colors.green,
                    //         borderRadius: BorderRadius.circular(4),
                    //       ),
                    //       child: Icon(
                    //         Icons.check,
                    //         color: Colors.white,
                    //         size: 16,
                    //       ),
                    //     ),
                    //   ),
                    // ],
                    // ),
                    const SizedBox(height: 10),
                    Text(
                      '${Currency.getById(AppData().getSettings().currency).symbol} ${widget.item.srate}',
                      textAlign: TextAlign.left,
                      style: const TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    
                    if (_enteredQuantity != '0' && _enteredQuantity.isNotEmpty)
                      Padding(
                        padding: const EdgeInsets.only(top: 5),
                        child: Text(
                          'Total: ${Currency.getById(AppData().getSettings().currency).symbol} ${((double.tryParse(_enteredQuantity) ?? 0) * (double.tryParse(widget.item.srate ?? '0') ?? 0)).toStringAsFixed(2)}',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w500,
                            color: AppStyle.primaryColor,
                          ),
                        ),
                      ),
                  ],
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        Row(
          children: [
            // Expanded(
            //   child: OpenItem(
            //     openChild: ViewItemDetails(item: widget.item),
            //     closedChild: Container(
            //       height: 50,
            //       alignment: Alignment.center,
            //       decoration: BoxDecoration(
            //         border: Border.all(color: Colors.black12),
            //       ),
            //       child: const Text('View Details'),
            //     ),
            //   ),
            // ),
            Expanded(
              child: GestureDetector(
                onTap: () {
                 
                  if (_enteredQuantity != '0' && _enteredQuantity.isNotEmpty) {
                  
                    if (widget.newSaleController != null) {
                     
                      widget.newSaleController!.setItemQuantity(
                        item: widget.item,
                        quantity: int.parse(_enteredQuantity),
                      );
                    
                      widget.newSaleController!.addItem(
                        widget.item.copyWith(itemQty: _enteredQuantity),
                      );
                      Utils().showToast(
                        'Added to cart: $_enteredQuantity items',
                      );
                    } else {
                      
                      widget.addToCart();
                      Utils().showToast(
                        'Added to cart: $_enteredQuantity items',
                      );
                    }
                  } else {
                    Utils().showToast('Please enter quantity first');
                  }
                },
                child: Container(
                  height: 40,
                  margin: const EdgeInsets.only(left: 4),
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: AppStyle.primaryColor,
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: Text(
                    'Add to Cart',
                    style: GoogleFonts.poppins(
                        color: Colors.white,
                        fontSize: 15,
                        fontWeight: FontWeight.w500),
                  ),
                ),
              ),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: !widget.openCart
                  ? GestureDetector(
                      onTap: () {
                        Utils().showToast(widget.preventMessage);
                      },
                      child: Container(
                        height: 40,
                        margin: const EdgeInsets.only(right: 4),
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          border: Border.all(color: AppStyle.primaryColor),
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: Text('Edit Details',
                            style: GoogleFonts.poppins(
                                color: AppStyle.primaryColor,
                                fontSize: 15,
                                fontWeight: FontWeight.w500)),
                      ),
                    )
                  : OpenItem(
                      openChild: AddItemPopUp(
                        item: widget.item,
                        onQuantityChanged: widget.onQuantityChanged,
                        onTotalChanged: widget.onTotalChanged,
                        addToCart: () {
                          if (RegExpressions.zeroRegex.hasMatch(
                            widget.item.itemQty!,
                          )) {
                            Utils().showToast('Item out of stock');
                          } else if (_enteredQuantity == '0' ||
                              _enteredQuantity.isEmpty) {
                            Utils().showToast('Please enter quantity');
                          } else if (double.tryParse(_enteredQuantity) !=
                                  null &&
                              double.parse(_enteredQuantity) >
                                  double.parse(widget.item.itemQty!)) {
                            Utils().showToast(
                              'Quantity exceeds available stock',
                            );
                          } else {
                            widget.addToCart();
                          }
                        },
                      ),
                      closedChild: Container(
                        height: 40,
                        margin: const EdgeInsets.only(right: 4),
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          border: Border.all(color: AppStyle.primaryColor),
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: Text('Edit Details',
                            style: GoogleFonts.poppins(
                                color: AppStyle.primaryColor,
                                fontSize: 15,
                                fontWeight: FontWeight.w500)),
                      ),
                    ),
            ),
          ],
        ),
          ],
        ),
      ),
    );
  }
}
