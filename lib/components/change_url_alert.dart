import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:ozone_erp/widgets/print_button.dart';

// void changeUrlAlert({
//   required BuildContext context,
//   required Size size,
// }) {
//   TextEditingController baseUrlController = TextEditingController();
//   TextEditingController companyIdController = TextEditingController();
//   baseUrlController.text = AppData().getBaseUrl();
//   companyIdController.text = AppData().getCompanyID();
//   showDialog(
//     context: context,
//     builder: (context) {
//       return AlertDialog(
//         actionsPadding: const EdgeInsets.all(0),
//         content: Column(
//           mainAxisSize: MainAxisSize.min,
//           children: [
//             const Text('Change URL'),
//             Padding(
//               padding: const EdgeInsets.symmetric(vertical: 18.0),
//               child: TextFormField(
//                 controller: baseUrlController,
//                 decoration: const InputDecoration(
//                   // border: InputBorder.none,
//                   // focusedBorder: InputBorder.none,
//                   // enabledBorder: InputBorder.none,
//                   hintText: 'Base URL',
//                   label: Text('Base URL'),
//                 ),
//               ),
//             ),
//             Padding(
//               padding: const EdgeInsets.symmetric(vertical: 18.0),
//               child: TextFormField(
//                 controller: companyIdController,
//                 decoration: const InputDecoration(
//                   // border: InputBorder.none,
//                   // focusedBorder: InputBorder.none,
//                   // enabledBorder: InputBorder.none,
//                   hintText: 'Company ID',
//                   label: Text('Company ID'),
//                 ),
//               ),
//             ),
//             Padding(
//               padding: const EdgeInsets.only(top: 18.0),
//               child: PrintButton(
//                 child: const Text('OK', style: TextStyle(color: Colors.white),),
//                 onTap: () {
//                   String previousBaseUrl = AppData().getBaseUrl();
//                   String previousCompanyID = AppData().getCompanyID();
//                   AppData().storeBaseUrl(baseUrlController.text);
//                   AppData().storeCompanyID(companyIdController.text);
//                   String newBaseUrl = AppData().getBaseUrl();
//                   String newCompanyID = AppData().getCompanyID();
//                   Navigator.pop(context);
//                   if(previousBaseUrl != newBaseUrl || previousCompanyID != newCompanyID) {
//                     showRestartAlert(context);
//                   }
//                 },
//               ),
//             )
//           ],
//         ),
//       );
//     },
//   );
// }

showRestartAlert(BuildContext context) {
  showDialog(
      context: context,
      builder: (context) => AlertDialog(
            title: const Text('Restart App?'),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Padding(
                  padding: EdgeInsets.all(18.0),
                  child: Text('Please Restart the app to fully apply changes.'),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 18.0),
                  child: PrintButton(
                    child: const Text(
                      'Restart App',
                      style: TextStyle(color: Colors.white),
                    ),
                    onTap: () {
                      SystemNavigator.pop();
                    },
                  ),
                )
              ],
            ),
          ));
}

showAlert(
    {required BuildContext context,
    required String title,
    required String content}) {
  showDialog(
    context: context,
    builder: (context) {
      return AlertDialog(
        title: Text(title),
        content: Text(content),
        actions: [
          TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text('OK'))
        ],
      );
    },
  );
}
