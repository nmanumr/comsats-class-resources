import 'package:class_resources/components/centered-appbar.dart';
import 'package:class_resources/components/input.dart';
import 'package:class_resources/services/courses.dart';
import 'package:class_resources/utils/drive-api.dart';
import 'package:class_resources/utils/file-size.dart';
import 'package:flutter/material.dart';
import 'package:googleapis/drive/v3.dart';
import 'package:intl/intl.dart';

class AddResource extends StatefulWidget {
  AddResource({@required this.userName, @required this.courseId});

  final String userName;
  final String courseId;

  @override
  _AddResourceState createState() => _AddResourceState();
}

class _AddResourceState extends State<AddResource> {
  PageController _pageController = PageController();
  TextEditingController _driveLinkController = TextEditingController();
  TextEditingController _fileNameController = TextEditingController();
  CoursesService _coursesService = CoursesService();

  String linkError;
  String mimeType;
  String extension;
  String webLink;
  String contentLink;
  String fileSize;
  DriveApi _driveApi;

  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    GoogleDriveApiLoader().load().then((api) {
      setState(() {
        this._driveApi = api;
        isLoading = false;
      });
    });
  }

  paddedText(String text, {double left}) {
    return Opacity(
      opacity: 0.7,
      child: Padding(
        padding: EdgeInsets.fromLTRB(left ?? 20, 6, 20, 6),
        child: Text(text),
      ),
    );
  }

  paddedTile(title, subtitle) {
    return ListTile(
      title: Padding(
        padding: const EdgeInsets.only(left: 10),
        child: Text(title),
      ),
      subtitle: Padding(
        padding: const EdgeInsets.only(left: 10),
        child: Text(subtitle ?? ""),
      ),
    );
  }

  getDriveLink() async {
    if (_driveLinkController.text.isEmpty) return;

    setState(() {
      linkError = null;
      isLoading = true;
    });
    try {
      File file = await _driveApi.files.get(
        _driveLinkController.text,
        $fields:
            "name, mimeType, webViewLink, webContentLink, fileExtension, size",
      );

      setState(() {
        _fileNameController.text = file.name;
        mimeType = file.mimeType;
        webLink = file.webViewLink;
        contentLink = file.webContentLink;
        extension = file.fileExtension;
        fileSize = filesize(int.parse(file.size));
        isLoading = false;
      });
      _pageController.nextPage(
        curve: Curves.easeOutExpo,
        duration: Duration(milliseconds: 700),
      );
    } catch (e) {
      setState(() {
        isLoading = false;
        linkError = e.message;
      });
    }
  }

  saveResource() async {
    setState(() => isLoading = true);
    try {
      await _coursesService.addResourceToCourse(
        name: _fileNameController.text,
        courseId: widget.courseId,
        date: DateTime.now(),
        driveFileId: _driveLinkController.text,
        ext: extension,
        mimeType: mimeType,
        uploadedBy: widget.userName,
      );
      Navigator.pop(context);
    } catch (e) {
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: centeredAppBar(
        context,
        "Add Resource",
        leading: IconButton(
          icon: Icon(Icons.close),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: PageView(
        controller: _pageController,
        physics: NeverScrollableScrollPhysics(),
        children: <Widget>[
          ListView(
            children: [
              isLoading ? LinearProgressIndicator() : SizedBox(height: 8),
              Image.asset(
                "assets/images/google-drive.png",
                height: 230,
              ),
              Align(
                alignment: Alignment.center,
                child: Text(
                  "Drive File Link",
                  style: Theme.of(context).textTheme.headline,
                ),
              ),
              SizedBox(height: 25),
              paddedText("Step 1: Upload file to google drive."),
              paddedText("Step 2: Preview file."),
              paddedText(
                  "Step 2: Select \"Open in new Window\" from right menu options."),
              paddedText(
                  "Step 2: Paste the link below which should look like:"),
              paddedText("https://drive.google.com/file/d/{FILE_ID}/view",
                  left: 40),
              SizedBox(height: 15),
              PaddedInput(
                label: "Drive file id",
                errorText: linkError,
                controller: _driveLinkController,
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    RaisedButton.icon(
                      label: Text("Back"),
                      icon: Icon(Icons.keyboard_arrow_left),
                      onPressed: null,
                    ),
                    RaisedButton(
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: <Widget>[
                          Text("Next"),
                          const SizedBox(width: 8.0),
                          Icon(Icons.keyboard_arrow_right),
                        ],
                      ),
                      onPressed: getDriveLink,
                    ),
                  ],
                ),
              )
            ],
          ),
          ListView(
            children: <Widget>[
              isLoading ? LinearProgressIndicator() : SizedBox(height: 8),
              PaddedInput(
                label: "File Name",
                controller: _fileNameController,
              ),
              paddedTile("File Size", fileSize),
              paddedTile("Mime Type", mimeType),
              paddedTile("File Extension", extension),
              paddedTile(
                "Creation Date",
                DateFormat("EEE, MMMM d, yyyy").format(DateTime.now()),
              ),
              paddedTile("Added by", widget.userName),
              paddedTile("Download Link", contentLink),
              paddedTile("Web Link", webLink),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    RaisedButton.icon(
                      label: Text("Back"),
                      icon: Icon(Icons.keyboard_arrow_left),
                      onPressed: () {
                        _pageController.previousPage(
                          curve: Curves.easeOutExpo,
                          duration: Duration(milliseconds: 700),
                        );
                      },
                    ),
                    RaisedButton.icon(
                      icon: Icon(Icons.done),
                      label: Text("Save"),
                      onPressed: isLoading ? null : saveResource,
                    ),
                  ],
                ),
              )
            ],
          ),
        ],
      ),
    );
  }
}
