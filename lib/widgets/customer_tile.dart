import 'package:flutter/material.dart';
import 'package:ozone_erp/Constants/constant.dart';
//import 'package:ozone_erp/Helpers/common_helpers.dart';
import 'package:ozone_erp/models/general_details.dart';
import 'package:ozone_erp/services/location_services.dart';
import 'package:ozone_erp/utils/utils.dart';
import 'package:ozone_erp/widgets/export_widgets.dart';
import 'package:url_launcher/url_launcher.dart';

class CustomerTile extends StatelessWidget {
  final Customers customer;
  final double? height;
  final double? width;
  final bool? isCard;
  final Function(String latitude, String longitude)? onLocationUpdated;

  const CustomerTile(
      {super.key, required this.customer, this.height, this.width, this.isCard, this.onLocationUpdated});

  @override
  Widget build(BuildContext context) {
    return ShadowBox(
      height: height,
      width: width,
      margin: const EdgeInsets.symmetric(vertical: 8),
      padding: const EdgeInsets.all(12),
      curveRadius: 12,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        spacing: 12,
        children: [
          Image.asset(
            AssetConstant.user,
            height: 30,
            width: 30,
          ),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                FittedBox(
                  fit: BoxFit.scaleDown,
                  child: TextWidget(
                    customer.name == null || customer.name!.isEmpty
                        ? 'Name Unavailable'
                        : customer.name!,
                    style: FontConstant.interMediumBold,
                  ),
                ),
                Text(customer.phone != null && customer.phone!.isNotEmpty
                    ? customer.phone!
                    : 'Phone Unavailable'),
                Text(customer.addressLine1 ?? customer.addressLine2 ?? ''),
              ],
            ),
          ),
          if (customer.latitude?.isNotEmpty ?? false) ...[
            const SizedBox(width: 8),
            if ((customer.longitude?.isNotEmpty ?? false))
              ActionWidget(
                color: AppStyle.primaryColor.withAlpha(100),
                onTap: () async {
                  try {
                    String url =
                        'https://www.google.com/maps/search/?api=1&query=${customer.latitude},${customer.longitude}';
                    await launchUrl(Uri.parse(url));
                  } catch (e) {
                    print(e);
                  }
                },
                icon: Icons.location_on,
                iconColor: AppStyle.primaryColor,
                height: 40,
                width: 40,
                iconSize: 20,
                padding: 0,
              ),
          ],
        ],
      ),
    );
  }
}
