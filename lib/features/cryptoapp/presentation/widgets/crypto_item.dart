import 'package:cryptoapp/features/cryptoapp/domain/entities/items.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class CryptoItem extends StatelessWidget {
  const CryptoItem(this.item);

  final Items item;

  @override
  Widget build(BuildContext context) {
    String format;
    format = item.logoUrl.substring(item.logoUrl.length - 3);
    return Card(
      child: InkWell(
        onTap: () {
          Navigator.of(context).pushNamed('/cryptodetails', arguments: item);
        },
        child: SizedBox(
          height: MediaQuery.of(context).size.height * 0.15,
          width: MediaQuery.of(context).size.width,
          child: Row(
            children: [
              Padding(
                padding: const EdgeInsets.only(left: 15.0),
                child: Container(
                  width: MediaQuery.of(context).size.height * 0.10,
                  height: MediaQuery.of(context).size.height * 0.10,
                  child: (format == 'svg')
                      ? SvgPicture.network(
                          item.logoUrl,
                          fit: BoxFit.fill,
                        )
                      : Image.network(
                          item.logoUrl,
                          fit: BoxFit.fill,
                        ),
                ),
              ),
              SizedBox(width: 30),
              Text(item.name),
              SizedBox(
                width: 15,
              ),
              Text(num.parse(item.price).toStringAsFixed(3) + " \$")
            ],
          ),
        ),
      ),
    );
  }
}
