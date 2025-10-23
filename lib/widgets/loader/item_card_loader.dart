import 'package:flutter/material.dart';
import 'package:ozone_erp/widgets/loader/loading_widget.dart';
import '../../constants/constant.dart';

class ItemCardLoader extends StatelessWidget {
  const ItemCardLoader({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            LoadingWidget(
                width: SizeConstant.screenWidth * .35,
                height: SizeConstant.screenWidth * .35),
            const SizedBox(
              width: 30,
            ),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const LoadingWidget(width: double.infinity, height: 16),
                  const SizedBox(
                    height: 10,
                  ),
                  LoadingWidget(
                      width: SizeConstant.screenWidth * .4, height: 14),
                  const SizedBox(
                    height: 10,
                  ),
                  LoadingWidget(
                      width: SizeConstant.screenWidth * .3, height: 22),
                ],
              ),
            )
          ],
        ),
        Row(
          children: [
            Expanded(
                child: Container(
              height: 50,
              alignment: Alignment.center,
              decoration:
                  BoxDecoration(border: Border.all(color: Colors.black12)),
              child: LoadingWidget(
                  width: SizeConstant.screenWidth * .2, height: 16),
            )),
            Expanded(
                child: Container(
              height: 50,
              alignment: Alignment.center,
              decoration:
                  BoxDecoration(border: Border.all(color: Colors.black12)),
              child: LoadingWidget(
                  width: SizeConstant.screenWidth * .2, height: 16),
            )),
          ],
        )
      ],
    );
  }
}
