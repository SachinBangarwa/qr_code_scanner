import 'package:flutter/material.dart';

class QrGenerateModel {
  String name;
  Icon icon;

  QrGenerateModel({required this.name, required this.icon});

  static List<QrGenerateModel> content = [
    QrGenerateModel(
        name: 'Text',
        icon: const Icon(
          Icons.text_decrease,
          color: Colors.yellow,
        )),
    QrGenerateModel(
        name: 'Website',
        icon: const Icon(
          Icons.web,
          color: Colors.yellow,
        )),
    QrGenerateModel(
        name: 'Wi-Fi',
        icon: const Icon(
          Icons.wifi,
          color: Colors.yellow,
        )),
    QrGenerateModel(
        name: 'Event',
        icon: const Icon(
          Icons.event_available,
          color: Colors.yellow,
        )),
    QrGenerateModel(
        name: 'Contact',
        icon: const Icon(
          Icons.perm_contact_calendar_rounded,
          color: Colors.yellow,
        )),
    QrGenerateModel(
        name: 'Business',
        icon: const Icon(
          Icons.business,
          color: Colors.yellow,
        )),
    QrGenerateModel(
        name: 'Location',
        icon: const Icon(
          Icons.share_location,
          color: Colors.yellow,
        )),
    QrGenerateModel(
        name: 'WhatsApp',
        icon: const Icon(
          Icons.whatshot,
          color: Colors.yellow,
        )),
    QrGenerateModel(
        name: 'Email',
        icon: Icon(Icons.mark_email_unread, color: Colors.yellow)),
    QrGenerateModel(
        name: 'Twitter',
        icon: const Icon(
          Icons.tiktok,
          color: Colors.yellow,
        )),
    QrGenerateModel(
        name: 'Instagram',
        icon: const Icon(
          Icons.games_outlined,
          color: Colors.yellow,
        )),
    QrGenerateModel(
        name: 'Telegram',
        icon: const Icon(Icons.phone_callback, color: Colors.yellow)),
  ];
}
