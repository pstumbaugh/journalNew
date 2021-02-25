import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/journal.dart';

import '../screens/journal_detail_screen.dart';

class JournalListItem extends StatefulWidget {
  @override
  _JournalListItemState createState() => _JournalListItemState();
}

class _JournalListItemState extends State<JournalListItem> {
  Widget _displayJournalName(
      BuildContext context, String text, String journalName) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 10, 0, 3),
      child: Row(
        children: <Widget>[
          Expanded(
            child: Text(
              text + journalName,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 15,
                fontFamily: 'Roboto',
                color: Colors.black,
              ),
              maxLines: 1,
              overflow: TextOverflow.clip,
              softWrap: false,
            ),
          ),
        ],
      ),
    );
  }

  Widget _displayJournalSubItem(String text, String journalItem) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 0, 0, 3),
      child: Row(
        children: <Widget>[
          Expanded(
            child: Text(
              text + journalItem,
              textAlign: TextAlign.left,
              style: TextStyle(
                color: Colors.black,
                fontSize: 15,
                fontFamily: 'Roboto',
              ),
              maxLines: 3,
              overflow: TextOverflow.clip,
              softWrap: false,
            ),
          ),
        ],
      ),
    );
  }

  Widget _displayDateTime(String createdAt) {
    return Container(
      alignment: Alignment.bottomRight,
      padding: EdgeInsets.fromLTRB(0, 0, 15, 5),
      child: Text(
        createdAt,
        style: TextStyle(
          color: Colors.black,
          fontSize: 15,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final journals = Provider.of<Journal>(context, listen: false);

    return Container(
      padding: EdgeInsets.only(bottom: 5),
      child: InkWell(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => JournalDetailScreen(),
              settings: RouteSettings(arguments: journals.id),
            ),
          );
        },
        child: Container(
          margin: EdgeInsets.only(bottom: 15),
          decoration: BoxDecoration(
            border: Border.all(color: Colors.grey),
            color: Colors.white,
            borderRadius: BorderRadius.circular(8),
          ),
          width: double.infinity,
          child: Column(
            children: <Widget>[
              _displayJournalName(
                context,
                'Title: ',
                journals.title,
              ),
              _displayJournalSubItem(
                'Body: ',
                journals.body,
              ),
              _displayDateTime(
                journals.createdAt,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
