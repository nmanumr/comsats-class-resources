import 'package:class_resources/utils/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class TextAvatar extends StatelessWidget {
  TextAvatar({@required this.text, this.photoUrl});

  final String text;
  final String photoUrl;

  String getAvatarText(String text) {
    var words = (text ?? "").split(" ");
    words.remove("&");
    if (words.length > 2) words = words.sublist(0, 2);
    return words
        .map((f) => ((f.length > 0) ? f[0] : ""))
        .join("")
        .toUpperCase();
  }

  @override
  Widget build(BuildContext context) {
    String avatarText = getAvatarText(this.text);
    Color color = HexColor(generateColor(text));

    return CircleAvatar(
      backgroundImage: photoUrl == null ? null : NetworkImage(photoUrl),
      child: photoUrl == null ? Text(avatarText) : null,
      backgroundColor: color.withAlpha(175),
      foregroundColor: Colors.white,
    );
  }
}

class FileTypeAvatar extends StatelessWidget {
  FileTypeAvatar({@required this.fileType});

  final String fileType;

  getIconPath() {
    Map<String, String> iconsName = {
      "doc": "doc.svg",
      "docx": "doc.svg",
      "exe": "exe.svg",
      "jpg": "jpg.svg",
      "jpeg": "jpg.svg",
      "png": "png.svg",
      "mp4": "mp4.svg",
      "ppt": "ppt.svg",
      "pptx": "ppt.svg",
      "pdf": "pdf.svg",
      "rtf": "rtf.svg",
      "xls": "xls.svg",
      "xlsx": "xls.svg"
    };

    if (fileType != null) {
      return "assets/file-icons/" + (iconsName[fileType] ?? "file.svg");
    }
    return "assets/file-icons/file.svg";
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(top: 5),
      child: SizedBox(
        height: 36,
        child: SvgPicture.asset(getIconPath()),
      ),
    );
  }
}
