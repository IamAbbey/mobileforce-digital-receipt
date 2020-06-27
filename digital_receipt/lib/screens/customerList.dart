import 'package:digital_receipt/models/customer.dart';
import 'package:digital_receipt/screens/customer_list_detail.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

// import 'customerDetails/customerDetail.dart';

/// This code displays only the UI
class CustomerList extends StatefulWidget {
  @override
  _CustomerListState createState() => _CustomerListState();
}

class _CustomerListState extends State<CustomerList> {
  String dropdownValue = "Last Upadated";

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // backgroundColor: Color(0xffE5E5E5),
      appBar: AppBar(
        backgroundColor: Color(0xff226EBE),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          color: Colors.white,
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        title: Text(
          "Customer List",
          style: TextStyle(
            color: Colors.white,
            fontSize: 18,
            fontWeight: FontWeight.w600,
            fontFamily: 'Montserrat',
            letterSpacing: 0.03,
          ),
        ),
        centerTitle: true,
      ),
      body: FutureBuilder(
        future: null, // receipts from API
        builder: (context, snapshot) {
          // If the API returns nothing it means the user has to upgrade to premium
          // for now it doesn't validate if the user has upgraded to premium
          /// If the API returns nothing it shows the dialog box `JUST FOR TESTING`
          ///

          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: CircularProgressIndicator(),
            );
          } else {
            return Padding(
              padding: EdgeInsets.only(top: 15.0, left: 16, right: 16),
              child: Column(
                children: <Widget>[
                  SizedBox(height: 10.0),
                  TextFormField(
                    decoration: InputDecoration(
                      hintText: "Type a keyword",
                      hintStyle: TextStyle(color: Colors.grey),
                      prefixIcon: IconButton(
                        icon: Icon(Icons.search),
                        color: Colors.grey,
                        onPressed: () {},
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(5),
                        borderSide: BorderSide(
                          color: Color(0xFFC8C8C8),
                          width: 1.5,
                        ),
                      ),
                      contentPadding: EdgeInsets.all(15),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(5),
                        borderSide: BorderSide(
                          color: Color(0xFFC8C8C8),
                          width: 1.5,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: 30.0),
                  Row(mainAxisAlignment: MainAxisAlignment.end, children: [
                    Padding(
                      padding: EdgeInsets.only(right: 10.0),
                      child: Text("Sort By"),
                    ),
                    Container(
                      width: 150,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(
                          color: Color(0xff25CCB3),
                        ),
                      ),
                      child: SizedBox(
                        height: 40,
                        child: DropdownButtonHideUnderline(
                          child: DropdownButton(
                            value: dropdownValue,
                            underline: Divider(),
                            items: <String>[
                              "Last Upadated",
                              "A to Z",
                              "Z to A",
                            ].map<DropdownMenuItem<String>>(
                              (String value) {
                                return DropdownMenuItem<String>(
                                  value: value,
                                  child: Padding(
                                    padding: EdgeInsets.only(left: 8.0),
                                    child: Text(
                                      value,
                                      textAlign: TextAlign.start,
                                    ),
                                  ),
                                );
                              },
                            ).toList(),
                            onChanged: (String value) {
                              setState(() => dropdownValue = value);
                              // No logic Implemented
                            },
                          ),
                        ),
                      ),
                    ),
                  ]),
                  SizedBox(height: 20.0),
                  Flexible(
                    child: ListView.builder(
                      itemCount: 25,
                      itemBuilder: (context, index) {
                        // HardCoded Receipt details
                        return customer(
                            customerName: "Carole Froschauer",
                            customerEmail: "caroFro@gmail.com",
                            phoneNumber: "741-142-4459",
                            numberOfReceipts: 4);
                      },
                    ),
                  ),
                ],
              ),
            );
          }
          // }
        },
      ),
    );
  }

  Widget customer(
      {String customerName, customerEmail, phoneNumber, int numberOfReceipts}) {
    return SizedBox(
      height: 99,
      child: Column(
        children: <Widget>[
          Slidable(
            actionPane: SlidableDrawerActionPane(),
            actionExtentRatio: 0.25,
            secondaryActions: <Widget>[
              IconSlideAction(
                  caption: "Call Customer",
                  color: Color(0xffB3E2F4),
                  icon: Icons.phone,
                  onTap: () {}),
              Container(
                color: Color(0xffBFEDC7),
                child: InkWell(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Image.asset("assets/gmail.png", height: 25, width: 25),
                      Text("Mail Customer"),
                    ],
                  ),
                ),
              )
            ],
            child: InkWell(
              onTap: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => CustomerDetail(
                      customer: Customer(
                        name: customerName,
                        email: customerEmail,
                        phoneNumber: phoneNumber,
                        address: '',
                      ),
                    ),
                  ),
                );
              },
              child: Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  color: Color(0xff539C30),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Container(
                  margin: EdgeInsets.only(left: 5.0),
                  decoration: BoxDecoration(
                    color: Color(0xffE8F1FB),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: EdgeInsets.all(10.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            Text(
                              "$customerName",
                              style: TextStyle(
                                color: Color.fromRGBO(0, 0, 0, 0.6),
                                fontSize: 14,
                                fontWeight: FontWeight.w600,
                                fontFamily: 'Montserrat',
                                letterSpacing: 0.03,
                              ),
                            ),
                            Text(
                              "$numberOfReceipts Receipts",
                              style: TextStyle(
                                color: Color.fromRGBO(0, 0, 0, 0.6),
                                fontSize: 14,
                                fontWeight: FontWeight.w300,
                                fontFamily: 'Montserrat',
                                letterSpacing: 0.03,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.fromLTRB(10.0, 5.0, 5.0, 5.0),
                        child: Text(
                          "$customerEmail",
                          style: TextStyle(
                            color: Color.fromRGBO(0, 0, 0, 0.87),
                            fontSize: 14,
                            fontWeight: FontWeight.w300,
                            fontFamily: 'Montserrat',
                            letterSpacing: 0.03,
                          ),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.fromLTRB(10.0, 5.0, 5.0, 5.0),
                        child: Text(
                          "$phoneNumber",
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 14,
                            fontWeight: FontWeight.w300,
                            fontFamily: 'Montserrat',
                            letterSpacing: 0.03,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
          SizedBox(
            height: 30,
          ),
        ],
      ),
    );
  }
}
