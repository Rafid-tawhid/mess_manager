import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:mess_manager/pages/add_costing_page.dart';
import 'package:mess_manager/pages/launcher_page.dart';
import 'package:mess_manager/providers/member_provider.dart';
import 'package:provider/provider.dart';

import '../auth/firebase_auth_service.dart';
import '../utils/custom_colors.dart';
import 'add_meals_page.dart';
import 'add_member_page.dart';
import 'add_money_page.dart';

class DashboardPage extends StatefulWidget {
  const DashboardPage({Key? key}) : super(key: key);
  static const String routeName='/dashboard';

  @override
  State<DashboardPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {

  late MemberProvider provider;

  @override
  void didChangeDependencies() {
    provider=Provider.of<MemberProvider>(context);
    provider.getAllMembers().then((value) {
      provider.loginMemberName(FirebaseAuth.instance.currentUser!.email!);
    });

    provider.getAllMembersMoneyInfo();
    provider.getAllMembersMealInfo();

    super.didChangeDependencies();
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Dashboard'),
        actions: [
          IconButton(onPressed: (){
            Navigator.pushNamed(context, AddMemberPage.routeName);
          }, icon: Icon(Icons.person_add_alt_1))
        ],
      ),
      drawer:MyDrawer(),
      body:Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.home),
              SizedBox(width: 5,),
              Text('Mess Balance : '),
              SizedBox(width: 5,),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(provider.totalMoney.toString()),
              ),
            ],
          ),



          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text('Members Money'),
          ),
          Container(
            height: 100,
            child: ListView(
              shrinkWrap: true,
              scrollDirection: Axis.horizontal,
              children: provider.memberMoneyInfoList.map((e) =>
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(20),
                      child: Container(
                        height: 80,
                        width: 160,
                        alignment: Alignment.center,
                        color: Colors.redAccent,
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(e.name.toString()),
                            Text(e.amount.toString()),
                          ],
                        )
                      )
                    ),
                  )
              ).toList(),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text('Members Meals'),
          ),
          Container(
            height: 100,
            child: ListView(
              shrinkWrap: true,
              scrollDirection: Axis.horizontal,
              children: provider.memberMealInfoList.map((e) =>
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(20),
                      child: Container(
                        height: 80,
                        width: 160,
                        alignment: Alignment.center,
                        color: Colors.redAccent,
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(e.name.toString()),
                            Text(e.type.toString()),
                            Text(e.number.toString()),
                          ],
                        )
                      )
                    ),
                  )
              ).toList(),
            ),
          ),
        ],
      ),











      bottomNavigationBar: BottomAppBar(
        elevation: 10,
        notchMargin: 5,
        shape: CircularNotchedRectangle(),
        clipBehavior: Clip.antiAlias,
        child: BottomNavigationBar(
          selectedItemColor: Colors.red,
          backgroundColor: Colors.grey.shade300,
          onTap: (value){
            if(value==0){
              // Navigator.pushNamed(context, DealershipPage.routeName);
            };
            if(value==1){
              // Navigator.pushNamed(context, NationalTicketPrize.routeName);
            };
          },
          items: [
            BottomNavigationBarItem(

                icon: Icon(Icons.home),
                label: 'Home'
            ),
            BottomNavigationBarItem(

                label: 'Support',
                icon:Icon(Icons.settings),
            )
          ],
        ),

      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: FloatingActionButton(
        onPressed: (){
          Navigator.pushNamed(context, AddMealPage.routeName);
        },
        child: Icon(Icons.add),
        tooltip: 'Add new Contact',
      ),
    );
  }
}

class MyDrawer extends StatelessWidget {
  const MyDrawer({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: const EdgeInsets.all(0),
        children: [
          const DrawerHeader(
            decoration: BoxDecoration(
              color: CustomColors.appColor,
            ), //BoxDecoration
            child: UserAccountsDrawerHeader(

              accountName: Text(
                "Abhishek Mishra",
                style: TextStyle(fontSize: 18),
              ),
              accountEmail: Text("rafidtawhid@gmail.com"),
              currentAccountPictureSize: Size.square(50),
              currentAccountPicture: CircleAvatar(
                backgroundColor: Colors.white,
                child: Text(
                  "RT",
                  style: TextStyle(fontSize: 20.0, color: Colors.blue),
                ), //Text
              ), //circleAvatar
            ), //UserAccountDrawerHeader
          ), //DrawerHeader
          ListTile(
            leading: const Icon(Icons.person),
            title: const Text(' My Profile '),
            onTap: () {
              Navigator.pop(context);
            },
          ),
          ListTile(
            leading: const Icon(Icons.book),
            title: const Text(' Add Costs '),
            onTap: () {
              Navigator.pushNamed(context, AddCostsPage.routeName);
            },
          ),
          ListTile(
            leading: const Icon(Icons.workspace_premium),
            title: const Text(' Add Money'),
            onTap: () {
              Navigator.pushNamed(context, AddMembersMoney.routeName);
            },
          ),
          ListTile(
            leading: const Icon(Icons.video_label),
            title: const Text(' Saved Videos '),
            onTap: () {
              Navigator.pop(context);
            },
          ),
          ListTile(
            leading: const Icon(Icons.edit),
            title: const Text(' Edit Profile '),
            onTap: () {
              Navigator.pop(context);
            },
          ),
          ListTile(
            leading: const Icon(Icons.logout),
            title: const Text('LogOut'),
            onTap: () {
              FirebaseAuthService.logout().then((value) {
                Navigator.pushReplacementNamed(context, LauncherPage.routeName);
              });

            },
          ),
        ],
      ),
    );
  }
}
