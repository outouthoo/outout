import 'package:flutter/material.dart';
import 'package:out_out/models/list_business_account_modal.dart';
import 'package:out_out/providers/common_details_provider.dart';
import 'package:out_out/widget/app_error.dart';
import 'package:out_out/widget/app_loader.dart';
import 'package:provider/provider.dart';

class BusinessAccountList extends StatefulWidget {
  const BusinessAccountList({Key key}) : super(key: key);

  @override
  _BusinessAccountListState createState() => _BusinessAccountListState();
}

class _BusinessAccountListState extends State<BusinessAccountList> {
  User user;
  GetBusinessListResponse _response;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    user = Provider.of<CommonDetailsProvider>(context, listen: false).user;

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: Colors.black,
        elevation: 0.0,
        automaticallyImplyLeading: false,
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back_ios,
            color: Colors.white,
          ),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
      ),
      body: _response == null
          ? AppLoader()
          : (_response != null && _response.errorcode == "1")
              ? AppError(
                  error: _response.msg,
                )
              : ListView.builder(
                  padding: EdgeInsets.all(8),
                  itemCount: _response.data.length,
                  itemBuilder: (context, index) {
                    return Container();
                  },
                ),
    );
  }
}
