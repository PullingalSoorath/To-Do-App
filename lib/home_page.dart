import 'dart:async';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:hive/hive.dart';
import 'package:todoapp/widgets/color.dart';
import 'widgets/default_button.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final formKey = GlobalKey<FormState>();

  final TextEditingController _namedController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();

  final RegExp _textPattern = RegExp(r'[A-Z , a-z ,_,]');
  List<Map<String, dynamic>> _items = [];

  final _profileDatas = Hive.box('boxname');

  @override
  void initState() {
    super.initState();
    _refreshItem();
  }

  void _refreshItem() {
    ///Refresh Item
    final data = _profileDatas.keys.map((key) {
      final item = _profileDatas.get(key);
      return {
        "key": key,
        "name": item["name"],
        "email": item["email"],
        "number": item["number"],
        "profession": item["profession"]
      };
    }).toList();

    setState(() {
      _items = data.reversed.toList();

      // print(_items.length);
    });
  }

  Future<void> _createItem(Map<String, dynamic> newItem) async {
    await _profileDatas.add(newItem);

    // ignore: use_build_context_synchronously
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        // shape: RoundedRectangleBorder(),
        backgroundColor: defaultColor,
        shape: const RoundedRectangleBorder(),
        content: const Text(
          'Details Added',
          style: TextStyle(color: Colors.white),
        ),
      ),
    );

    _refreshItem();
  }

  Future<void> _updateItem(int itemKey, Map<String, dynamic> item) async {
    //Update Item
    await _profileDatas.put(itemKey, item);
    _refreshItem();

// ignore: use_build_context_synchronously
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        // shape: RoundedRectangleBorder(),
        backgroundColor: defaultColor,
        shape: const RoundedRectangleBorder(),
        content: const Text(
          'Details Updated.!!!',
          style: TextStyle(color: Colors.white),
        ),
      ),
    );
  }

  Future<void> _deleteItem(int itemkey) async {
    await _profileDatas.delete(itemkey);
    _refreshItem();

    // ignore: use_build_context_synchronously
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        backgroundColor: snackBarColor,
        shape: const RoundedRectangleBorder(),
        content: const Text(
          'Details Deleted.!!!',
          style: TextStyle(color: Colors.white),
        ),
      ),
    );
  }

  void showAlertDialog(BuildContext context, currentItem) {
    //Warning!!! , Are You Sure....

    showDialog(
      // barrierColor: Colors.black,

      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          backgroundColor: defaultUiBackgroundColor,
          title: Text(
            'Warning.!',
            style: TextStyle(color: textColor),
          ),
          content: Text(
            'Are you sure want to delete this data.!!!',
            style: TextStyle(color: textColor),
          ),
          actions: <Widget>[
            DefaultButton(
                pressFn: () {
                  Navigator.pop(context);
                },
                buttonName: 'Cancel',
                heightBtn: 20.0,
                widthBtn: 60.0),
            const SizedBox(
              width: 2,
            ),
            DefaultButton(
                pressFn: () {
                  _deleteItem(currentItem['key']);
                  Navigator.pop(context);
                },
                buttonName: 'Delete',
                heightBtn: 20.0,
                widthBtn: 50.0),
            const SizedBox(
              width: 2,
            )
          ],
        );
      },
    );
  }

  void _showProfile(BuildContext ctx, int? itemkey) async {
    if (itemkey != null) {
      final existingItem =
          _items.firstWhere((element) => element['key'] == itemkey);

      _namedController.text = existingItem['name'];
      _emailController.text = existingItem['email'];
    }

    showModalBottomSheet(
      backgroundColor: defaultBackgroundColor,
      context: ctx,
      isScrollControlled: true,
      enableDrag: false,
      builder: (_) => WillPopScope(
        onWillPop: () async {
          Navigator.pop(context);
          _namedController.text = '';
          _emailController.text = '';

          return true;
        },
        child: Container(
          padding: EdgeInsets.only(
              bottom: MediaQuery.of(ctx).viewInsets.bottom,
              right: 15,
              top: 10,
              left: 15),
          child: Column(
            children: [
              const SizedBox(
                height: 15,
              ),
              Row(
                children: [
                  IconButton(
                    onPressed: () {
                      Navigator.pop(context);
                      _namedController.text = '';
                      _emailController.text = '';
                    },
                    icon: const Icon(
                      CupertinoIcons.back,
                      color: Colors.white,
                    ),
                  )
                ],
              ),
              Container(
                width: double.infinity,
                decoration: BoxDecoration(
                    color: defaultColor,
                    borderRadius: BorderRadius.circular(25)),
                child: Flexible(
                    child: Padding(
                  padding: const EdgeInsets.all(15.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        _namedController.text,
                        style:
                            const TextStyle(color: Colors.white, fontSize: 25),
                      ),
                      const SizedBox(
                        height: 30,
                      ),
                      Text(
                        _emailController.text,
                        style:
                            const TextStyle(color: Colors.white, fontSize: 20),
                      ),
                    ],
                  ),
                )),
              ),
              sizeboxheight(),
              const SizedBox(
                height: 40,
              ),
              const SizedBox(
                height: 100,
              ),
            ],
          ),
        ),
      ),
    );
  }

  ///IMAGE GALLERY , CAMERA

  void _showUpdateForm(BuildContext ctx, int? itemkey) async {
    ///Main Form Page
    if (itemkey != null) {
      final existingItem =
          _items.firstWhere((element) => element['key'] == itemkey);

      _namedController.text = existingItem['name'];
      _emailController.text = existingItem['email'];
    }

    showModalBottomSheet(
      backgroundColor: defaultBackgroundColor,
      context: ctx,
      enableDrag: false,
      isScrollControlled: true,
      builder: (_) => Container(
        padding: EdgeInsets.only(
            bottom: MediaQuery.of(ctx).viewInsets.bottom,
            right: 15,
            top: 15,
            left: 15),
        child: WillPopScope(
          onWillPop: () async {
            Navigator.pop(context);
            _namedController.text = '';
            _emailController.text = '';

            return true;
          },
          child: Form(
            onChanged: () {
              formKey.currentState!.validate();
            },
            key: formKey,
            child: Column(
              children: <Widget>[
                const SizedBox(
                  height: 25,
                ),
                Row(
                  children: [
                    IconButton(
                      onPressed: () {
                        Navigator.pop(context);
                        _namedController.text = '';
                        _emailController.text = '';
                      },
                      icon: Icon(
                        CupertinoIcons.back,
                        color: navIconColor,
                      ),
                    )
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      itemkey == null ? 'Add New' : 'Edit',
                      style: const TextStyle(fontSize: 20),
                    )
                  ],
                ),
                const SizedBox(
                  height: 30,
                ),
                SizedBox(
                  child: TextFormField(
                    inputFormatters: [
                      FilteringTextInputFormatter.allow(_textPattern),
                    ],
                    keyboardType: TextInputType.name,
                    style: TextStyle(color: textColor),
                    controller: _namedController,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(15),
                      ),
                      prefixIcon: Icon(
                        Icons.person,
                        color: textColor,
                      ),
                      label: const Text('Title'),
                      hintText: 'Title',
                      hintStyle: TextStyle(color: textColor),
                      labelStyle: TextStyle(color: textColor),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(15),
                        borderSide: BorderSide(color: borderColor),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(15),
                        borderSide: BorderSide(color: defaultSecondaryColor),
                      ),
                    ),
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
                TextFormField(
                  keyboardType: TextInputType.emailAddress,
                  style: TextStyle(color: textColor),
                  controller: _emailController,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                    prefixIcon: Icon(
                      Icons.mail,
                      color: textColor,
                    ),
                    label: const Text('Content'),
                    hintText: 'Content',
                    hintStyle: TextStyle(color: textColor),
                    labelStyle: TextStyle(color: textColor),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(15),
                      borderSide: BorderSide(color: borderColor),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(15),
                      borderSide: BorderSide(color: defaultSecondaryColor),
                    ),
                  ),
                ),
                SizedBox(
                  height: itemkey == null ? 10 : 30,
                ),
                DefaultButton(
                  pressFn: () async {
                    final valid = formKey.currentState?.validate();

                    if (valid!) {
                      if (_namedController.text == '' ||
                          _emailController.text == '') {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            backgroundColor: snackBarColor,
                            shape: const RoundedRectangleBorder(),
                            content: const Text(
                              'Please Fill The Field',
                              style: TextStyle(
                                color: Colors.white,
                              ),
                            ),
                          ),
                        );
                      } else if (itemkey == null) {
                        _createItem({
                          "name": _namedController.text,
                          "email": _emailController.text,
                        });
                      }

                      if (itemkey != null) {
                        _updateItem(itemkey, {
                          "name": _namedController.text.trim(),
                          "email": _emailController.text.trim(),
                        });
                      }

                      _namedController.text = '';
                      _emailController.text = '';

                      Navigator.pop(context);
                    }
                  },
                  buttonName: itemkey == null ? 'Create New' : 'Update',
                  heightBtn: 35.0,
                  widthBtn: 120.0,
                ),
                const SizedBox(
                  height: 50,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  SizedBox sizeboxheight() {
    return const SizedBox(
      height: 10,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: defaultBackgroundColor,
      appBar: AppBar(
        elevation: 0,
        title: const Text(
          'To Do',
        ),
        titleTextStyle: TextStyle(color: headingColor, fontSize: 20),
        centerTitle: true,
        backgroundColor: defaultBackgroundColor,
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: defaultFlobtnColor,
        foregroundColor: Colors.white,
        onPressed: () => _showUpdateForm(context, null),
        child: const Icon(Icons.add),
      ),
      body: _items.isEmpty
          ? const Center(
              child: Text(
                'The List is Empty',
                style: TextStyle(color: Colors.white),
              ),
            )
          : Padding(
              padding: const EdgeInsets.only(
                top: 10,
                right: 10,
                left: 10,
              ),
              child: ListView.separated(
                  separatorBuilder: (context, index) {
                    return const SizedBox(
                      height: 2,
                    );
                  },
                  itemCount: _items.length,
                  itemBuilder: (ctx, index) {
                    final currentItem = _items[index];
                    return Slidable(
                      startActionPane: ActionPane(
                        motion: const StretchMotion(),
                        children: [
                          SlidableAction(
//delete Data swipe

                            onPressed: ((context) {
                              showAlertDialog(context, currentItem);
                              // _deleteItem(currentItem['key']);
                            }),

                            borderRadius: BorderRadius.circular(15),
                            backgroundColor: Colors.red.shade600,
                            icon: Icons.delete,
                          ),
                        ],
                      ),
                      endActionPane:
                          ActionPane(motion: const StretchMotion(), children: [
                        SlidableAction(
//edit data swipe

                          onPressed: ((context) =>
                              _showUpdateForm(ctx, currentItem['key'])),
                          borderRadius: BorderRadius.circular(15),
                          backgroundColor: Colors.blue,
                          icon: Icons.edit,
                        ),
                      ]),
                      child: ListTile(
                        onTap: () {
                          _showProfile(ctx, currentItem['key']);
                        },

                        shape: const RoundedRectangleBorder(
                          borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(20),
                            bottomLeft: Radius.circular(20),
                            topRight: Radius.circular(20),
                            bottomRight: Radius.elliptical(20, 20),
                          ),
                        ),
                        tileColor: defaultColor,
                        title: Text(
                          currentItem["name"],
                          style: TextStyle(
                            color: textColor,
                            fontWeight: FontWeight.bold,
                            fontSize: 18,
                          ),
                        ),
                        subtitle: Text(
                          currentItem["email"].toString(),
                          style: TextStyle(
                            color: textColor,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        // trailing: Row(
                        //   mainAxisSize: MainAxisSize.min,
                        //   children: [
                        //     IconButton(
                        //       onPressed: () => _showForm(ctx, currentItem['key']),
                        //       icon: const Icon(Icons.edit),
                        //     ),
                        //     IconButton(
                        //       onPressed: () => _deleteItem(currentItem['key']),
                        //       icon: const Icon(Icons.delete),
                        //     ),
                        //   ],
                        // ),
                      ),
                    );
                  }),
            ),
    );
  }
}
