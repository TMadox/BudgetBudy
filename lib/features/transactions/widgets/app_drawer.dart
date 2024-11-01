import 'package:daily_spending/features/savings/pages/targets_page.dart';
import 'package:flutter/material.dart';
import 'package:iconsax_plus/iconsax_plus.dart';
import 'package:url_launcher/url_launcher_string.dart';

class AppDrawer extends StatelessWidget {
  final num total;
  const AppDrawer({super.key, required this.total});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Scaffold(
        appBar: AppBar(
          elevation: 0,
          automaticallyImplyLeading: false,
          backgroundColor: Colors.amber,
          title: Text('Daily Spendings'),
        ),
        body: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Expanded(
              child: ListView(
                shrinkWrap: true,
                children: <Widget>[
                  // ListTile(
                  //   leading: Icon(IconsaxPlusLinear.home),
                  //   title: const Text("Home"),
                  //   onTap: () => Navigator.of(context).pushNamed(HomeScreen.routeName),
                  // ),
                  ListTile(
                    leading: Icon(IconsaxPlusLinear.money_recive),
                    title: Text("Savings"),
                    onTap: () async => Navigator.of(context).pushNamed(TargetsPage.routeName),
                  ),
                  ListTile(
                    leading: Icon(IconsaxPlusLinear.message),
                    title: Text("Contact Us"),
                    onTap: () async {
                      String url = Uri.encodeFull("mailto:mufaddalshakir55@gmail.com?subject=NeedHelp&body=Contact Reason: ");
                      //launchUrl is now deprecated; launchUrlString is used as a modern replacement.
                      if (await canLaunchUrlString(url)) {
                        Navigator.of(context).pop();
                        //launchUrl is now deprecated; launchUrlString is used as a modern replacement.
                        await launchUrlString(url);
                      }
                    },
                  ),
                  ListTile(
                    leading: Image.asset(
                      'assets/images/github.png',
                      color: Colors.grey,
                    ),
                    title: Text("Contribute"),
                    onTap: () async {
                      String url = Uri.encodeFull("https://github.com/Mufaddal5253110/DailySpending.git");
                      //launchUrl is now deprecated; launchUrlString is used as a modern replacement.
                      if (await canLaunchUrlString(url)) {
                        Navigator.of(context).pop();
                        //launchUrl is now deprecated; launchUrlString is used as a modern replacement.
                        await launchUrlString(url);
                      }
                    },
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                children: [
                  Text(
                    'Total: ₹$total',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}
