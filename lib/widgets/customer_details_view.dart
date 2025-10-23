import 'package:flutter/material.dart';
import 'package:ozone_erp/models/general_details.dart';
import 'package:ozone_erp/services/location_services.dart';
import 'package:ozone_erp/utils/utils.dart';
import 'package:ozone_erp/widgets/customer_details_row.dart';
import '../Constants/constant.dart';

class CustomerDetailsView extends StatelessWidget {
  final Customers customer;
  final void Function(double latitude,double longitude) onLocationUpdate;

  const CustomerDetailsView(
      {super.key, required this.customer, required this.onLocationUpdate});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(customer.name == null || customer.name!.isEmpty
            ? 'Customer'
            : customer.name!),
        leading: IconButton(onPressed: () => Navigator.pop(context),
            icon:Icon(Icons.arrow_back_ios_new_outlined)),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              Card(
                elevation: 4,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      if (customer.name == null ||
                          customer.addressLine1 == null ||
                          customer.addressLine2 == null ||
                          customer.phone == null ||
                          customer.email == null ||
                          customer.contactPerson == null ||
                          customer.contactNumber == null ||
                          customer.name!.isEmpty ||
                          customer.addressLine1!.isEmpty ||
                          customer.addressLine2!.isEmpty ||
                          customer.phone!.isEmpty ||
                          customer.email!.isEmpty ||
                          customer.contactPerson!.isEmpty ||
                          customer.contactNumber!.isEmpty)
                        Padding(
                          padding: const EdgeInsets.only(bottom: 12.0),
                          child: Text(
                            'Only showing provided information',
                            style: Theme.of(context).textTheme.titleSmall,
                            textAlign: TextAlign.center,
                          ),
                        ),
                      if (customer.name != null && customer.name!.isNotEmpty)
                        CustomerDetailsRow(title: 'Name', value: customer.name!),
                      if (customer.addressLine1 != null && customer.addressLine1!.isNotEmpty)
                        CustomerDetailsRow(title: 'Address Line 1', value: customer.addressLine1!),
                      if (customer.addressLine2 != null && customer.addressLine2!.isNotEmpty)
                        CustomerDetailsRow(title: 'Address Line 2', value: customer.addressLine2!),
                      if (customer.phone != null && customer.phone!.isNotEmpty)
                        CustomerDetailsRow(title: 'Phone', value: customer.phone!),
                      if (customer.email != null && customer.email!.isNotEmpty)
                        CustomerDetailsRow(title: 'Email', value: customer.email!),
                      if (customer.contactPerson != null && customer.contactPerson!.isNotEmpty)
                        CustomerDetailsRow(title: 'Contact Person', value: customer.contactPerson!),
                      if (customer.contactNumber != null && customer.contactNumber!.isNotEmpty)
                        CustomerDetailsRow(title: 'Contact Number', value: customer.contactNumber!),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 16),
              if(customer.latitude != null && customer.latitude!.isNotEmpty ||
              customer.longitude != null && customer.longitude!.isNotEmpty)
              Card(
                elevation: 4,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: ListTile(
                    leading: const Icon(Icons.location_on,size: 30,color: AppStyle.primaryColor),
                    title: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Location Details',
                          style: Theme.of(context).textTheme.titleLarge,
                        ),
                        const SizedBox(height: 12),
                        CustomerDetailsRow(
                          title: 'Latitude',
                          value: customer.latitude ?? 'Not Available',
                        ),
                        CustomerDetailsRow(
                          title: 'Longitude',
                          value: customer.longitude ?? 'Not Available',
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () async {
          final result = await LocationRepository().getLocation();
          result.fold((position) {
                onLocationUpdate(position.latitude, position.longitude);
          }, (error) {
            Utils().cancelToast();
            Utils().showToast(error);
          });
        },
        backgroundColor: AppStyle.primaryColor,
        foregroundColor: AppStyle.whiteColor,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        label: const Text('Update Location'),
        icon: const Icon(Icons.location_on),
      ),
    );
  }
}
