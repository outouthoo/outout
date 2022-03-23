import 'package:flutter/material.dart';
import 'package:out_out/utils/icon_utils.dart';

class DynamicAppbarForSearching extends StatefulWidget {
  Function onClear;
  Function onTextSearching;

  DynamicAppbarForSearching({
   @required this.onClear,
    @required this.onTextSearching,
  });

  @override
  _DynamicAppbarForSearchingState createState() =>
      _DynamicAppbarForSearchingState();
}

class _DynamicAppbarForSearchingState extends State<DynamicAppbarForSearching> {
  bool _isDefaultAppbar = true;
  bool _isClear = false;
  final _focusNodeSearchStories = FocusNode();
  final _searchQueryTextEditingController = TextEditingController();

  Widget buildAppBar() {
    Widget appbar = AppBar(
      centerTitle: true,
      backgroundColor: Colors.black,
      elevation: 0.0,
      leading: IconButton(
        icon: Icon(
          Icons.arrow_back_ios,
          color: Colors.white,
        ),
        onPressed: () {
          Navigator.of(context).pop();
        },
      ),
      title:  Container(height: 70,
          child: Image.asset(out_out_actionbar)),
      actions: <Widget>[
        IconButton(
          onPressed: () {
            setState(() {
              _isDefaultAppbar = !_isDefaultAppbar;
            });
          },
          icon: Icon(
            Icons.search,
            color: Colors.white,
          ),
        ),
      ],
    );

    if (!_isDefaultAppbar) {
      appbar = AppBar(
        automaticallyImplyLeading: false,
        elevation: 0.0,
        backgroundColor: Colors.black,
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back_ios,
            color: Colors.white,
          ),
          onPressed: () {
            widget.onClear();
            _searchQueryTextEditingController.text = "";
            FocusScope.of(context).requestFocus(_focusNodeSearchStories);
            setState(() {
              _isDefaultAppbar = !_isDefaultAppbar;
            });
          },
        ),
        title: TextField(
          autofocus: true,
          controller: _searchQueryTextEditingController,
          style: TextStyle(
            color: Colors.white70,
            letterSpacing: 1.5,
          ),
          focusNode: _focusNodeSearchStories,
          cursorColor: Colors.white70,
          textInputAction: TextInputAction.done,
          decoration: InputDecoration(
            hintText: 'Search...',
            border: InputBorder.none,
            hintStyle: TextStyle(
              color: Colors.white70,
              letterSpacing: 1.5,
            ),
          ),
        ),
        actions: [
          if (_isClear)
            IconButton(
              onPressed: () {
                widget.onClear();
                _searchQueryTextEditingController.text = "";
              },
              icon: Icon(
                Icons.clear,
                color: Colors.white70,
              ),
            ),
        ],
      );
    }

    return appbar;
  }

  @override
  void initState() {
    _searchQueryTextEditingController.addListener(() {
      if (_searchQueryTextEditingController.text.isNotEmpty) {
        setState(() {
          _isClear = true;
        });
      } else {
        setState(() {
          _isClear = false;
        });
      }
      widget.onTextSearching(_searchQueryTextEditingController.text);
    });
    super.initState();
  }

  @override
  void dispose() {
    _focusNodeSearchStories.dispose();
    _searchQueryTextEditingController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return buildAppBar();
  }
}
