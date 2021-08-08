import 'package:cryptoapp/features/cryptoapp/domain/entities/items.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:easy_localization/easy_localization.dart';

Row buildHeader(Items item, BuildContext context, String format) {
  return Row(
    mainAxisAlignment: MainAxisAlignment.spaceBetween,
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Flexible(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              item.name,
              style: TextStyle(fontSize: 35, fontWeight: FontWeight.w600),
            ),
            Text(item.currency + " • " + item.status.tr(),
                style: TextStyle(fontSize: 18)),
          ],
        ),
      ),
      Padding(
        padding: const EdgeInsets.only(right: 8.0, top: 2.0),
        child: SizedBox(
          width: (MediaQuery.of(context).orientation == Orientation.portrait)
              ? MediaQuery.of(context).size.height * 0.10
              : MediaQuery.of(context).size.height * 0.20,
          height: (MediaQuery.of(context).orientation == Orientation.portrait)
              ? MediaQuery.of(context).size.height * 0.10
              : MediaQuery.of(context).size.height * 0.20,
          child: (format == 'svg')
              ? SvgPicture.network(
                  item.logoUrl,
                  fit: BoxFit.fill,
                )
              : (format == 'null')
                  ? Container()
                  : Image.network(
                      item.logoUrl,
                      fit: BoxFit.fill,
                    ),
        ),
      ),
    ],
  );
}
