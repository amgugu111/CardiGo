import 'package:cardigo/utils/globalappbar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';

class TakeSurvey extends StatefulWidget {
  @override
  _TakeSurveyState createState() => _TakeSurveyState();
}

class _TakeSurveyState extends State<TakeSurvey> {
  var data;
  bool autoValidate = true;
  bool readOnly = false;
  bool showSegmentedControl = true;
  final GlobalKey<FormBuilderState> _fbKey = GlobalKey<FormBuilderState>();
  final GlobalKey<FormFieldState> _specifyTextFieldKey =
  GlobalKey<FormFieldState>();

  ValueChanged _onChanged = (val) => print(val);

  @override
  Widget build(BuildContext context) {
    final appBar = new GlobalAppBar();
    return Scaffold(
      appBar: appBar,
      body: Padding(
        padding: EdgeInsets.all(10),
        child: ListView(
          children: <Widget>[
            FormBuilder(
              // context,
              key: _fbKey,
              //autovalidate: true,
              initialValue: {
                'movie_rating': 3,
              },
              readOnly: false,
              child: Column(
                children: <Widget>[
                  FormBuilderChoiceChip(
                    attribute: 'choice_chip',
                    selectedColor: Color(0xFF86BC24),
                    elevation: 10,
                    spacing: 20.0,
                    crossAxisAlignment: WrapCrossAlignment.center,
                    decoration: InputDecoration(
                      labelText: 'Do you feel stressed at Work?',
                      labelStyle: TextStyle(
                          fontFamily: 'Montserrat',
                          fontWeight: FontWeight.bold,
                          color: Color(0xff333333), fontSize: 20),
                    ),
                    options: [
                      FormBuilderFieldOption(
                          value: 'Yes',
                        child: Text('Yes'),),
                      FormBuilderFieldOption(
                          value: 'No', child: Text('No')),
                    ],
                  ),
                  SizedBox(height: 15),
                  FormBuilderCustomField(
                    attribute: 'custom',
                    valueTransformer: (val) {
                      if (val == "Other") {
                        return _specifyTextFieldKey.currentState.value;
                      }
                      return val;
                    },
                    formField: FormField(
                      builder: (FormFieldState<String> field) {
                        var languages = [
                          "Frequent headaches",
                          "Depression",
                          "Anxiety Attacks",
                          "Insomnia",
                          "Loss of appetite",
                          "Other"
                        ];

                        return InputDecorator(
                          decoration: InputDecoration(
                              labelText: "If “Yes”, please select "
                                  "the symptoms you experience:",
                            labelStyle: TextStyle(
                                fontFamily: 'Montserrat',
                                fontWeight: FontWeight.bold,
                                color: Color(0xff333333), fontSize: 18),
                          ),
                          child: Column(
                            children: languages
                                .map(
                                  (lang) => Row(
                                children: <Widget>[
                                  Radio<dynamic>(
                                    activeColor: Color(0xFF86BC24),
                                    value: lang,
                                    groupValue: field.value,
                                    onChanged: (dynamic value) {
                                      field.didChange(lang);
                                    },
                                  ),
                                  lang != "Other"
                                      ? Text(lang)
                                      : Expanded(
                                    child: Row(
                                      children: <Widget>[
                                        Text(
                                          lang,
                                        ),
                                        SizedBox(width: 20),
                                        Expanded(
                                          child: TextFormField(
                                            key: _specifyTextFieldKey,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            )
                                .toList(growable: false),
                          ),
                        );
                      },
                    ),
                  ),
                  SizedBox(height: 15),
                  FormBuilderTextField(
                    attribute: "text",
                    decoration: InputDecoration(
                      labelText:
                      "What is the most stressful aspect of your job?",
                      labelStyle: TextStyle(
                          fontFamily: 'Montserrat',
                          fontWeight: FontWeight.bold,
                          color: Color(0xff333333), fontSize: 20),
                    ),
                    onChanged: _onChanged,
                    valueTransformer: (text) {
                      return text == null ? null : num.tryParse(text);
                    },
                    validators: [
                      FormBuilderValidators.required(),
                      // FormBuilderValidators.max(70),
                      FormBuilderValidators.minLength(2, allowEmpty: true),
                    ],
                    keyboardType: TextInputType.text,
                  ),
                  SizedBox(height: 15),
                  FormBuilderChoiceChip(
                    attribute: 'choice_chip',
                    selectedColor: Color(0xFF86BC24),
                    elevation: 10,
                    spacing: 20.0,
                    decoration: InputDecoration(
                      labelText: 'How long have you had this particular job stress?',
                      labelStyle: TextStyle(
                          fontFamily: 'Montserrat',
                          fontWeight: FontWeight.bold,
                          color: Color(0xff333333), fontSize: 20),
                    ),
                    options: [
                      FormBuilderFieldOption(
                          value: 'Less Than A Month', child: Text('Less Than A Month')),
                      FormBuilderFieldOption(
                          value: '1-3 Months', child: Text('1-3 Months')),
                      FormBuilderFieldOption(
                          value: '4-6 Months', child: Text('4-6 Months')),
                      FormBuilderFieldOption(
                          value: '6 months-1 year', child: Text('6 months-1 year')),
                      FormBuilderFieldOption(
                          value: 'More than 1 year', child: Text('More than 1 year')),
                    ],
                  ),
                  SizedBox(height: 15),
                  FormBuilderChoiceChip(
                    selectedColor: Color(0xFF86BC24),
                    elevation: 10,
                    spacing: 20.0,
                    attribute: 'choice_chip',
                    decoration: InputDecoration(
                      labelText: 'How would you rate the level of your job stress?',
                      labelStyle: TextStyle(
                          fontFamily: 'Montserrat',
                          fontWeight: FontWeight.bold,
                          color: Color(0xff333333), fontSize: 20),
                    ),
                    options: [
                      FormBuilderFieldOption(
                          value: 'Mild', child: Text('Mild')),
                      FormBuilderFieldOption(
                          value: 'Moderate', child: Text('Moderate')),
                      FormBuilderFieldOption(
                          value: 'Severe', child: Text('Severe')),
                      FormBuilderFieldOption(
                          value: 'Extreme', child: Text('Extreme')),
                    ],
                  ),
                  SizedBox(height: 15),
                  Text("Please select what you feel about the following statements:",
                    style:TextStyle(
                        fontFamily: 'Montserrat',
                        fontWeight: FontWeight.bold,
                        color: Color(0xff333333), fontSize: 20),),
                  SizedBox(height: 15),
                  FormBuilderSegmentedControl(
                    decoration:
                    InputDecoration(labelText: "I have very long working hours",
                      labelStyle: TextStyle(
                          fontFamily: 'Montserrat',
                          fontWeight: FontWeight.bold,
                          color: Color(0xff333333), fontSize: 20),),
                    attribute: "movie_rating",
                    textStyle: TextStyle(fontWeight: FontWeight.bold),
                    options: List.generate(5, (i) => i + 1)
                        .map((number) => FormBuilderFieldOption(
                      value: number,
                      child: Text(
                        "$number",
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ))
                        .toList(),
                    onChanged: _onChanged,
                  ),
                  SizedBox(height: 15),
                  FormBuilderSegmentedControl(
                    decoration:
                    InputDecoration(labelText: "I have too much work allotted to me",
                      labelStyle: TextStyle(
                          fontFamily: 'Montserrat',
                          fontWeight: FontWeight.bold,
                          color: Color(0xff333333), fontSize: 20),),
                    attribute: "movie_rating",
                    textStyle: TextStyle(fontWeight: FontWeight.bold),
                    options: List.generate(5, (i) => i + 1)
                        .map((number) => FormBuilderFieldOption(
                      value: number,
                      child: Text(
                        "$number",
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ))
                        .toList(),
                    onChanged: _onChanged,
                  ),
                  SizedBox(height: 15),
                  FormBuilderSegmentedControl(
                    decoration:
                    InputDecoration(labelText: "I have too little work allotted to me",
                      labelStyle: TextStyle(
                          fontFamily: 'Montserrat',
                          fontWeight: FontWeight.bold,
                          color: Color(0xff333333), fontSize: 20),),
                    attribute: "movie_rating",
                    textStyle: TextStyle(fontWeight: FontWeight.bold),
                    options: List.generate(5, (i) => i + 1)
                        .map((number) => FormBuilderFieldOption(
                      value: number,
                      child: Text(
                        "$number",
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ))
                        .toList(),
                    onChanged: _onChanged,
                  ),
                  SizedBox(height: 15),
                  FormBuilderSegmentedControl(
                    decoration:
                    InputDecoration(labelText: "My work is repetitive and monotonous",
                      labelStyle: TextStyle(
                          fontFamily: 'Montserrat',
                          fontWeight: FontWeight.bold,
                          color: Color(0xff333333), fontSize: 20),),
                    attribute: "movie_rating",
                    textStyle: TextStyle(fontWeight: FontWeight.bold),
                    options: List.generate(5, (i) => i + 1)
                        .map((number) => FormBuilderFieldOption(
                      value: number,
                      child: Text(
                        "$number",
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ))
                        .toList(),
                    onChanged: _onChanged,
                  ),
                  SizedBox(height: 15),
                  FormBuilderSegmentedControl(
                    decoration:
                    InputDecoration(labelText: "I don’t have sufficient time to complete my work",
                      labelStyle: TextStyle(
                          fontFamily: 'Montserrat',
                          fontWeight: FontWeight.bold,
                          color: Color(0xff333333), fontSize: 20),),
                    attribute: "movie_rating",
                    textStyle: TextStyle(fontWeight: FontWeight.bold),
                    options: List.generate(5, (i) => i + 1)
                        .map((number) => FormBuilderFieldOption(
                      value: number,
                      child: Text(
                        "$number",
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ))
                        .toList(),
                    onChanged: _onChanged,
                  ),
                  SizedBox(height: 15),
                  FormBuilderSegmentedControl(
                    decoration:
                    InputDecoration(labelText: "I don’t have enough rest breaks between work",
                      labelStyle: TextStyle(
                          fontFamily: 'Montserrat',
                          fontWeight: FontWeight.bold,
                          color: Color(0xff333333), fontSize: 20),),
                    attribute: "movie_rating",
                    textStyle: TextStyle(fontWeight: FontWeight.bold),
                    options: List.generate(5, (i) => i + 1)
                        .map((number) => FormBuilderFieldOption(
                      value: number,
                      child: Text(
                        "$number",
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ))
                        .toList(),
                    onChanged: _onChanged,
                  ),
                  SizedBox(height: 15),
                  Text("Please select what you feel about your control over the work that is assigned to you",
                    style:TextStyle(
                        fontFamily: 'Montserrat',
                        fontWeight: FontWeight.bold,
                        color: Color(0xff333333), fontSize: 20),),
                  SizedBox(height: 15),
                  FormBuilderSegmentedControl(
                    decoration:
                    InputDecoration(labelText: "I have lack of control over the work assigned to me",
                      labelStyle: TextStyle(
                          fontFamily: 'Montserrat',
                          fontWeight: FontWeight.bold,
                          color: Color(0xff333333), fontSize: 19),),
                    attribute: "movie_rating",
                    textStyle: TextStyle(fontWeight: FontWeight.bold),
                    options: List.generate(5, (i) => i + 1)
                        .map((number) => FormBuilderFieldOption(
                      value: number,
                      child: Text(
                        "$number",
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ))
                        .toList(),
                    onChanged: _onChanged,
                  ),
                  SizedBox(height: 15),
                  FormBuilderSegmentedControl(
                    decoration:
                    InputDecoration(labelText: "I am given unrealistic targets to achieve",
                      labelStyle: TextStyle(
                          fontFamily: 'Montserrat',
                          fontWeight: FontWeight.bold,
                          color: Color(0xff333333), fontSize: 20),),
                    attribute: "movie_rating",
                    textStyle: TextStyle(fontWeight: FontWeight.bold),
                    options: List.generate(5, (i) => i + 1)
                        .map((number) => FormBuilderFieldOption(
                      value: number,
                      child: Text(
                        "$number",
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ))
                        .toList(),
                    onChanged: _onChanged,
                  ),
                  SizedBox(height: 15),
                  FormBuilderSegmentedControl(
                    decoration:
                    InputDecoration(labelText: "The pace of my work is dictated by my manager",
                      labelStyle: TextStyle(
                          fontFamily: 'Montserrat',
                          fontWeight: FontWeight.bold,
                          color: Color(0xff333333), fontSize: 20),),
                    attribute: "movie_rating",
                    textStyle: TextStyle(fontWeight: FontWeight.bold),
                    options: List.generate(5, (i) => i + 1)
                        .map((number) => FormBuilderFieldOption(
                      value: number,
                      child: Text(
                        "$number",
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ))
                        .toList(),
                    onChanged: _onChanged,
                  ),
                  SizedBox(height: 15),
                  FormBuilderSegmentedControl(
                    decoration:
                    InputDecoration(labelText: "I am constantly expected to perform well at work",
                      labelStyle: TextStyle(
                          fontFamily: 'Montserrat',
                          fontWeight: FontWeight.bold,
                          color: Color(0xff333333), fontSize: 20),),
                    attribute: "movie_rating",
                    textStyle: TextStyle(fontWeight: FontWeight.bold),
                    options: List.generate(5, (i) => i + 1)
                        .map((number) => FormBuilderFieldOption(
                      value: number,
                      child: Text(
                        "$number",
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ))
                        .toList(),
                    onChanged: _onChanged,
                  ),
                  SizedBox(height: 15),
                  FormBuilderChoiceChip(
                    attribute: 'choice_chip',
                    selectedColor: Color(0xFF86BC24),
                    elevation: 10,
                    spacing: 20.0,
                    decoration: InputDecoration(
                      labelText: 'Do you feel you have a healthy work-life balance?',
                      labelStyle: TextStyle(
                          fontFamily: 'Montserrat',
                          fontWeight: FontWeight.bold,
                          color: Color(0xff333333), fontSize: 20),
                    ),
                    options: [
                      FormBuilderFieldOption(
                          value: 'Yes', child: Text('Yes')),
                      FormBuilderFieldOption(
                          value: 'No', child: Text('No')),
                    ],
                  ),
                  SizedBox(height: 15),
                  FormBuilderCustomField(
                    attribute: 'custom',
                    valueTransformer: (val) {
                      if (val == "Other") {
                        return _specifyTextFieldKey.currentState.value;
                      }
                      return val;
                    },
                    formField: FormField(
                      builder: (FormFieldState<String> field) {
                        var languages = [
                          "My inflexible work hours causes issues like childcare, domestic issues etc.",
                          "I am expected to work long hours to achieve my targets",
                          "I usually miss my children’s games and other activities.",
                          "I am too tired after work I never go out with my family or friends.",
                          "Other (Please Specify)"
                        ];

                        return InputDecorator(
                          decoration: InputDecoration(
                              labelText: "If “No”, then what"
                                  " describes your work-life balance?",
                            labelStyle: TextStyle(
                                fontFamily: 'Montserrat',
                                fontWeight: FontWeight.bold,
                                color: Color(0xff333333), fontSize: 18),),
                          child: Column(
                            children: languages
                                .map(
                                  (lang) => Row(
                                children: <Widget>[
                                  Radio<dynamic>(
                                    activeColor: Color(0xFF86BC24),
                                    value: lang,
                                    groupValue: field.value,
                                    onChanged: (dynamic value) {
                                      field.didChange(lang);
                                    },
                                  ),
                                  lang != "Other"
                                      ? Text(lang)
                                      : Expanded(
                                    child: Row(
                                      children: <Widget>[
                                        Text(
                                          lang,
                                        ),
                                        SizedBox(width: 20),
                                        Expanded(
                                          child: TextFormField(
                                            key: _specifyTextFieldKey,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            )
                                .toList(growable: false),
                          ),
                        );
                      },
                    ),
                  ),
                  SizedBox(height: 15),
                  FormBuilderCustomField(
                    attribute: 'custom',
                    valueTransformer: (val) {
                      if (val == "Other") {
                        return _specifyTextFieldKey.currentState.value;
                      }
                      return val;
                    },
                    formField: FormField(
                      builder: (FormFieldState<String> field) {
                        var languages = [
                          "I am uncertain about my future",
                          "I sense a lack of job security",
                          " am not sure of the management techniques",
                          "In 5 years I see myself at a decision making position.",
                          "Other (Please Specify)"
                        ];

                        return InputDecorator(
                          decoration: InputDecoration(
                              labelText: "Where do you see yourself in 5 years "
                                  "in this organization?",
                            labelStyle: TextStyle(
                                fontFamily: 'Montserrat',
                                fontWeight: FontWeight.bold,
                                color: Color(0xff333333), fontSize: 20),),
                          child: Column(
                            children: languages
                                .map(
                                  (lang) => Row(
                                children: <Widget>[
                                  Radio<dynamic>(
                                    activeColor: Color(0xFF86BC24),
                                    value: lang,
                                    groupValue: field.value,
                                    onChanged: (dynamic value) {
                                      field.didChange(lang);
                                    },
                                  ),
                                  lang != "Other"
                                      ? Text(lang)
                                      : Expanded(
                                    child: Row(
                                      children: <Widget>[
                                        Text(
                                          lang,
                                        ),
                                        SizedBox(width: 20),
                                        Expanded(
                                          child: TextFormField(
                                            key: _specifyTextFieldKey,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            )
                                .toList(growable: false),
                          ),
                        );
                      },
                    ),
                  ),
                  SizedBox(height: 15),
                  FormBuilderTextField(
                    attribute: "text",
                    decoration: InputDecoration(
                      labelText:
                      "What are the positive aspects of your job?",
                      labelStyle: TextStyle(
                          fontFamily: 'Montserrat',
                          fontWeight: FontWeight.bold,
                          color: Color(0xff333333), fontSize: 20),
                    ),
                    onChanged: _onChanged,
                    valueTransformer: (text) {
                      return text == null ? null : num.tryParse(text);
                    },
                    validators: [
                      FormBuilderValidators.required(),
                      // FormBuilderValidators.max(70),
                      FormBuilderValidators.minLength(2, allowEmpty: true),
                    ],
                    keyboardType: TextInputType.text,
                  ),
                  SizedBox(height: 15),
                  FormBuilderTextField(
                    attribute: "text",
                    decoration: InputDecoration(
                      labelText:
                      "What are the three things you would like the organization"
                          " to do differently to help you cope with work stress? ",
                      labelStyle: TextStyle(
                          fontFamily: 'Montserrat',
                          fontWeight: FontWeight.bold,
                          color: Color(0xff333333), fontSize: 20),
                    ),
                    onChanged: _onChanged,
                    valueTransformer: (text) {
                      return text == null ? null : num.tryParse(text);
                    },
                    validators: [
                      FormBuilderValidators.required(),
                      // FormBuilderValidators.max(70),
                      FormBuilderValidators.minLength(2, allowEmpty: true),
                    ],
                    keyboardType: TextInputType.text,
                  ),
                  SizedBox(height: 15),
                  FormBuilderSignaturePad(
                    backgroundColor: Color(0xffeeeeee),
                    decoration: InputDecoration(labelText: "Signature",
                      labelStyle: TextStyle(
                          fontFamily: 'Montserrat',
                          fontWeight: FontWeight.bold,
                          color: Color(0xff333333), fontSize: 20),),
                    attribute: "signature",
                    // height: 250,
                    clearButtonText: "Start Over",
                    onChanged: _onChanged,
                  ),
                  SizedBox(height: 15),
                ],
              ),
            ),
            Row(
              children: <Widget>[
                Expanded(
                  child: MaterialButton(
                    shape: new RoundedRectangleBorder(borderRadius: new BorderRadius.circular(30.0)),
                    color: Color(0xFF86BC24),
                    child: Text(
                      "Submit",
                      style: TextStyle(color: Colors.white),
                    ),
                    onPressed: () {
                      if (_fbKey.currentState.saveAndValidate()) {
                        print(_fbKey.currentState.value);
                      }
                    },
                  ),
                ),
                SizedBox(
                  width: 20,
                ),
                Expanded(
                  child: MaterialButton(
                    shape: new RoundedRectangleBorder(borderRadius: new BorderRadius.circular(30.0)),
                    color: Colors.grey,
                    child: Text(
                      "Reset",
                      style: TextStyle(color: Colors.white),
                    ),
                    onPressed: () {
                      _fbKey.currentState.reset();
                    },
                  ),
                ),
              ],
            ),
            SizedBox(
              height: 10,
            )
          ],
        ),
      ),
    );
  }
}
