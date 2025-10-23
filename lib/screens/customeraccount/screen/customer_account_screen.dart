import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ozone_erp/screens/customeraccount/controller/customer_account_controller.dart';
import 'package:ozone_erp/widgets/pop/pop_blocker.dart';
import '../../../components/export_components.dart';
import '../../dashboard/widgets/custom_search_bar.dart';

class CustomerAccountScreen extends StatelessWidget {
  const CustomerAccountScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: customAppBar(title: 'Customer Account'),
      drawer: const CustomMenu(),
      body: const CustomerAccountView(),
    );
  }
}

class CustomerAccountView extends GetView<CustomerAccountController> {
  const CustomerAccountView({super.key});

  @override
  Widget build(BuildContext context) {
    return PopBlocker(
      child: Scaffold(
        body: GetBuilder(builder: (CustomerAccountController controller) {
          return Column(
            children: [
              CustomSearchBar(
                controller: controller.controller,
                onChanged: controller.search,
              ),
              Expanded(
                child: SingleChildScrollView(
                  child: SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: DataTable(
                        columns: [
                          DataColumn(label: Text('ID')),
                          DataColumn(label: Text('Name')),
                          DataColumn(label: Text('Debit')),
                          DataColumn(label: Text('Credit')),
                          DataColumn(label: Text('Balance')),
                        ],
                        rows: List.generate(controller.customerAccList.length,
                            (index) {
                          final cusAcc = controller.customerAccList[index];
                          return DataRow(cells: [
                            DataCell(Text(cusAcc.id ?? '')),
                            DataCell(Text(cusAcc.name ?? '')),
                            DataCell(Text(cusAcc.debit ?? '')),
                            DataCell(Text(cusAcc.credit ?? '')),
                            DataCell(Text(cusAcc.balance ?? '')),
                          ]);
                        }),
                      )),
                ),
              ),
            ],
          );
        }),
      ),
    );
  }
}
