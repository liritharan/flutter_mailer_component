import 'package:flutter/material.dart';
import 'package:flutter_email_component/model/database_model.dart';
import 'package:flutter_email_component/service/database_service.dart';
import 'package:flutter_email_sender/flutter_email_sender.dart';
import 'package:intl/intl.dart';
import 'package:sqflite/sqflite.dart';

class CreateRecord extends StatefulWidget {
  const CreateRecord({Key? key}) : super(key: key);

  @override
  State<CreateRecord> createState() => _CreateRecordState();
}

class _CreateRecordState extends State<CreateRecord> {
  final TextEditingController description = TextEditingController();
  final TextEditingController status = TextEditingController();
  final _recipientController = TextEditingController(
    text: 'lirininfo@gmail.com',
  );
  final DatabaseService _databaseService = DatabaseService();
@override
  void initState() {

    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    var now = DateTime.now();
    var formatter = DateFormat('dd-MM-yyyy  hh:mm');
    String formattedDate = formatter.format(now);
    return Scaffold(
        appBar: AppBar(
          title: const Text('Create Record'),
        ),
        body: SingleChildScrollView(
          child: Column(
            children: [
              textField('Transaction Description', description),
              textField('Transaction Status', status),
              showDate(formattedDate),
              Center(
                  child: ElevatedButton(
                      onPressed: () async {
                        print(formattedDate);
                        send();
                        _databaseService.insertRecord(DatabaseModel(transDes: description.text,transStatus: status.text,date: formattedDate));
                        _databaseService.getRecord();
                      },
                      child: const Text('Submit')))
            ],
          ),
        ));
  }
Future<List<DatabaseModel>> getRecord() async{
  return await _databaseService.getRecord();

}

Future<void> send() async {
    final Email email = Email(
      body: description.text,
      subject: status.text,
      recipients: [_recipientController.text],
      isHTML: false,
    );

    String platformResponse;

    try {
      await FlutterEmailSender.send(email);
      platformResponse = 'success';
    } catch (error) {
      print(error);
      platformResponse = error.toString();
    }

    if (!mounted) return;

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(platformResponse),
      ),
    );
  }

  Widget textField(
    String text,
    TextEditingController controller,
  ) {
    return Padding(
      padding: const EdgeInsets.all(10),
      child: TextField(
        controller: controller,
        decoration: InputDecoration(
            labelText: text, border: const OutlineInputBorder()),
      ),
    );
  }

  Widget showDate(String currentDate) {
    return Padding(
      padding: const EdgeInsets.all(10),
      child: TextField(
        readOnly: true,
        decoration: InputDecoration(
            hintText: currentDate, border: const OutlineInputBorder()),
      ),
    );
  }
}
