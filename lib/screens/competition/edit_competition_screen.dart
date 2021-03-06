import 'package:cm_flutter/firebase/firestore_provider.dart';
import 'package:cm_flutter/models/competition.dart';
import 'package:cm_flutter/styles/colors.dart';
import 'package:cm_flutter/utils/datetime_provider.dart';
import 'package:cm_flutter/widgets/color_gradient_button.dart';
import 'package:cm_flutter/widgets/competition/uploading_dialog.dart';
import 'package:cm_flutter/widgets/date_dropdown_box.dart';
import 'package:cm_flutter/widgets/label_text_field.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import 'dart:async';
import 'dart:io';

class EditCompetitionScreen extends StatefulWidget {
  final Competition competition;

  EditCompetitionScreen({this.competition});

  @override
  _EditCompetitionScreenState createState() => _EditCompetitionScreenState();
}

class _EditCompetitionScreenState extends State<EditCompetitionScreen> {
  FirestoreProvider db;
  DateTimeProvider dateTime;
  Competition competition;
  TextEditingController competitionNameController;
  TextEditingController organizerController;
  TextEditingController locationController;
  TextEditingController descriptionController;
  DateTime compDate;
  File competitionImage;

  bool uploading = false;

  @override
  void initState() {
    super.initState();
    db = FirestoreProvider();
    dateTime = DateTimeProvider();
    competition = widget.competition;
    competitionNameController = TextEditingController();
    competitionNameController.text = widget.competition.name;
    organizerController = TextEditingController();
    organizerController.text = widget.competition.organizer;
    locationController = TextEditingController();
    locationController.text = widget.competition.location;
    descriptionController = TextEditingController();
    descriptionController.text = widget.competition.description;
    compDate = widget.competition.date;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: buildAppBar(),
      body: SafeArea(
        child: Stack(
          children: <Widget>[
            buildCreateForm(),
            uploading ? UploadingDialog() : Container()
          ],
        ),
      ),
    );
  }

  // Builds the description text and the text field.
  Widget buildCreateForm() {
    return ListView(
      children: <Widget>[
        buildPhotoContainer(context),
        Padding(
          padding: const EdgeInsets.only(top:16.0, left: 16.0, right: 16.0, bottom: 8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              LabelTextField(
                labelText: 'Competition Name',
                textController: competitionNameController,
              ),
              SizedBox(height: 8.0),
              LabelTextField(
                labelText: 'Organizer',
                textController: organizerController,
              ),
              SizedBox(height: 8.0),
              LabelTextField(
                labelText: 'Location',
                textController: locationController,
              ),
              SizedBox(height: 8.0),
              Text(
                'Date',
                style: TextStyle(
                  fontSize: 16.0,
                  fontWeight: FontWeight.w500,
                ),
              ),
              DateDropdownBox(
                date: compDate,
                onTap: () {
                  dateTime.pickDate(context, compDate).then((date) {
                    if (date != null) {
                      setState(() {
                        compDate = date;
                      });
                    }
                  });
                },
              ),
              SizedBox(height: 8.0),
              buildDeleteButton(context)
            ],
          ),
        )
      ],
    );
  }

  ColorGradientButton buildDeleteButton(BuildContext context) {
    return ColorGradientButton(
      text: 'Delete Competition',
      color: kWarningRed,
      onPressed: () {
        db.deleteCompetition(widget.competition.id);
        // TODO: Change the popUntil. Need to define route names.
        Navigator.pop(context);
        Navigator.pop(context);
      },
    );
  }

  Widget buildPhotoContainer(BuildContext context) {
    if (competition.imageUrl == null) {
      // If image_url has not loaded yet
      return Container(
        height: MediaQuery.of(context).size.height / 3,
        color: Colors.black26,
      );
    } else if (competition.imageUrl == '' && competitionImage == null) {
      // If image_url is empty
      return GestureDetector(
        onTap: () {
          uploadImage(context);
        },
        child: Container(
          height: MediaQuery.of(context).size.height / 3,
          decoration: BoxDecoration(
            color: Colors.black26,
          ),
          child: Center(
            child: Container(
              width: 100.0,
              height: 40.0,
              decoration: BoxDecoration(
                color: Colors.transparent,
                border: Border.all(color: Colors.white),
                borderRadius: BorderRadius.circular(5.0),
              ),
              child: Center(
                child: Text(
                  'Upload photo',
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ),
          ),
        ),
      );
    } else {
      // If there is an image to display
      return GestureDetector(
        onTap: () {
          uploadImage(context);
        },
        child: Container(
          height: MediaQuery.of(context).size.height / 3,
          child: Stack(
            fit: StackFit.expand,
            children: <Widget>[
              competitionImage == null
                  ? Image.network(competition.imageUrl, fit: BoxFit.cover)
                  : Image.file(competitionImage, fit: BoxFit.cover),
              Center(
                child: Container(
                  width: 100.0,
                  height: 40.0,
                  decoration: BoxDecoration(
                    color: Color.fromRGBO(0, 0, 0, 0.5),
                    border: Border.all(color: Colors.white),
                    borderRadius: BorderRadius.circular(5.0),
                  ),
                  child: Center(
                    child: Text(
                      'Edit photo',
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      );
    }
  }

  Future<void> uploadImage(BuildContext context) async {
    var image = await ImagePicker.pickImage(source: ImageSource.gallery);

    setState(() {
      competitionImage = image;
    });
  }

  AppBar buildAppBar() {
    return AppBar(
      centerTitle: true,
      title: Text(
        'Edit Competition',
        style: TextStyle(color: Colors.black),
      ),
      backgroundColor: Color.fromRGBO(255, 255, 255, 0.85),
      elevation: 1.0,
      iconTheme: IconThemeData(color: Colors.black),
      leading: BackButton(),
      actions: <Widget>[
        Padding(
          padding: const EdgeInsets.only(right: 8.0),
          child: IconButton(
            icon: Icon(
              Icons.check,
              size: 32.0,
            ),
            onPressed: () async {
              if (compDate != null &&
                  competitionNameController.text != '' &&
                  organizerController.text != '' &&
                  locationController.text != '') {
                setState(() {
                  uploading = true;
                });
                Map<String, dynamic> data = {
                  'name': competitionNameController.text,
                  'organizer': organizerController.text,
                  'location': locationController.text,
                  'date': compDate,
                };

                db.updateCompetition(widget.competition.id, data);
                if (competitionImage != null) {
                  await db.uploadToFirebaseStorage(competitionImage, widget.competition.id);
                }
                Navigator.pop(context);
              }
            },
          ),
        )
      ],
    );
  }
}
