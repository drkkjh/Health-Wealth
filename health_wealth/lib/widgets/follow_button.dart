import 'package:flutter/material.dart';

class FollowButton extends StatelessWidget {
  final Function()? function;
  final bool isFollowing;

  const FollowButton({Key? key, required this.isFollowing, this.function})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (isFollowing) {
      return Container(
        alignment: Alignment.center,
        padding: const EdgeInsets.symmetric(vertical: 2, horizontal: 8),
        child: TextButton(
          onPressed: function,
          child: Container(
            height: 55,
            width: 100,
            decoration: BoxDecoration(
              color: Colors.blue,
              border: Border.all(color: Colors.grey),
              borderRadius: BorderRadius.circular(5),
            ),
            child: const Center(
              child: Text(
                'unfollow',
                style: TextStyle(color: Colors.white),
              ),
            ),
          ),
        ),
      );
    } else {
      return Container(
        alignment: Alignment.center,
        padding: const EdgeInsets.symmetric(vertical: 2, horizontal: 8),
        child: TextButton(
          onPressed: function,
          child: Container(
            height: 55,
            width: 100,
            decoration: BoxDecoration(
              color: Colors.white,
              border: Border.all(color: Colors.grey),
              borderRadius: BorderRadius.circular(5),
            ),
            child: const Center(
              child: Text(
                'follow',
                style: TextStyle(color: Colors.black),
              ),
            ),
          ),
        ),
      );
    }
  }
}
