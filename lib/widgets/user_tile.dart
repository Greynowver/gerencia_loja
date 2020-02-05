import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class UserTile extends StatelessWidget {

  final Map<String, dynamic> users;
  UserTile(this.users);

  @override
  Widget build(BuildContext context) {

    final textStyle = TextStyle(color: Colors.white);
    
    if(users.containsKey("money"))
      return ListTile(
          title: Text(
              users["name"],
              style: textStyle
          ),
          subtitle: Text(
              users["email"],
              style: textStyle
          ),
          trailing: Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: <Widget>[
              Text(
                  "Pedidos: ${users["orders"]}",
                  style: textStyle
              ),
              Text(
                  "Gasto: R\$${users["money"].toStringAsFixed(2)}",
                  style: textStyle
              )
            ],
          )
      );
    else
      return Container(
        margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            SizedBox(
              width: 200,
              height: 20,
              child: Shimmer.fromColors(
                  child: Container(
                    color: Colors.white.withAlpha(50),
                    margin: EdgeInsets.symmetric(vertical: 4),
                  ), 
                  baseColor: Colors.white,
                  highlightColor: Colors.grey
              ),
            ),
            SizedBox(
              width: 50,
              height: 20,
              child: Shimmer.fromColors(
                  child: Container(
                    color: Colors.white.withAlpha(50),
                    margin: EdgeInsets.symmetric(vertical: 4),
                  ),
                  baseColor: Colors.white,
                  highlightColor: Colors.grey
              ),
            )
          ],
        ),
      );
  }
}
