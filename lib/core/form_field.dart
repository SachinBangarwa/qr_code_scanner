
import 'package:flutter/cupertino.dart';

final Map<String, List<Map<String, dynamic>>> formFields = {
  'Text': [
    {'label': 'Text', 'hint': 'Enter your text', 'inputType': TextInputType.text},
  ],
  'Website': [
    {'label': 'Website URL', 'hint': 'Enter URL (e.g., www.example.com)', 'inputType': TextInputType.url},
  ],
  'Wi-Fi': [
    {'label': 'Network', 'hint': 'Enter network name', 'inputType': TextInputType.text},
    {'label': 'Password', 'hint': 'Enter password', 'inputType': TextInputType.visiblePassword},
  ],
  'Event': [
    {'label': 'Event Name', 'hint': 'Enter event name', 'inputType': TextInputType.text},
    {'label': 'Start Date and Time', 'hint': 'Enter start date and time', 'inputType': TextInputType.datetime},
    {'label': 'End Date and Time', 'hint': 'Enter end date and time', 'inputType': TextInputType.datetime},
    {'label': 'Event Location', 'hint': 'Enter location', 'inputType': TextInputType.text},
    {'label': 'Description', 'hint': 'Enter any detail', 'inputType': TextInputType.text},
  ],
  'Contact': [
    {'label': 'First Name', 'hint': 'Enter name', 'inputType': TextInputType.text,'isRow':true},
    {'label': 'Last Name', 'hint': 'Enter name', 'inputType': TextInputType.text},
    {'label': 'Company', 'hint': 'Enter company', 'inputType': TextInputType.text,'isRow':true},
    {'label': 'Job', 'hint': 'Enter job', 'inputType': TextInputType.text,},
    {'label': 'Phone', 'hint': 'Enter number', 'inputType': TextInputType.number,'isRow':true},
    {'label': 'Email', 'hint': 'Enter email', 'inputType': TextInputType.emailAddress,},
    {'label': 'Website', 'hint': 'Enter website', 'inputType': TextInputType.text,},
    {'label': 'Address', 'hint': 'Enter address', 'inputType': TextInputType.streetAddress,},
    {'label': 'City', 'hint': 'Enter city', 'inputType': TextInputType.text,'isRow':true},
    {'label': 'Country', 'hint': 'Enter country', 'inputType': TextInputType.text,'isRow':true},
  ],
  'Business': [
    {'label': 'Company Name', 'hint': 'Enter name', 'inputType': TextInputType.text},
    {'label': 'Industry', 'hint': 'Enter industry (e.g Food/Agency)', 'inputType': TextInputType.text},
    {'label': 'Phone', 'hint': 'Enter phone', 'inputType': TextInputType.phone,'isRow':true},
    {'label': 'Email', 'hint': 'Enter email', 'inputType': TextInputType.emailAddress},
    {'label': 'Website', 'hint': 'Enter website', 'inputType': TextInputType.text},
    {'label': 'Address', 'hint': 'Enter address', 'inputType': TextInputType.text},
    {'label': 'City', 'hint': 'Enter city', 'inputType': TextInputType.text,},
    {'label': 'Country', 'hint': 'Enter country', 'inputType': TextInputType.text,'isRow':true},
  ],
  'WhatsApp':[
    {'label': 'WhatsApp Number', 'hint': 'Enter number', 'inputType': TextInputType.number},
  ],
  'Twitter':[
    {'label': 'Username', 'hint': 'Enter twitter username', 'inputType': TextInputType.text},
  ],
  'Email':[
    {'label': 'Email', 'hint': 'Enter email address', 'inputType': TextInputType.emailAddress},
  ],
  'Instagram':[
    {'label': 'Username', 'hint': 'Enter instagram username', 'inputType': TextInputType.text},
  ] ,
  'Telegram':[
    {'label': 'Phone Number', 'hint': '+92xxxxxxxxxx', 'inputType': TextInputType.number},
  ] ,
  'Location':[
    {'label': 'Place Location', 'hint': 'Enter location', 'inputType': TextInputType.text},
  ]
};