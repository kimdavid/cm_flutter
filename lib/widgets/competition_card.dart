import 'package:cm_flutter/models/competition.dart';
import 'package:cm_flutter/screens/competition/view_competition_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class CompetitionCard extends StatefulWidget {
  final Competition competition;
  final FirebaseUser user;

  CompetitionCard({this.competition, this.user});

  @override
  _CompetitionCardState createState() => _CompetitionCardState();
}

class _CompetitionCardState extends State<CompetitionCard> {
  String formattedDate;
  String formattedTime;

  @override
  void initState() {
    super.initState();
    formattedDate =
        DateFormat('EEE, MMMM d, yyyy').format(widget.competition.date);
    formattedTime = DateFormat('jm').format(widget.competition.date);
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Route route = MaterialPageRoute(
          builder: (BuildContext context) =>
              ViewCompetitionScreen(widget.competition, widget.user),
        );
        Navigator.of(context).push(route);
      },
      child: Container(
        color: Colors.transparent, // Expands touch zone
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            buildPhotoContainer(),
            SizedBox(width: 16.0),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    widget.competition.name,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontSize: 16.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 8.0),
                  RichText(
                    text: TextSpan(
                      style: TextStyle(fontSize: 12.0, color: Colors.black54),
                      children: <TextSpan>[
                        TextSpan(text: 'Hosted by '),
                        TextSpan(
                          text: widget.competition.organizer,
                          style: TextStyle(color: Colors.black),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 8.0),
                  Text(
                    '$formattedDate • $formattedTime',
                    style: TextStyle(fontSize: 12.0, color: Colors.black54),
                  ),
                  SizedBox(height: 8.0),
                  Text(
                    widget.competition.location,
                    style: TextStyle(fontSize: 12.0, color: Colors.black54),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Container buildPhotoContainer() {
    return Container(
      width: 125.0,
      height: 100.0,
      decoration: BoxDecoration(
        border: Border.all(color: Color.fromRGBO(0, 0, 0, 0.1)),
        borderRadius: BorderRadius.circular(5.0),
        color: Colors.white,
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(5.0),
        child: Hero(
          tag: widget.competition.id,
          child: Image.network(
            widget.competition.imageUrl,
            fit: BoxFit.cover,
          ),
        ),
      ),
    );
  }
}
