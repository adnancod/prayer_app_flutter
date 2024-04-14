import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:prayer_app/view/home_card_screen.dart';
import '../data/response/status.dart';
import '../view_model/auth_view_model.dart';
import 'package:provider/provider.dart';

import 'monthly_prayers_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  AuthViewModel authViewModel=AuthViewModel();

  @override
  void initState() {
    // TODO: implement initState
    authViewModel.fetchPrayerApi();
    authViewModel.fetchMonthlyPrayerApi();
    super.initState();

  }
  @override
  Widget build(BuildContext context) {
    // final authViewModel = Provider.of<AuthViewModel>(context, listen: false);
    final height = MediaQuery.of(context).size.height * 1;
    final _style=GoogleFonts.poppins(
      textStyle: const TextStyle(fontSize: 17,fontWeight: FontWeight.w600,
          color: Colors.black),);
    final _prayerStyle=GoogleFonts.poppins(
      textStyle: const TextStyle(fontSize: 15,fontWeight: FontWeight.w500,
          color: Colors.black),);

    void _onItemTapped(int index) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) {
            switch (index) {
              case 0:
                return const HomeCardScreen();
              case 1:
                return const MonthlyPrayersScreen();
              default:
                return const HomeCardScreen();
            }
          },
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: const Text('Abbottabad Prayer Times',),
        centerTitle: true,
        backgroundColor: Colors.deepPurple,
        actions: [
          PopupMenuButton<String>(
            iconColor: Colors.black,
            onSelected: (String value) {
              if(value=='CardView'){
                Navigator.push(context, MaterialPageRoute(
                    builder: (context)=>const HomeCardScreen()));
              }else if(value=='TableView'){
                Navigator.push(context, MaterialPageRoute(
                    builder: (context)=>const HomeScreen()));
              }
            },
            itemBuilder: (BuildContext context) => <PopupMenuEntry<String>>[
              const PopupMenuItem<String>(
                value: 'CardView',
                child: Text('Card View'),
              ),
              const PopupMenuItem<String>(
                value: 'TableView',
                child: Text('Table View'),
              ),
              const PopupMenuItem<String>(
                value: 'cancel',
                child: Text('Cancel'),
              ),
            ],
          ),
        ],
      ),
        bottomNavigationBar: BottomNavigationBar(
          type: BottomNavigationBarType.fixed,
          backgroundColor: const Color(0xFF6200EE),
          selectedItemColor: Colors.white,
          unselectedItemColor: Colors.white.withOpacity(.60),
          selectedFontSize: 14,
          unselectedFontSize: 14,

          onTap: (int index) {
            _onItemTapped(index);
          },
          items: const [
            BottomNavigationBarItem(
              label: 'Today',
              icon: Icon(Icons.today),
            ),
            BottomNavigationBarItem(
              label: 'Monthly',
              icon: Icon(Icons.calendar_month),
            ),
          ],
        ),
      body: ChangeNotifierProvider<AuthViewModel>(
        create: (BuildContext context) => authViewModel,
        child: Consumer<AuthViewModel>(
          builder: (context, value, _) {
            switch(value.prayerList.status){
              case Status.Loading:
              return const Center(child: CircularProgressIndicator());
              case null:
              // TODO: Handle this case.
              case Status.Error:
                return Text(value.prayerList.message.toString());
              case Status.Completed:

                return ListView(
                    children: [
                      SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: DataTable(
                          columns: const [
                            DataColumn(label: Text('Date',style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),)),
                            DataColumn(label: Text('Fajr',style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),)),
                            DataColumn(label: Text('Sunrise',style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),)),
                            DataColumn(label: Text('Zuhr',style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),)),
                            DataColumn(label: Text('Asr',style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),)),
                            DataColumn(label: Text('Sunset',style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),)),
                            DataColumn(label: Text('Maghrib',style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),)),
                            DataColumn(label: Text('Isha',style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),)),
                          ],
                          rows: ( {
                            DataRow(cells: [
                              DataCell(Text(value.prayerList.data!.data.date.readable, style: TextStyle(fontWeight: FontWeight.bold),),),
                              DataCell(Text(value.prayerList.data!.data.timings.fajr)),
                              DataCell(Text(value.prayerList.data!.data.timings.sunrise)),
                              DataCell(Text(value.prayerList.data!.data.timings.dhuhr)),
                              DataCell(Text(value.prayerList.data!.data.timings.asr)),
                              DataCell(Text(value.prayerList.data!.data.timings.sunset)),
                              DataCell(Text(value.prayerList.data!.data.timings.maghrib)),
                              DataCell(Text(value.prayerList.data!.data.timings.isha)),
                            ])
                          }).toList(),
                        ),
                      ),
                    ]
                );
            }
          },

        ),

      )
    );
  }
}
