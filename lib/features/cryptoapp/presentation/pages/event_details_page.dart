import 'package:cryptoapp/features/cryptoapp/domain/entities/events_data.dart';
import 'package:flutter/material.dart';
import 'package:flutter_linkify/flutter_linkify.dart';
import 'package:url_launcher/url_launcher.dart';

class EventDetailsPage extends StatelessWidget {
  const EventDetailsPage({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    EventsData eventDetails = ModalRoute.of(context).settings.arguments;

    Future<void> _onOpen(LinkableElement link) async {
      if (await canLaunch(link.url)) {
        await launch(link.url);
      } else {
        throw 'Could not launch $link';
      }
    }

    return Scaffold(
        appBar: AppBar(title: Text(eventDetails.title)),
        body: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Image.network(
                eventDetails.screenshot,
                fit: BoxFit.cover,
              ),
              Divider(),
              Padding(
                padding: EdgeInsets.only(left: 10, right: 10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Text(
                      eventDetails.title,
                      style:
                          TextStyle(fontSize: 25, fontWeight: FontWeight.w500),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 8.0),
                      child: Row(
                        children: [
                          Icon(Icons.event_outlined),
                          SizedBox(
                            width: 5,
                          ),
                          Text(eventDetails.startDate
                                  .toString()
                                  .substring(0, 10)
                                  .replaceAll("-", ".") +
                              ' - ' +
                              eventDetails.endDate
                                  .toString()
                                  .substring(0, 10)
                                  .replaceAll("-", ".")),
                        ],
                      ),
                    ),
                    SizedBox(
                      height: 15,
                    ),
                    Text(
                      eventDetails.description,
                      style: TextStyle(fontSize: 17),
                    ),
                    SizedBox(
                      height: 15,
                    ),
                    Row(
                      children: [
                        Icon(Icons.map_outlined),
                        SizedBox(width: 4),
                        Flexible(
                          child: Text(eventDetails.country +
                              ', ' +
                              eventDetails.address),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Row(
                      children: [
                        Icon(Icons.language),
                        SizedBox(width: 4),
                        SelectableLinkify(
                          text: eventDetails.website,
                          onOpen: _onOpen,
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Row(
                      children: [
                        Icon(Icons.email_outlined),
                        SizedBox(width: 4),
                        SelectableLinkify(
                          text: eventDetails.email,
                          onOpen: _onOpen,
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 15,
                    )
                  ],
                ),
              )
            ],
          ),
        ));
  }
}
