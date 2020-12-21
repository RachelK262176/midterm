import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:http/http.dart' as http;
import 'package:midterm/book.dart';
import 'dart:convert';

import 'package:midterm/mainscreen.dart';

void main() => runApp(DetailScreen());

class DetailScreen extends StatefulWidget {
  final Books book;

  const DetailScreen({Key key, this.book}) : super(key: key);

  @override
  _DetailScreenState createState() => _DetailScreenState();
}

class _DetailScreenState extends State<DetailScreen> {
  double screenHeight, screenWidth;
  List bookList;
  String titlecenter = '';

  @override
  void initState() {
    super.initState();
    _loadBooks();
  }

  @override
  Widget build(BuildContext context) {
    screenHeight = MediaQuery.of(context).size.height;
    screenWidth = MediaQuery.of(context).size.width;

    return MaterialApp(
        home: Scaffold(
            appBar: AppBar(
              backgroundColor: Colors.cyanAccent,
              title: Text(widget.book.booktitle,
                  style: TextStyle(color: Colors.black)),
            ),
            floatingActionButton: FloatingActionButton.extended(
              onPressed: () {
                _back();
              },
              icon: Icon(Icons.arrow_back_rounded, color: Colors.white),
              label: Text("Back",
                  style: TextStyle(
                      fontStyle: FontStyle.italic,
                      fontWeight: FontWeight.w400)),
            ),
            body: Container(
                child: Padding(
                    padding: EdgeInsets.fromLTRB(30, 10, 30, 10),
                    child: SingleChildScrollView(
                      child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Container(
                                height: screenHeight / 2.0,
                                width: screenWidth / 0.1,
                                child: CachedNetworkImage(
                                  imageUrl:
                                      "http://slumberjer.com/bookdepo/bookcover/${widget.book.cover}.jpg",
                                  fit: BoxFit.cover,
                                  placeholder: (context, url) =>
                                      new CircularProgressIndicator(),
                                  errorWidget: (context, url, error) =>
                                      new Icon(
                                    Icons.broken_image,
                                    size: screenWidth / 2,
                                  ),
                                )),
                            SizedBox(height: 10),
                            Text(
                              'Book ID: ' + widget.book.bookid,
                              style: TextStyle(
                                  fontSize: 16, fontWeight: FontWeight.bold),
                            ),
                            SizedBox(height: 10),
                            Text(
                              'Book Title: ' + widget.book.booktitle,
                              style: TextStyle(
                                  fontSize: 16, fontWeight: FontWeight.bold),
                            ),
                            SizedBox(height: 10),
                            Text(
                              'Book Author: ' + widget.book.author,
                              style: TextStyle(
                                  fontSize: 16, fontWeight: FontWeight.bold),
                            ),
                            SizedBox(height: 10),
                            Text(
                              'Book Price: RM' + widget.book.price,
                              style: TextStyle(
                                  fontSize: 16, fontWeight: FontWeight.bold),
                            ),
                            SizedBox(height: 10),
                            Text(
                              'Book Description: ' + widget.book.description,
                              style: TextStyle(
                                  fontSize: 16, fontWeight: FontWeight.bold),
                            ),
                            SizedBox(height: 10),
                            Text(
                              'Book Rationg: ' + widget.book.rating,
                              style: TextStyle(
                                  fontSize: 16, fontWeight: FontWeight.bold),
                            ),
                            SizedBox(height: 10),
                            Text(
                              'Book Publisher: ' + widget.book.publisher,
                              style: TextStyle(
                                  fontSize: 16, fontWeight: FontWeight.bold),
                            ),
                            SizedBox(height: 10),
                            Text(
                              'Book isbn: ' + widget.book.isbn,
                              style: TextStyle(
                                  fontSize: 16, fontWeight: FontWeight.bold),
                            ),
                          ]),
                    )))));
  }

  void _loadBooks() {
    http.post("http://slumberjer.com/bookdepo/php/load_books.php",
        body: {}).then((res) {
      print(res.body);
      if (res.body == "nodata") {
        bookList = null;
        setState(() {
          titlecenter = "No Book Found";
        });
      } else {
        setState(() {
          var jsondata = json.decode(res.body);
          bookList = jsondata["books"];
        });
      }
    }).catchError((err) {
      print(err);
    });
  }

  void _back() {
    Navigator.push(context,
        MaterialPageRoute(builder: (BuildContext context) => MainScreen()));
  }
}
