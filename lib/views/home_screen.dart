import 'package:flutter/material.dart';
import 'package:sell_books_online/resources/widgets/button_item.dart';
import 'package:sell_books_online/resources/widgets/custom_button.dart';
import 'package:sell_books_online/resources/widgets/text_input_widget.dart';
import 'package:flutter/services.dart';

class Receipt {
  String name = '';
  int quantity = 0;
  bool isVip = false;
  double totalPrice = 0.0;

  Receipt(this.name, this.quantity, this.isVip, this.totalPrice);
}

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  TextEditingController? nameController;
  TextEditingController? quantityController;
  bool isChecked = false;
  String totalPriceStr = "Chưa xác định";
  String totalCustomerStr = "Chưa xác định";
  String totalVipCustomerStr = "Chưa xác định";
  String totalRevenueStr = "Chưa xác định";

  var receiptList = <Receipt>[];

  double get totalPrice {
    double total = 20000 * double.parse(quantityController!.text.trim());
    if (isChecked) total = total / 100 * 90;
    return total;
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    nameController = TextEditingController();
    quantityController = TextEditingController();
  }

  @override
  Widget build(BuildContext context) {


    Color getColor(Set<MaterialState> states) {
      const Set<MaterialState> interactiveStates = <MaterialState>{
        MaterialState.pressed,
        MaterialState.hovered,
        MaterialState.focused,
      };
      if (states.any(interactiveStates.contains)) {
        return Colors.blue;
      }
      return Colors.red;
    }


    Future<void> _showMyDialog() async {
      return showDialog<void>(
        context: context,
        barrierDismissible: false, // user must tap button!
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('AlertDialog Title'),
            content: SingleChildScrollView(
              child: ListBody(
                children: const <Widget>[
                  Text('This is a demo alert dialog.'),
                  Text('Would you like to approve of this message?'),
                ],
              ),
            ),
            actions: <Widget>[
              TextButton(
                child: const Text('Approve'),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        },
      );
    }


    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.green,
        toolbarHeight: 30,
        title: const Text("Chương trình bán sách Online", style: TextStyle(color: Colors.white, fontSize: 14),),
        centerTitle: true,
      ),
      body: Container(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        child: Column(
          children: [
            //Thông tin hóa đơn
            Container(
              child: Column(
                children: [
                  //Title
                  Container(
                    color: Colors.green,
                    height: 30,
                    width: MediaQuery.of(context).size.width,
                    child: const Align(
                      alignment: Alignment.centerLeft,
                      child: Text("Thông tin hóa đơn", style: TextStyle(color: Colors.black, fontSize: 14),),
                    ),
                  ),
                  //Nhập tên khách hàng
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      const Expanded(
                        flex: 1,
                        child: Text("Tên Khách Hàng:"),
                      ),
                      Expanded(
                        flex: 2,
                        child: TextInputWidget(
                          hintText: "Nhập Tên Khách Hàng",
                          controller: nameController,
                        ),
                      ),
                    ],
                  ),
                  //Nhập số lượng sách
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      const Expanded(
                        flex: 1,
                        child: Text("Số lượng sách:"),
                      ),
                      Expanded(
                        flex: 2,
                        child: TextInputWidget(
                          hintText: "Nhập số lượng sách",
                          controller: quantityController,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  //Check khách hàng vip
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      const Expanded(
                        flex: 1,
                        child: Text(""),
                      ),
                      Expanded(
                        flex: 2,
                        child: Row(
                          children: [
                            Checkbox(
                              checkColor: Colors.white,
                              fillColor: MaterialStateProperty.resolveWith(getColor),
                              value: isChecked,
                              onChanged: (bool? value) {
                                setState(() {
                                  isChecked = value!;
                                });
                              },
                            ),
                            const Text("  Khách hàng Vip"),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  //Thành tiền
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      const Expanded(
                        flex: 1,
                        child: Text("Thành Tiền:"),
                      ),
                      Expanded(
                        flex: 2,
                        child: Container(
                          color: Colors.grey,
                          height: 30,
                          width: MediaQuery.of(context).size.width,
                          child: Align(
                            alignment: Alignment.center,
                            child: Text(totalPriceStr),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  //Button list
                  Row(
                    children: [
                      const SizedBox(
                        width: 5,
                      ),
                      Expanded(
                        flex: 1,
                        child: CustomButton(
                          onPressed: () {
                            setState(() {
                              totalPriceStr = '${totalPrice.toStringAsFixed(1)} vnd';
                            });
                          },
                          buttonText: "TÍNH THÀNH TIỀN",
                          buttonColor: Colors.grey,
                        ),
                      ),
                      const SizedBox(
                        width: 10,
                      ),
                      Expanded(
                        flex: 1,
                        child: CustomButton(
                          onPressed: () {
                            setState(() {
                              String name = nameController!.text.trim();
                              int quantity = int.parse(quantityController!.text.trim());
                              bool isVip = isChecked;
                              double total = totalPrice;
                              var receipt = Receipt(name, quantity, isVip, total);
                              receiptList.add(receipt);
                              totalCustomerStr = receiptList.length.toString();
                              int countVip = 0;
                              for (Receipt r in receiptList) {
                                if (r.isVip) countVip++;
                              }
                              totalVipCustomerStr = countVip.toString();
                              total = 0.0;
                              for (Receipt r in receiptList) {
                                total += r.totalPrice;
                              }
                              totalRevenueStr = '${total.toStringAsFixed(1)} vnd';
                              nameController!.text = '';
                              quantityController!.text = '';
                            });
                          },
                          buttonText: "LƯU THÔNG TIN",
                          buttonColor: Colors.grey,
                        ),
                      ),
                      const SizedBox(
                        width: 10,
                      ),
                      Expanded(
                        flex: 1,
                        child: CustomButton(
                          onPressed: () {
                            showDialog<String>(
                              context: context,
                              builder: (BuildContext context) => AlertDialog(
                                title: const Text('TỔNG DOANH THU'),
                                content: SizedBox(
                                  width: MediaQuery.of(context).size.width,
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text(totalRevenueStr, style: const TextStyle(fontSize: 35),),
                                    ],
                                  ),
                                ),
                                actions: <Widget>[
                                  //TextButton(
                                  //  onPressed: () => Navigator.pop(context, 'Cancel'),
                                  //  child: const Text('Cancel'),
                                  //),
                                  TextButton(
                                    onPressed: () => Navigator.pop(context, 'OK'),
                                    child: const Text('OK'),
                                  ),
                                ],
                              ),
                            );
                          },
                          buttonText: "TỔNG DOANH THU",
                          buttonColor: Colors.grey,
                        ),
                      ),
                      const SizedBox(
                        width: 5,
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                ],
              ),
            ),
            //Thông tin thống kê
            Column(
              children: [
                //Title
                Container(
                  color: Colors.green,
                  height: 30,
                  width: MediaQuery.of(context).size.width,
                  child: const Align(
                    alignment: Alignment.centerLeft,
                    child: Text("Thông tin thống kê", style: TextStyle(color: Colors.black, fontSize: 14),),
                  ),
                ),
                const SizedBox(
                  height: 15,
                ),
                //Tổng số KH
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    const Expanded(
                      flex: 1,
                      child: Text("Tổng số KH:"),
                    ),
                    Expanded(
                      flex: 2,
                      child: Text(totalCustomerStr),
                    ),
                  ],
                ),
                const SizedBox(
                  height: 20,
                ),
                //Tổng số KH là VIP
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    const Expanded(
                      flex: 1,
                      child: Text("Tổng số KH là VIP:"),
                    ),
                    Expanded(
                      flex: 2,
                      child: Text(totalVipCustomerStr),
                    ),
                  ],
                ),
                const SizedBox(
                  height: 20,
                ),
                //Tổng doanh thu
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    const Expanded(
                      flex: 1,
                      child: Text("Tổng doanh thu:"),
                    ),
                    Expanded(
                      flex: 2,
                      child: Text(totalRevenueStr),
                    ),
                  ],
                ),
                const SizedBox(
                  height: 15,
                ),
              ],
            ),
            //Thoát ứng dụng
            Container(
              child: Column(
                children: [
                  //Title
                  Container(
                    color: Colors.green,
                    height: 30,
                    width: MediaQuery.of(context).size.width,
                    child: const Text(""),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  //Tổng số KH
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      ButtonItem(
                          onPress: () {
                            showDialog<String>(
                              context: context,
                              builder: (BuildContext context) => AlertDialog(
                                title: const Text('Alert Dialog'),
                                content: SizedBox(
                                  width: MediaQuery.of(context).size.width,
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: const [
                                      Text('Do you want to exit the app?', style: TextStyle(fontSize: 26),),
                                    ],
                                  ),
                                ),
                                actions: <Widget>[
                                  TextButton(
                                    onPressed: () => Navigator.pop(context, 'Cancel'),
                                    child: const Text('Cancel'),
                                  ),
                                  TextButton(
                                    //onPressed: () => Navigator.pop(context, 'OK'),
                                    onPressed: ()=> SystemNavigator.pop(),
                                    child: const Text('OK'),
                                  ),
                                ],
                              ),
                            );
                          },
                          //iconData: Icons.exit_to_app,
                          iconData: Icons.logout,
                          buttonText: "",
                          buttonColor: Colors.blue,
                      ),
                      const SizedBox(
                        width: 20,
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
