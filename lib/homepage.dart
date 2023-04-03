import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_email_component/create_record.dart';
import 'package:flutter_email_component/service/authentication.dart';
import 'package:flutter_email_component/service/database_service.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:mailer/mailer.dart';
import 'package:mailer/smtp_server/gmail.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final DatabaseService _databaseService = DatabaseService();

  Future sendMail(String subject, String text) async {
    final _googleSignIn = GoogleSignIn();
    if (await _googleSignIn.isSignedIn()) {
      final user = _googleSignIn.currentUser;
print(_googleSignIn.currentUser?.email);
      final auth = await user?.authentication;
      final token = auth?.idToken;
      String? email = 'liritharantest@gmail.com';

      print(user?.email);
      final smtpServer = gmailSaslXoauth2(email!, token!);

      final message = Message()
        ..from = Address(email, 'Your name')
        ..recipients.add('lirininfo@gmail.com')
        ..ccRecipients.addAll(['destCc1@example.com', 'destCc2@example.com'])
        ..bccRecipients.add(Address('bccAddress@example.com'))
        ..subject = '$subject :: 😀 :: ${DateTime.now()}'
        ..text = text
        ..html = "<h1>Test</h1>\n<p>Hey! Here's some HTML content</p>";
    } else {
      return await _googleSignIn.signIn();
    }

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Homepage'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [buttons(true, context), buttons(false, context)],
        ),
      ),
    );
  }

  Widget buttons(bool isCreate, BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 10),
      child: SizedBox(
          width: 150,
          height: 50,
          child: ElevatedButton(
              onPressed: () async {
                isCreate
                    ? Navigator.push(context,
                        MaterialPageRoute(builder: (_) => const CreateRecord()))
                    : {
                        await _databaseService.getError('Error').then((value) =>
                            value.forEach((element) async {
                              print(element.transDes);
                              try {
                                final sendReport = await sendMail(
                                    element.transDes.toString(),
                                    element.transStatus.toString());

                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text('Mail Sent'),
                                  ),
                                );
                              } on MailerException catch (e) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text(e.message),
                                  ),
                                );
                                print('Message not sent.');
                                print(e.message);
                                for (var p in e.problems) {
                                  print('Problem: ${p.code}: ${p.msg}');
                                }
                              }
                            }))
                      };
              },
              child: isCreate
                  ? const Text('Create Record')
                  : const Text('Send Mail'))),
    );
  }
}
