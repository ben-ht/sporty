import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class SocialButton extends StatelessWidget {
  const SocialButton({super.key, required this.socialIcon});

  final String socialIcon;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(40),
      boxShadow: [
        BoxShadow(
          color: Colors.blueGrey,
          blurRadius: 4,
          offset: Offset(2, 4), // Shadow position
        ),
      ],
    ),
      child: SizedBox(
        width: 50,
        height: 50,
        child: IconButton(
          onPressed: (){},
          icon: SvgPicture.asset(
            socialIcon,
            height: 50,
          ),
          padding: EdgeInsets.all(0.0), // Remove extra padding
        ),
      ),

    );
  }
}