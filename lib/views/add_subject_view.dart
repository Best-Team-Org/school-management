import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../res/colors.dart';
import '../view_model/add_subject_view_model.dart';

class AddSubjectView extends StatefulWidget {
  const AddSubjectView({Key? key}) : super(key: key);

  @override
  State<AddSubjectView> createState() => _AddSubjectViewState();
}

class _AddSubjectViewState extends State<AddSubjectView> {
  final AddSubjectViewModel _viewModel = AddSubjectViewModel();

  late TextEditingController _nameController;
  int stepsLength = 3;

  @override
  void initState() {
    _nameController = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add Subject',style: TextStyle(
          fontSize: 32.0,
          letterSpacing: 2.0,
        ),),
      ),
      body: Consumer<AddSubjectViewModel>(
        builder: (BuildContext context, AddSubjectViewModel provider, _) {
          return Column(
            children: [
              Stepper(
                currentStep: provider.currentStep,
                controlsBuilder: (BuildContext context, ControlsDetails details) {
                  return Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      children: <Widget>[
                        if (details.stepIndex != stepsLength - 1)
                          ElevatedButton(
                            onPressed: details.onStepContinue,
                            child: const Text('NEXT',style: TextStyle(fontSize: 24.0),),
                          ),
                        if (details.stepIndex != 0)
                          TextButton(
                            onPressed: details.onStepCancel,
                            child: const Text('PREVIOUS',style: TextStyle(fontSize: 22.0),),
                          ),
                      ],
                    ),
                  );
                },
                onStepTapped: (int value) {
                  provider.setCurrentStep = value;
                },
                onStepContinue: () {
                  if (provider.currentStep == stepsLength - 1) {
                    return;
                  }
                  provider.setCurrentStep = provider.currentStep + 1;
                },
                onStepCancel: () {
                  if (provider.currentStep == 0) {
                    return;
                  }
                  provider.setCurrentStep = provider.currentStep - 1;
                },
                steps: <Step>[
                  Step(
                    title:  Text('Subject name',style: Theme.of(context).textTheme.headline2,),
                    content: TextField(
                      style: Theme.of(context).textTheme.headline2,
                      controller: _nameController,
                    ),
                  ),
                  Step(
                    title:  Text('Teacher name',style: Theme.of(context).textTheme.headline2,),
                    content: ElevatedButton(
                      onPressed: () {
                        showBottomSheet(
                            context: context,
                            elevation: 16.0,
                            constraints: BoxConstraints(
                              maxHeight: MediaQuery.of(context).size.height * 0.75,
                            ),
                            builder: (ctx) {
                              return FutureBuilder<QuerySnapshot>(
                                future: _viewModel.getTeachers(),
                                builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
                                  if (snapshot.connectionState == ConnectionState.waiting) {
                                    return const Center(
                                      child: CircularProgressIndicator(),
                                    );
                                  }
                                  if (snapshot.hasData) {
                                    if (snapshot.data!.docs.isEmpty) {
                                      return const Center(
                                        child: Text('You have to add teachers first.'),
                                      );
                                    }
                                    List teachers = snapshot.data!.docs;
                                    return ListView.separated(
                                      itemCount: teachers.length,
                                      itemBuilder: (BuildContext context, int index) {
                                        final teacher = teachers[index];
                                        return RadioListTile(
                                          title: Text('${teacher['username']}',style: Theme.of(context).textTheme.headline2,),
                                          subtitle: Text('${teacher['email']}',style: Theme.of(context).textTheme.headline3,),
                                          activeColor: CustomColors.primaryColor,
                                          value: teacher.id.toString(),
                                          groupValue: Provider.of<AddSubjectViewModel>(context).selectedTeacher,
                                          onChanged: (String? value) {
                                            Provider.of<AddSubjectViewModel>(context, listen: false).setSelectedTeacher =
                                                value;
                                          },
                                        );
                                      },
                                      separatorBuilder: (BuildContext context, int index) {
                                        return const Divider(color: Colors.white,);
                                      },
                                    );
                                  }
                                  return const Center(
                                    child: Text('Check your connection'),
                                  );
                                },
                              );
                            });
                      },
                      child: const Text('Choose a teacher'),
                    ),
                  ),
                  Step(
                      title:  Text('Subject time',style: Theme.of(context).textTheme.headline2,),
                      content: Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                               Text('Start time',style: Theme.of(context).textTheme.headline3,),
                              ElevatedButton(
                                onPressed: () async {
                                  TimeOfDay? time = await showTimePicker(
                                    context: context,
                                    initialTime: const TimeOfDay(hour: 8, minute: 0),
                                  );
                                  if (time != null) {
                                    provider.setStartTime = time;
                                  }
                                },
                                child: Text(
                                  provider.startTime != null ? provider.startTime!.format(context) : '00:00',style: Theme.of(context).textTheme.headline3,
                                ),
                              ),
                            ],
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                               Text('End time',style: Theme.of(context).textTheme.headline3,),
                              ElevatedButton(
                                onPressed: () async {
                                  TimeOfDay? time = await showTimePicker(
                                    context: context,
                                    initialTime: const TimeOfDay(hour: 8, minute: 0),
                                  );
                                  if (time != null) {
                                    provider.setEndTime = time;
                                  }
                                },
                                child: Text(
                                  provider.endTime != null ? provider.endTime!.format(context) : '00:00',style: Theme.of(context).textTheme.headline3,
                                ),
                              ),
                            ],
                          ),
                        ],
                      )),
                ],
              ),
              ElevatedButton(onPressed: ()async{
                if(_nameController.text.isEmpty){
                  ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('You must enter a name')));
                  return;
                }
                if(provider.selectedTeacher == null){
                  ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('You must choose a teacher')));
                  return;
                }
                if(provider.startTime == null){
                  ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('You must choose a start time')));
                  return;
                }
                if(provider.endTime == null){
                  ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('You must choose a end time')));
                  return;
                }
                await _viewModel.addSubject(context, _nameController.text, provider.selectedTeacher!, provider.startTime!.format(context), provider.endTime!.format(context));
              }, child: const Text('Add'),),
            ],
          );
        },
      ),
    );
  }
}
