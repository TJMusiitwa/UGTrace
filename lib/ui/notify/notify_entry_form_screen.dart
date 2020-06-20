import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import 'package:ug_covid_trace/nav.dart';

class NotifyEntryFormScreen extends StatefulWidget {
  @override
  _NotifyEntryFormScreenState createState() => _NotifyEntryFormScreenState();
}

class _NotifyEntryFormScreenState extends State<NotifyEntryFormScreen> {
  TextEditingController _testID, _testDate;

  @override
  void initState() {
    super.initState();
    _testID = TextEditingController(text: '');
    _testDate = TextEditingController(text: '');
  }

  @override
  void dispose() {
    _testID.dispose();
    _testDate.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return PlatformScaffold(
      appBar: PlatformAppBar(automaticallyImplyLeading: true),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(vertical: 15.0, horizontal: 10.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Text(
              'Share your test result & notify others',
              style: Theme.of(context).textTheme.headline4,
            ),
            SizedBox(height: 20),
            Text(
                'Only those who have been exposed will receive a notification'),
            SizedBox(height: 20),
            Text(
                'Please enter your unique test identifier to verify your positive result'),
            SizedBox(height: 20),
            PlatformTextField(
              controller: _testID,
              textInputAction: TextInputAction.done,
              textAlign: TextAlign.center,
              android: (_) => MaterialTextFieldData(
                decoration: InputDecoration(
                  labelText: 'Test ID',
                  border: OutlineInputBorder(),
                  suffixIcon: IconButton(
                      icon: Icon(Icons.clear),
                      onPressed: () => _testID.clear()),
                ),
              ),
              ios: (_) => CupertinoTextFieldData(
                decoration: BoxDecoration(
                  border: Border.all(),
                  borderRadius: BorderRadius.circular(4.0),
                ),
                placeholder: 'Test ID',
                clearButtonMode: OverlayVisibilityMode.editing,
              ),
            ),
            Divider(height: 2.0),
            SizedBox(height: 20),
            Text(
                'Please enter your test date as this enables the app to know when you might have been infectious and in turn notify the right people of ppossible exposure'),
            SizedBox(height: 20),
            PlatformTextField(
              controller: _testDate,
              textInputAction: TextInputAction.done,
              textAlign: TextAlign.center,
              onTap: () {
                if (Platform.isAndroid) {
                  showDatePicker(
                    context: context,
                    initialDate: DateTime.now(),
                    firstDate: DateTime(2020, 3, 21),
                    lastDate: DateTime(2025),
                  ).then((tested) {
                    setState(() => _testDate.text = tested.toIso8601String());
                  });
                } else if (Platform.isIOS) {
                  CupertinoDatePicker(
                      mode: CupertinoDatePickerMode.date,
                      minimumDate: DateTime(2020, 3, 21),
                      minimumYear: 2019,
                      onDateTimeChanged: (DateTime tested) {
                        setState(() => _testDate.text = tested.toString());
                      });
                }
              },
              android: (_) => MaterialTextFieldData(
                decoration: InputDecoration(
                  labelText: 'Test Date',
                  border: OutlineInputBorder(),
                  suffixIcon: IconButton(
                      icon: Icon(Icons.clear),
                      onPressed: () => _testID.clearComposing()),
                ),
              ),
              ios: (_) => CupertinoTextFieldData(
                decoration: BoxDecoration(
                  border: Border.all(),
                  borderRadius: BorderRadius.circular(4.0),
                ),
                placeholder: 'Test Date',
                clearButtonMode: OverlayVisibilityMode.never,
              ),
            ),
            SizedBox(height: 20),
            PlatformButton(
                child: PlatformText('Next'),
                onPressed: () {
                  showPlatformDialog(
                    builder: (_) => PlatformAlertDialog(
                      title: Text(
                          'Share your random IDs from this device with Ug Covid Trace?'),
                      content: Text(
                          "Sharing your random IDs from the past 14 days helps the app to determine who should be notified that they may have been exposed to COVID-19.\n\n Your identity and test result won't be shared with other people"),
                      actions: <Widget>[
                        PlatformDialogAction(
                          child: Text('Cancel'),
                          onPressed: () => Navigator.pop(context),
                        ),
                        PlatformDialogAction(
                          child: Text('Share'),
                          onPressed: () {
                            //Call the share positive results api endpoint and post to server.
                            print(_testID.text);
                            print(_testDate.text);
                            Navigator.of(context).pushReplacement(
                                platformPageRoute(
                                    builder: (_) => SharingSuccessPage(),
                                    context: context));
                          },
                        ),
                      ],
                    ),
                    context: context,
                  );
                }),
            SizedBox(height: 20),
            PlatformButton(
              child: PlatformText('Cancel'),
              onPressed: () => Navigator.pop(context),
              androidFlat: (_) => MaterialFlatButtonData(),
            )
          ],
        ),
      ),
    );
  }
}

class SharingSuccessPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return PlatformScaffold(
      body: Padding(
        padding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 15.0),
        child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                'Thank you for sharing your test result',
                style: Theme.of(context).textTheme.headline4,
              ),
              SizedBox(height: 20),
              Text(
                  'We continue to remind you to follow the prevention guidelines in place to stop further spread of the disease'),
              Expanded(
                child: Align(
                  alignment: FractionalOffset.bottomCenter,
                  child: Padding(
                      padding: EdgeInsets.only(bottom: 10.0),
                      child: PlatformButton(
                        child: PlatformText('Done'),
                        onPressed: () {
                          Navigator.pushReplacement(
                              context,
                              platformPageRoute(
                                  builder: (_) => TraceNav(),
                                  context: context));
                        },
                      )),
                ),
              )
            ]),
      ),
    );
  }
}
