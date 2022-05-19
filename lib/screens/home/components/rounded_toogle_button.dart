import 'package:flutter/material.dart';
import 'package:prorum_flutter/constant.dart';

class RoundedToogleButton extends StatelessWidget {
  final double selected;
  final Function() onTapAll;
  final Function() onTapFavorites;
  const RoundedToogleButton({
    Key? key,
    required this.selected,
    required this.onTapAll,
    required this.onTapFavorites,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    double width = size.width * 0.95;
    double height = 32;

    return Center(
      child: Container(
        width: width,
        height: height,
        decoration: BoxDecoration(
          color: Colors.grey[200]!,
          borderRadius: BorderRadius.circular(10.0),
        ),
        child: Stack(
          children: [
            AnimatedAlign(
              alignment: Alignment(selected, 0),
              duration: const Duration(milliseconds: 300),
              child: Padding(
                padding: const EdgeInsets.all(3.0),
                child: Container(
                  width: width * 0.5,
                  height: height,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                ),
              ),
            ),
            GestureDetector(
              onTap: onTapAll,
              child: Align(
                alignment: const Alignment(-1, 0),
                child: Container(
                  width: width * 0.5,
                  color: Colors.transparent,
                  alignment: Alignment.center,
                  child: Text(
                    'All',
                    style: TextStyle(
                      color: selected == -1 ? kPrimaryColor : Colors.grey[400]!,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ),
            GestureDetector(
              onTap: onTapFavorites,
              child: Align(
                alignment: const Alignment(1, 0),
                child: Container(
                  width: width * 0.5,
                  color: Colors.transparent,
                  alignment: Alignment.center,
                  child: Text(
                    'Favorites',
                    style: TextStyle(
                      color: selected == 1 ? kPrimaryColor : Colors.grey[400]!,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}


