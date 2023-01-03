import "package:flutter/material.dart";

class navButton extends StatefulWidget {
  const navButton({Key? key, required this.buttonString, required this.function}) : super(key: key);

  final String buttonString;
  final Widget function;

  @override
  State<navButton> createState() => _navButtonState();
}

class _navButtonState extends State<navButton> {

  Color color1 = Color(0XFF89143B); //dark red
  Color color2 = Color(0XFFFEF3F7); //pale red
  Color color3 = Color(0XFF6A266F); //Pale purple
  Color color4 = Color(0XFFF8F5F8); //dark purple
  Color color5 = Color(0XFFFFE7DF); //pale orange/brown
  Color color6 = Color(0XFFB6360A); //dark orange/brown

  navigateToPage(Widget widget) {
    Navigator.push(context, MaterialPageRoute(builder: (context) => widget));
  }

  @override
  Widget build(BuildContext context) {
    String buttonString = widget.buttonString;
    Widget function = widget.function;

    return
      Padding(
        padding: const EdgeInsets.only(bottom: 20.0),
        child: SizedBox(
          width: 200,
          child: TextButton(
            child: Container(
              width: 200,
              decoration: BoxDecoration(
                  border: Border.all(color: color3),
                  gradient: LinearGradient(
                    begin: Alignment.topRight,
                    end: Alignment(-0.1, -0.1),
                    colors: [
                      color3,
                      color4,
                    ],
                  ),
                  borderRadius: BorderRadius.all(Radius.circular(90))
              ),
              padding: const EdgeInsets.all(16.0),
              child: Text(buttonString,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontFamily: 'Viking',
                  fontSize: 15,
                  color: Colors.black,
                ),),
            ),
            onPressed: () {
              navigateToPage(function);
            },

          ),
        ),
      );
  }
}
