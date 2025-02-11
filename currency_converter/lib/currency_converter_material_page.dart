import 'package:flutter/material.dart';
// 1.Create the variables that store the converted currency value
// 2.Create a funaction that multiples given by the valuse given by the textfield with
// 3.Store the value in the variables that we created
// 4.Display the variables

class CurrencyConverterMaterialPage extends StatefulWidget {
  CurrencyConverterMaterialPage({super.key}) {}

  @override
  State<CurrencyConverterMaterialPage> createState() =>
      _CurrencyConverterMaterialPageState();
}

class _CurrencyConverterMaterialPageState
    extends State<CurrencyConverterMaterialPage> {
  //Logic Part
  double result = 0;
  final TextEditingController textEditingController = TextEditingController();

  void convert() {
    result = double.parse(textEditingController.text) * 80.0;
    setState(() {});
  }

//initState Ye method sirf ek baar call hota hai, jab widget pehli baar build hota hai.
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

//Dispose concept hai, jo resources ko clean up karne ke liye use hota hai.
  @override
  void dispose() {
    // TODO: implement dispose
    textEditingController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blueGrey,
      appBar: AppBar(
        backgroundColor: Colors.blueGrey,
        elevation: 0,
        title: Text(
          'Currency Converter',
          style: TextStyle(
            color: Colors.white,
          ),
        ),
        centerTitle: true,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'PKR ${result != 0 ? result.toStringAsFixed(3) : result.toStringAsFixed(0)}',
              style: TextStyle(
                  fontSize: 45,
                  fontWeight: FontWeight.bold,
                  color: Color.fromARGB(255, 255, 255, 255)),
            ),
            Padding(
              padding: const EdgeInsets.all(10),
              child: TextField(
                controller: textEditingController,
                style: TextStyle(color: Colors.black),
                decoration: InputDecoration(
                  hintText: 'Please Enter the Amount in USD',
                  hintStyle: TextStyle(color: Colors.black),
                  prefix: Text(
                    '\$ ',
                    style: TextStyle(fontSize: 20),
                  ),
                  prefixIconColor: Colors.white60,
                  filled: true,
                  fillColor: Colors.white,
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                      width: 2.0,
                      style: BorderStyle.solid,
                    ),
                    borderRadius: BorderRadius.all(Radius.circular(5)),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                      width: 2.0,
                      style: BorderStyle.solid,
                    ),
                    borderRadius: BorderRadius.all(Radius.circular(5)),
                  ),
                ),
                keyboardType: TextInputType.numberWithOptions(
                  decimal: true,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(10),
              child: TextButton(
                onPressed: convert,

                //Ek screen se dusri Ek nayi screen par jane ke liye Navigator.push() method ka use karte hain.
                // onPressed: () {
                //   Navigator.of(context).push(MaterialPageRoute(
                //       builder: (context) => CurrencyConverterCupertinoPage()));
                // }, //convert,
                style: TextButton.styleFrom(
                  elevation: (15),
                  backgroundColor: (Colors.black),
                  foregroundColor: (Colors.white),
                  minimumSize: Size(400, 50),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(5),
                  ),
                ),
                child: Text('Convert'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
