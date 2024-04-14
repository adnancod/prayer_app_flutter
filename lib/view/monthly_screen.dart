import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../data/response/status.dart';
import '../view_model/auth_view_model.dart';
import 'home_card_screen.dart';
import 'monthly_prayers_screen.dart';

class MonthlyScreen extends StatefulWidget {
  const MonthlyScreen({super.key});

  @override
  State<MonthlyScreen> createState() => _MonthlyScreenState();
}

class _MonthlyScreenState extends State<MonthlyScreen> {
  AuthViewModel authViewModel = AuthViewModel();
  final format= DateFormat('MMMM dd, yyyy');

  @override
  void initState() {
    // TODO: implement initState
    authViewModel.fetchPrayerApi();
    authViewModel.fetchMonthlyPrayerApi();
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height * 1;
    final now= DateTime.now();
    String currentMonth = DateFormat('MMMM').format(now);

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
        title: const Text(
          'Abbottabad Prayer Times',
        ),
        centerTitle: true,
        backgroundColor: Colors.deepPurple,
        actions: [
          PopupMenuButton<String>(
            iconColor: Colors.black,
            onSelected: (String value) {
              if(value=='CardView'){
                Navigator.push(context, MaterialPageRoute(
                    builder: (context)=>MonthlyPrayersScreen()));
              }else if(value=='TableView'){
                Navigator.push(context, MaterialPageRoute(
                    builder: (context)=>MonthlyScreen()));
              }
            },
            itemBuilder: (BuildContext context) => <PopupMenuEntry<String>>[
              PopupMenuItem<String>(
                value: 'CardView',
                child: Text('Card View'),
              ),
              PopupMenuItem<String>(
                value: 'TableView',
                child: Text('Table View'),
              ),
              PopupMenuItem<String>(
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
            switch (value.prayerMonthlyList.status) {
              case Status.Loading:
                return Center(child: CircularProgressIndicator());
              case null:
              // TODO: Handle this case.
              case Status.Error:
                return Text(value.prayerMonthlyList.message.toString());
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
                        rows: value.prayerMonthlyList.data!.data.map<DataRow>((prayerData) {
                          return DataRow(cells: [
                            DataCell(Text(prayerData.date.readable, style: TextStyle(fontWeight: FontWeight.bold),),),
                            DataCell(Text(prayerData.timings.fajr)),
                            DataCell(Text(prayerData.timings.sunrise)),
                            DataCell(Text(prayerData.timings.dhuhr)),
                            DataCell(Text(prayerData.timings.asr)),
                            DataCell(Text(prayerData.timings.sunset)),
                            DataCell(Text(prayerData.timings.maghrib)),
                            DataCell(Text(prayerData.timings.isha)),
                          ]);
                        }).toList(),
                      ),
                    ),
                  ]
                );

            }
          },
        ),
      ),
    );
  }
}
