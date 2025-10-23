import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ozone_erp/Constants/constant.dart';
import 'package:ozone_erp/components/export_components.dart';
import 'package:ozone_erp/models/sales_body.dart';
import 'package:ozone_erp/screens/register/controller/register_controller.dart';
import 'package:ozone_erp/widgets/export_widgets.dart';

import '../../../services/location_services.dart';

class EditBody extends StatefulWidget {
  final SalesBody body;
  const EditBody({super.key, required this.body});

  // Creates the mutable state for this widget.
  @override
  State<EditBody> createState() => _EditBodyState();
}

// This is the State class associated with the EditBody widget.
// It holds the data that can change over time, like the device's position.
class _EditBodyState extends State<EditBody> {
  // A nullable 'Position' object to store the geographic coordinates (latitude, longitude).
  // It's null initially because the location hasn't been fetched yet.
  Position? position;
  // A nullable 'String' to store any error message that occurs during location fetching.
  String? locationError;

  // An asynchronous method to get the user's current location.
  Future<void> getLocation() async {
    // Calls the 'getLocation' method from a 'LocationRepository' (likely defined in 'location_services.dart').
    // This repository handles the logic of interacting with the location service.
    final result = await LocationRepository().getLocation();
    // The 'fold' method is used on the 'result' (which is likely an 'Either' type).
    // It provides a way to handle both success (left side, 'data') and failure (right side, 'error') cases.
    await result.fold((data) {
      setState(() {
        position = data;
        locationError = null;
      });
    }, (error) {
      setState(() {
        position = null;
        locationError = error;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder(builder: (RegisterController controller) {
      return Scaffold(
        appBar: customAppBar(
            title: widget.body.cusname ?? 'Edit Item', centerTitle: true),
        body: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Expanded(
                  child: TextWidget(
                    locationError ?? 'Reset Location',
                    textAlign: TextAlign.end,
                    color: AppStyle.radioColor,
                    style: FontConstant.interSmall,
                  ),
                ),
                Container(
                  height: 30,
                  width: 30,
                  margin: EdgeInsets.all(12),
                  child: FittedBox(
                    fit: BoxFit.scaleDown,
                    child: ActionWidget(
                        color: AppStyle.radioColor,
                        icon: Icons.location_on_outlined,
                        onTap: () async => await getLocation()),
                  ),
                ),
              ],
            )
          ],
        ),
      );
    });
  }
}
