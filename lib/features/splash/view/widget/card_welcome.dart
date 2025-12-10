import 'package:flutter/material.dart';

class CardWelcome extends StatelessWidget {
  final String imge;
  final String name;
  final Color color;

  const CardWelcome({super.key,required this.imge,required this.name, required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 314,
      height: 252,
      alignment: Alignment.center,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
          color: color,
        ),
      child: Stack(
        children: [
          Align(
            alignment: Alignment.bottomRight,
            child: Container(
              width: 264,
              height: 222,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8),
                image: DecorationImage(
                  image: AssetImage(imge)
                )
              ),
            ),
          ),
          Align(alignment: Alignment.topLeft, child: Padding(
            padding: const EdgeInsets.all(15),
            child: Text(name, style: TextStyle(color: Colors.white, fontSize: 22, fontWeight: FontWeight.bold),),
          ))
        ],
      ),
    );
  }
}