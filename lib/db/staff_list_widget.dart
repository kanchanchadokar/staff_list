import 'package:flutter/material.dart';

import 'model/staff_db.dart';
import 'model/staff_model.dart';

class EmployeeListScreen extends StatefulWidget {
  @override
  _EmployeeListScreenState createState() => _EmployeeListScreenState();
}

class _EmployeeListScreenState extends State<EmployeeListScreen> {
  List<StaffModel> _mStaffModel = [];

  @override
  void initState() {
    super.initState();
    _loadEmployees();
  }

  Future<void> _loadEmployees() async {
    final mStaffModel = await DatabaseHelper().getEmployees();
    setState(() {
      _mStaffModel = mStaffModel;
    });
  }

  Future<void> _addEmployee(String name,String email, String number, String position) async {
    await DatabaseHelper()
        .insertEmployee(StaffModel(name: name, email : email, number: number, position: position));
    _loadEmployees();
  }

  Future<void> _updateEmployee(StaffModel mStaffModel) async {
    await DatabaseHelper().updateEmployee(mStaffModel);
    _loadEmployees();
  }

  Future<void> _deleteEmployee(int id) async {
    await DatabaseHelper().deleteEmployee(id);
    _loadEmployees();
  }

  void _showEmployeeForm({StaffModel? mStaffModel}) {
    final nameController = TextEditingController(text: mStaffModel?.name ?? '');
    final emaileController = TextEditingController(text: mStaffModel?.email ?? '');
    final numberController = TextEditingController(text: mStaffModel?.number ?? '');
    final positionController =
        TextEditingController(text: mStaffModel?.position ?? '');

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(mStaffModel == null ? 'Add staff' : 'Edit staff',   style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),),
        content: Container(

          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: nameController,

                decoration: InputDecoration(labelText: 'Name', labelStyle:  TextStyle(fontSize: 14, fontWeight: FontWeight.w400),),
              ),
              TextField(
                controller: emaileController,
                decoration: InputDecoration(labelText: 'Email',labelStyle:  TextStyle(fontSize: 14, fontWeight: FontWeight.w400),),
              ),
              TextField(
                controller: numberController,
                decoration: InputDecoration(labelText: 'Number', labelStyle:  TextStyle(fontSize: 14, fontWeight: FontWeight.w400),),
              ),
              TextField(
                controller: positionController,
                decoration: InputDecoration(labelText: 'Position', labelStyle:  TextStyle(fontSize: 14, fontWeight: FontWeight.w400),),
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () {
              if (mStaffModel == null) {
                _addEmployee(nameController.text, emaileController.text, numberController.text, positionController.text);
              } else {
                _updateEmployee(StaffModel(
                  id: mStaffModel.id,
                  name: nameController.text,
                  email: emaileController.text,
                  number: numberController.text,
                  position: positionController.text,
                ));
              }
              Navigator.of(context).pop();
            },
            child: Text(mStaffModel == null ? 'Add' : 'Update'),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: Text('Cancel'),
          ),
        ],
      ),
    );
  }
  final TextEditingController _controller = TextEditingController();

  void _search(String query) async {
    if (query.isNotEmpty) {
      final results = await DatabaseHelper().searchItemsByName(query);
      setState(() {
            for(int i= 0; i < results.length; i++)
              {
                StaffModel mnStaffModel = StaffModel(name : "", email: "", number: "", position: "");
                mnStaffModel.name = results.toString();
                _mStaffModel.add(mnStaffModel);
              }
      
      });
    } else {
      setState(() {
        _mStaffModel = [];
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Staff List',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.w800),
        ),
      ),
      body: Column(
        children: [
          Container(
            padding: EdgeInsets.only(left: 20, right: 20),
            child: TextField(
              controller: _controller,
              decoration: InputDecoration(
                labelText: 'Search by name',
                suffixIcon: IconButton(
                  icon: Icon(Icons.search),
                  onPressed: () {
                    _search(_controller.text);
                  },
                ),
              ),
              onChanged: _search,
            ),
          ),
          SizedBox(height:  20,),
          Container(
            height: MediaQuery.of(context).size.height* 0.8,
            child: ListView.builder(
              itemCount: _mStaffModel.length,
              itemBuilder: (context, index) {
                final employee = _mStaffModel[index];
                return Card(
                  child: Container(
                    padding:
                        EdgeInsets.only(left: 20, right: 20, top: 10, bottom: 10),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                            Row(
                              children: [
                                Text("Name : ", style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),),
                                Text(employee.name, style: TextStyle(fontSize: 14, fontWeight: FontWeight.w400),),
                              ],
                            ),
                            SizedBox(height: 5,),
                            Row(
                              children: [
                                Text("Email : ", style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),),
                                Text(employee.email, style: TextStyle(fontSize: 14, fontWeight: FontWeight.w400),),
                              ],
                            ),
                            SizedBox(height: 5,),
                            Row(
                              children: [
                                Text("Number : ", style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),),
                                Text(employee.number, style: TextStyle(fontSize: 14, fontWeight: FontWeight.w400),),
                              ],
                            ),
                            SizedBox(height: 5,),
                            Row(
                              children: [
                                Text("Position : ", style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),),
                                Text(employee.position, style: TextStyle(fontSize: 14, fontWeight: FontWeight.w400)),
                              ],
                            ),
                            SizedBox(height: 5,),
                          ],),
                        ],),

                        Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            TextButton.icon(
                              onPressed: () =>
                                  _showEmployeeForm(mStaffModel: employee),
                              icon: Icon(Icons.edit, color: Colors.black,),
                              label: Text('Edit',style: TextStyle(color: Colors.black,fontSize: 14, fontWeight: FontWeight.w400)),
                            ),
                            TextButton.icon(
                              onPressed: () => _deleteEmployee(employee.id!),
                              icon: Icon(Icons.delete, color: Colors.black,),
                              label: Text('Delete',style: TextStyle(color: Colors.black,fontSize: 14, fontWeight: FontWeight.w400)),
                            ),
                          ],
                        )

                      ],
                    )
                    ,
                  ),
                );
              },
            ),
          ),
        ],
      ),
      floatingActionButton: Padding(
          padding: EdgeInsets.all(16.0), // Adjust the padding as needed
          child: FloatingActionButton(
            child: Container(
              child: Row(
                children: [Icon(Icons.add), Text("Add")],
              ),
            ),
            onPressed: () => _showEmployeeForm(),
          )),
    );
  }
}
