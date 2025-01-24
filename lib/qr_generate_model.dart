import 'package:flutter/material.dart';

class QrGenerateModel {
  String name;
  Icon icon;

  QrGenerateModel({required this.name, required this.icon,});

  static List<QrGenerateModel> content = [
    QrGenerateModel(
      name: 'Text',
      icon: const Icon(Icons.text_fields, color: Color.fromRGBO(253, 182, 35, .9)),
    ),
    QrGenerateModel(
      name: 'Website',
      icon: const Icon(Icons.language, color:Color.fromRGBO(253, 182, 35, .9)),
    ),
    QrGenerateModel(
      name: 'Wi-Fi',
      icon: const Icon(Icons.wifi, color:Color.fromRGBO(253, 182, 35, .9)),
    ),
    QrGenerateModel(
      name: 'Event',
      icon: const Icon(Icons.event_available, color: Color.fromRGBO(253, 182, 35, .9)),
    ),
    QrGenerateModel(
      name: 'Contact',
      icon: const Icon(Icons.perm_contact_calendar_rounded, color: Color.fromRGBO(253, 182, 35, .9)),
    ),
    QrGenerateModel(
      name: 'Business',
      icon: const Icon(Icons.business, color:Color.fromRGBO(253, 182, 35, .9)),
    ),
    QrGenerateModel(
      name: 'Location',
      icon: const Icon(Icons.share_location, color:Color.fromRGBO(253, 182, 35, .9)),
    ),
    QrGenerateModel(
      name: 'WhatsApp',
      icon: const Icon(Icons.phone_android, color: Color.fromRGBO(253, 182, 35, .9)),
    ),
    QrGenerateModel(
      name: 'Email',
      icon: const Icon(Icons.mark_email_unread, color:Color.fromRGBO(253, 182, 35, .9)),
    ),
    QrGenerateModel(
      name: 'Twitter',
      icon: const Icon(Icons.alternate_email, color:Color.fromRGBO(253, 182, 35, .9)),
    ),
    QrGenerateModel(
      name: 'Instagram',
      icon: const Icon(Icons.camera_alt, color: Color.fromRGBO(253, 182, 35, .9)),
    ),
    QrGenerateModel(
      name: 'Telegram',
      icon: const Icon(Icons.telegram, color: Color.fromRGBO(253, 182, 35, .9)),
    ),
  ];
}
