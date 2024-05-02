import 'dart:convert';

import 'package:http/http.dart' as http;

class SendEmail {
  static void sendEmail(
      {required List<String> email,
      required String subject,
      required String projectName}) async {
    print('abc');
    var url = Uri.parse('https://api.emailjs.com/api/v1.0/email/send');
    var response = await http.post(
      url,
      headers: {
        'origin': 'http://localhost',
        'Content-Type': 'application/json',
      },
      body: json.encode({
        'service_id': 'service_spwa2kr',
        'template_id': 'template_jhguqe8',
        'user_id': 'WZKKMeonvPWvFPHeX',
        'accessToken': 'WtviwA5S2iCvdzvVrkecP',
        'template_params': {
          'to_user': email,
          'subject': subject,
          'projectName': projectName,
          'to_name': "Aliza"
        },
      }),
    );
    print('abc');
    print(response.statusCode);
    print(response.body);
  }
}
