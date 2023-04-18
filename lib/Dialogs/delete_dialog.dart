import "package:flutter/material.dart";

void showDeleteDialog(BuildContext context, void Function()? onPressed) {
  showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(
            "Delete shared preferences",
            style: TextStyle(color: Theme.of(context).primaryColor),
          ),
          content:
              Text("Are you sure you want to delete all shared preferences?"),
          actions: [
            TextButton(onPressed: onPressed, child: Text("Yes")),
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text("Cancel", style: TextStyle(color: Colors.red)),
            ),
          ],
        );
      });
}
