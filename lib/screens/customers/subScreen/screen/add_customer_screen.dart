import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:ozone_erp/components/custom_app_bar.dart';
import 'package:ozone_erp/screens/customers/subScreen/controller/add_customer_controller.dart';
import 'package:ozone_erp/widgets/export_widgets.dart';
import '../../../../Constants/size_constant.dart';
import '../../../../models/state_model.dart';

class AddCustomerScreen extends StatelessWidget{
  const AddCustomerScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: customAppBar(
          title: 'Add New Customer',
          centerTitle: true,
          iconButton: IconButton(onPressed: Get.back, icon:Icon(Icons.arrow_back_ios_new_rounded))
      ),
      body: const Padding(
        padding: EdgeInsets.all(5.0),
        child: AddCustomerView(),
      ),
    );
  }
}

class AddCustomerView extends GetView<AddCustomerController> {
  const AddCustomerView({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final state = controller.state.value;

      switch (state) {
        case StateModel.loading:
          return const Center(child: CircularProgressIndicator());

        case StateModel.error:
          return const Center(
            child: Text('Failed to load data. Please try again.'),
          );

        case StateModel.success:
          return buildForm();
      }
    });
  }

  Widget buildForm() {
    return Form(
      key: controller.formKey,
      child: ListView(
        padding:EdgeInsets.only(bottom: SizeConstant.percentToHeight(10)),
        children: [
          CustomTextField(
              controller: controller.nameController,
              textInputType: TextInputType.name,
              textCapitalization: TextCapitalization.words,
              validator: (value) => value!.isEmpty ? 'Enter Name' : null,
              hintText: 'Enter Name',
              type: 'Name'),
          CustomTextField(
              controller: controller.phoneController,
              textInputType: TextInputType.number,
              inputFormatters: [FilteringTextInputFormatter.digitsOnly],
              validator: (value) =>
              value!.isEmpty ? 'Enter Phone Number' : null,
              hintText: 'Enter Phone Number',
              type: 'Phone Number'),
          CustomTextField(
            controller: controller.addressController,
            textInputType: TextInputType.streetAddress,
            hintText: 'Enter Address',
            type: 'Address',
            maxLines: 5,
            minLines: 5,
          ),
          CustomTextField(
              controller: controller.gstController,
              hintText: 'Enter GST No.',
              type: 'GST'),

          DropdownMenu(
            label: TextWidget('Type'),
            dropdownMenuEntries: [
              ...controller.customerTypes
                  .map((e) => DropdownMenuEntry(value: e.id, label: e.name))
            ],
            onSelected: (value) => controller.selectCustomerType(value!),
            hintText: 'Select Customer Type',
            width: double.infinity,
          ),
          const SizedBox(height: 12),
          Obx(() => DropdownMenu(
            initialSelection: '0',
            label: TextWidget('Area'),
            dropdownMenuEntries: [
              const DropdownMenuEntry(value: '0', label: 'All'),
              ...controller.areas
                  .map((e) => DropdownMenuEntry(value: e.id, label: e.area ?? ''))
            ],
            onSelected: (value) => controller.selectArea(value!),
            hintText: 'Select Area to filter',
            width: double.infinity,
          )),
          const SizedBox(height: 12),
          Obx(() => DropdownMenu(
            initialSelection: '0',
            label: TextWidget('Price List'),
            dropdownMenuEntries: [
              const DropdownMenuEntry(value: '0', label: 'All'),
              ...controller.priceLists.map((e) =>
                  DropdownMenuEntry(value: e.id, label: e.priceList ?? ''))
            ],
            onSelected: (value) => controller.selectPriceList(value!),
            hintText: 'Select Price List',
            width: double.infinity,
          )),
          const SizedBox(height: 12),
          DropdownMenu(
            initialSelection: '0',
            label: TextWidget('Customer Rate'),
            dropdownMenuEntries: [
              const DropdownMenuEntry(value: '0', label: 'Select'),
              ...controller.customerRates.map(
                      (e) => DropdownMenuEntry(value: e.id, label:e.id?? ''))
            ],
            onSelected: (value) => controller.selectPriceList(value!),
            hintText: 'Customer Rate',
            width: double.infinity,
          ),


          CustomTextField(
            controller: controller.remarksController,
            textInputType: TextInputType.text,
            hintText: 'Enter Remarks',
            type: 'Remarks',
            maxLines: 5,
            minLines: 5,
          ),
          const SizedBox(height: 16),
          Obx(
                  () {
                final state = controller.submitState.value;
                final bool isLoading = state == StateModel.loading;
                return
                  Center(child:PrintButton(
                      onTap: () => controller.addCustomer(),
                      child: isLoading ? CircularProgressIndicator(color: Colors.white,
                      ) :Text(
                        'Add Customer',
                        style: const TextStyle(color: Colors.white),
                      ) ));
              }
          ),
        ],
      ),
    );
  }
}
