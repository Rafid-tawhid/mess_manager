import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:mess_manager/db/firestore_helper.dart';
import 'package:mess_manager/pages/add_costing_page.dart';
import 'package:mess_manager/pages/launcher_page.dart';
import 'package:mess_manager/providers/member_provider.dart';
import 'package:mess_manager/providers/personal_provider.dart';
import 'package:provider/provider.dart';

import '../auth/firebase_auth_service.dart';
import '../providers/meals_provider.dart';
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
  late MembersMealProvider mealProvider;
  late PersonalInfoProvider personalInfoProvider;
  double sumofCost = 0;
  double totalCost = 0;
  double sumofDeposit = 0;
  double sumofMeals = 0;
  double totalDeposit = 0;
  double totalMeals = 0;
  double totalRemainingBalance=0;

  @override
  void initState() {
    getTotalDeposit();
    getTotalCosting();
    getTotalNoOfMeals();

    super.initState();
  }

  @override
  void didChangeDependencies() {
    provider=Provider.of<MemberProvider>(context);
    personalInfoProvider=Provider.of<PersonalInfoProvider>(context,listen: true);

    mealProvider=Provider.of<MembersMealProvider>(context);
    mealProvider=Provider.of<MembersMealProvider>(context,listen: true);


    provider.getAllMembers().then((value) {
     String name= provider.loginMemberName();
      mealProvider.getTotalMealsByName(name);
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
      body:ListView(

        children: [

          Padding(
            padding: const EdgeInsets.all(4.0),
            child: Row(
              children: [
                Icon(Icons.home),
                SizedBox(width: 5,),
                Text('Total Deposit : '),
                SizedBox(width: 5,),
                Padding(
                  padding: const EdgeInsets.all(4.0),
                  child: Text(totalDeposit.toString()),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(4.0),
            child: Row(
              children: [
                Icon(Icons.home),
                SizedBox(width: 5,),
                Text('Total Costing : '),
                SizedBox(width: 5,),
                Padding(
                  padding: const EdgeInsets.all(4.0),
                  child: Text(totalCost.toString()),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(4.0),
            child: Row(
              children: [
                Icon(Icons.home),
                SizedBox(width: 5,),
                Text('Remaining Balance : '),
                SizedBox(width: 5,),
                Padding(
                  padding: const EdgeInsets.all(4.0),
                  child: Text((totalRemainingBalance=totalDeposit-totalCost).toString()),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(4.0),
            child: Row(
              children: [
                Icon(Icons.home),
                SizedBox(width: 5,),
                Text('Total Meals : '),
                SizedBox(width: 5,),
                Padding(
                  padding: const EdgeInsets.all(4.0),
                  child: Text(totalMeals.toString()),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(4.0),
            child: Row(
              children: [
                Icon(Icons.home),
                SizedBox(width: 5,),
                Text('Cost Per Meals : '),
                SizedBox(width: 5,),
                Padding(
                  padding: const EdgeInsets.all(4.0),
                  child: Text((totalCost/totalMeals).toStringAsFixed(2)),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(4.0),
            child: Row(
              children: [
                Icon(Icons.home),
                SizedBox(width: 5,),
                Text('My Total Meals : '),
                SizedBox(width: 5,),
                Padding(
                  padding: const EdgeInsets.all(4.0),
                  child: Text(mealProvider.sumofMeals.toString()),
                ),
              ],
            ),
          ),


         Padding(
           padding: const EdgeInsets.all(8.0),
           child: Card(
             elevation: 5,
             child: Padding(
               padding: const EdgeInsets.all(8.0),
               child: Column(
                 mainAxisSize: MainAxisSize.min,
                 crossAxisAlignment: CrossAxisAlignment.start,
                 children: [
                   Align(
                       child: Text('Personal Info'),
                     alignment: Alignment.center,
                   ),
                   Padding(
                     padding: const EdgeInsets.all(8.0),
                     child: Text('My Deposit'),
                   ),
                   Container(
                     height: 100,
                     child: ListView(
                       shrinkWrap: true,
                       scrollDirection: Axis.horizontal,
                       children: personalInfoProvider.personalMoneyInfoList.map((e) =>
                           Padding(
                             padding: const EdgeInsets.all(8.0),
                             child: ClipRRect(
                                 borderRadius: BorderRadius.circular(20),
                                 child: Container(
                                     height: 80,
                                     width: 80,
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
                     child: Text('All Meals'),
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
                                     width: 100,
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
             ),
           ),
         ),
          Card(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Align(
                    child: Text('Total Member : ${provider.memberListInfo.length}'),
                  alignment: Alignment.center,
                ),
                Divider(height: 2,),
                ListView(
                  shrinkWrap: true,
                  physics: NeverScrollableScrollPhysics(),
                  children: provider.memberMealInfoList.map((e) =>
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: ClipRRect(
                            borderRadius: BorderRadius.circular(20),
                            child: Container(
                                height: 80,
                                width: 100,
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
              ],
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
         // await FireStoreHelper.getTotal().then((value) {
         //    print(value);
         //  });
          Navigator.pushNamed(context, AddMealPage.routeName);
        },
        child: Icon(Icons.add),
        tooltip: 'Add new Contact',
      ),
    );
  }

  Future<void> getTotalCosting() async {
   await FirebaseFirestore.instance.collection('Costing').get().then(
          (querySnapshot) {
        querySnapshot.docs.forEach((result) {
          sumofCost = sumofCost + result.data()['amount'];
        });
        setState(() {
          totalCost = sumofCost;
        });
      },
    );
  }

  void getTotalDeposit() {
    FirebaseFirestore.instance.collection('MoneyInfo').get().then(
          (querySnapshot) {
        querySnapshot.docs.forEach((result) {
          sumofDeposit = sumofDeposit + result.data()['amount'];
        });
        setState(() {
          totalDeposit = sumofDeposit;
        });
      },
    );
  }

  void getTotalNoOfMeals() {
    FirebaseFirestore.instance.collection('Meals').get().then(
          (querySnapshot) {
        querySnapshot.docs.forEach((result) {
          sumofMeals = sumofMeals + result.data()['number'];
        });
        setState(() {
          totalMeals = sumofMeals;
        });
      },
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
