import 'package:cryptoapp/features/cryptoapp/domain/entities/items.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class CryptoItem extends StatelessWidget {
  const CryptoItem(this.item);

  final Items item;

  @override
  Widget build(BuildContext context) {
    String format;
    if (item.logoUrl.isNotEmpty) {
      format = item.logoUrl.substring(item.logoUrl.length - 3);
    } else {
      format = "null";
    }
    return Card(
      child: InkWell(
        onTap: () {
          Navigator.of(context).pushNamed('/cryptodetails', arguments: item);
        },
        child: SizedBox(
          height: MediaQuery.of(context).orientation == Orientation.portrait
              ? MediaQuery.of(context).size.height * 0.15
              : MediaQuery.of(context).size.height * 0.20,
          width: MediaQuery.of(context).size.width,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Padding(
                padding: const EdgeInsets.only(
                  left: 15.0,
                ),
                child: Container(
                  width:
                      MediaQuery.of(context).orientation == Orientation.portrait
                          ? MediaQuery.of(context).size.height * 0.10
                          : MediaQuery.of(context).size.height * 0.15,
                  height:
                      MediaQuery.of(context).orientation == Orientation.portrait
                          ? MediaQuery.of(context).size.height * 0.10
                          : MediaQuery.of(context).size.height * 0.15,
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
              SizedBox(width: 30),
              Expanded(
                child: Text(
                  item.name,
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.w400),
                ),
              ),
              SizedBox(
                width: 15,
              ),
              Padding(
                padding: const EdgeInsets.only(right: 15.0),
                child: Text(
                  num.parse(item.price).toStringAsFixed(3) + " \$",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
