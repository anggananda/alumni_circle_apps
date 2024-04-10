import 'package:flutter/material.dart';
import 'package:my_app/dto/books.dart';
import 'package:my_app/services/db_helper.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

class BooksScreen extends StatefulWidget {
  const BooksScreen({super.key});

  @override
  State<BooksScreen> createState() => _BooksScreenState();
}

class _BooksScreenState extends State<BooksScreen> {
  final GlobalKey<FormState> _formStateKey = GlobalKey<FormState>();
  Future<List<Books>>? books;
  late String _title;
  bool isUpdate = false;
  late int? bookIdForUpdate;
  late DBHelper dbHelper;
  final _bookTitleController = TextEditingController();

  @override
  void initState() {
    super.initState();
    dbHelper = DBHelper();
    refreshBookLists();
  }

  @override
  void dispose() {
    _bookTitleController.dispose();
    dbHelper.close();
    super.dispose();
  }

  void cancelTextEditing() {
    _bookTitleController.text = '';
    setState(() {
      isUpdate = false;
      bookIdForUpdate = null;
    });
    closeKeyboard();
  }

  void closeKeyboard() {
    FocusManager.instance.primaryFocus?.unfocus();
  }

  Future<void> refreshBookLists() async {
    try {
      await dbHelper.initDatabase();
      setState(() {
        books = dbHelper.getBooks();
        isUpdate = false;
      });
    } catch (error) {
      debugPrint('Error fetching books: $error');
    }
  }

  void createOrUpdateBooks() {
    _formStateKey.currentState?.save();
    if (!isUpdate) {
      dbHelper.add(Books(null, _title));
    } else {
      dbHelper.update(Books(bookIdForUpdate, _title));
    }
    _bookTitleController.text = '';
    refreshBookLists();
  }

  void editFormBook(BuildContext context, Books book) {
    setState(() {
      isUpdate = true;
      bookIdForUpdate = book.id!;
    });
    _bookTitleController.text = book.title;
  }

  void deleteBook(BuildContext context, int bookID) {
    setState(() {
      isUpdate = false;
    });
    _bookTitleController.text = '';
    dbHelper.delete(bookID);
    refreshBookLists();
  }

  @override
  Widget build(BuildContext context) {
    var textFormField = TextFormField(
      onSaved: (value) {
        _title = value!;
      },
      autofocus: false,
      controller: _bookTitleController,
      decoration: InputDecoration(
          focusedBorder: UnderlineInputBorder(
              borderSide: BorderSide(
                  color: !isUpdate ? Colors.purple : Colors.blue,
                  width: 2,
                  style: BorderStyle.solid)),
          labelText: !isUpdate ? 'Add Book Title' : 'Edit Book Title',
          icon:
              Icon(Icons.book, color: !isUpdate ? Colors.purple : Colors.blue),
          fillColor: Colors.white,
          labelStyle:
              TextStyle(color: !isUpdate ? Colors.purple : Colors.blue)),
    );
    return Scaffold(
      appBar: AppBar(),
        body: Column(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Form(
            key: _formStateKey,
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: textFormField,
                ),
              ],
            )),
        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            ElevatedButton(
                onPressed: () {
                  createOrUpdateBooks();
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: !isUpdate
                      ? Colors.purple
                      : Colors.blue, // Set background color
                  foregroundColor: Colors.white,
                ),
                child: !isUpdate ? const Text('Save') : const Text('Update')),
            const SizedBox(
              width: 10,
            ),
            ElevatedButton(
                onPressed: () {
                  cancelTextEditing();
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.orange, // Set background color
                  foregroundColor: Colors.white,
                ),
                child: const Text('Cancel')),
          ],
        ),
        const Divider(),
        Expanded(
            child: FutureBuilder(
          future: books,
          builder: (context, snapshot) {
            if (!snapshot.hasData) {
              return const Text('No Data');
            }
            if (snapshot.hasData) {
              return generateList(snapshot.data!);
            }
            return const CircularProgressIndicator();
          },
        ))
      ],
    ));
  }

  Widget generateList(List<Books> books) {
    return ListView.builder(
      itemCount: books.length,
      itemBuilder: (context, index) => Slidable(
        // Customize appearance and behavior as needed
        key: ValueKey(index),
        endActionPane: ActionPane(
          motion: const ScrollMotion(),
          children: [
            SlidableAction(
              // An action can be bigger than the others.
              onPressed: (context) => editFormBook(context, books[index]),
              backgroundColor: Colors.blue,
              foregroundColor: Colors.white,
              icon: Icons.edit,
              label: 'Edit',
            ),
            SlidableAction(
              // An action can be bigger than the others.
              onPressed: (context) => deleteBook(context, books[index].id!),
              backgroundColor: Colors.red,
              foregroundColor: Colors.white,
              icon: Icons.delete,
              label: 'Delete',
            ),
          ],
        ), // Assuming each book has a unique id
        child: ListTile(title: Text(books[index].title)),
      ),
    );
  }
}