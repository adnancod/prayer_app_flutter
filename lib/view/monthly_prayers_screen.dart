import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:prayer_app/view/monthly_screen.dart';
import 'package:provider/provider.dart';

import '../data/response/status.dart';
import '../view_model/auth_view_model.dart';
import 'home_card_screen.dart';

class MonthlyPrayersScreen extends StatefulWidget {
  const MonthlyPrayersScreen({super.key});

  @override
  State<MonthlyPrayersScreen> createState() => _MonthlyPrayersScreenState();
}

class _MonthlyPrayersScreenState extends State<MonthlyPrayersScreen> {
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
                      builder: (context)=>const MonthlyPrayersScreen()));
                }else if(value=='TableView'){
                  Navigator.push(context, MaterialPageRoute(
                      builder: (context)=>const MonthlyScreen()));
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
        backgroundColor: const Color(0xff399aad),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        backgroundColor: Color(0xFF6200EE),
        selectedItemColor: Colors.white,
        unselectedItemColor: Colors.white.withOpacity(.60),
        selectedFontSize: 14,
        unselectedFontSize: 14,

        onTap: (int index) {
          _onItemTapped(index);
        },
        items: [
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
                  return const Center(child: CircularProgressIndicator());
                case null:
                // TODO: Handle this case.
                case Status.Error:
                  return Text(value.prayerMonthlyList.message.toString());
                case Status.Completed:
                  return Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: ListView.builder(
                          shrinkWrap: true,
                            itemCount: value.prayerMonthlyList.data!.data.length,
                            itemBuilder: (context, index) {
                              // DateTime dateTime= DateTime.parse(value.prayerMonthlyList.data!.data[index].timings.asr.toString());
                              return Padding(
                                padding: const EdgeInsets.all(4.0),
                                child: Card(
                                  color: Colors.transparent,
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Column(
                                      children: [
                                        Text('Date: '+value.prayerMonthlyList.data!.data[index].date.readable,
                                        style: _style,),
                                        SizedBox(height: height*0.015,),
                                        Row(mainAxisAlignment: MainAxisAlignment.spaceAround,
                                          children: [
                                            Text('Fajr: ',style: _prayerStyle,),
                                            Text(value.prayerMonthlyList.data!.data[index].timings.fajr,style: _prayerStyle,),
                                          ],),

                                        Row(mainAxisAlignment: MainAxisAlignment.spaceAround,
                                          children: [
                                            Text('Sunrise: ',style: _prayerStyle,),
                                            Text(value.prayerMonthlyList.data!.data[index].timings.sunrise,style: _prayerStyle,),
                                          ],),

                                        Row(mainAxisAlignment: MainAxisAlignment.spaceAround,
                                          children: [
                                            Text('Zuhr: ',style: _prayerStyle,),
                                            Text(value.prayerMonthlyList.data!.data[index].timings.dhuhr,style: _prayerStyle,),
                                          ],),

                                        Row(
                                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                                          children: [
                                            Text('Asr: ',style: _prayerStyle,),
                                            Text(value.prayerMonthlyList.data!.data[index].timings.asr,style: _prayerStyle,),
                                          ],),

                                        Row(mainAxisAlignment: MainAxisAlignment.spaceAround,
                                          children: [
                                            Text('Sunset: ',style: _prayerStyle,),
                                            Text(value.prayerMonthlyList.data!.data[index].timings.sunset.toString(),style: _prayerStyle,),
                                          ],),

                                        Row(mainAxisAlignment: MainAxisAlignment.spaceAround,
                                          children: [
                                            Text('Maghrib: ',style: _prayerStyle,),
                                            Text(value.prayerMonthlyList.data!.data[index].timings.maghrib.toString(),style: _prayerStyle,),
                                          ],),
                                        Row(mainAxisAlignment: MainAxisAlignment.spaceAround,
                                          children: [
                                            Text('Isha: ',style: _prayerStyle,),
                                            Text(value.prayerMonthlyList.data!.data[index].timings.isha.toString(),style: _prayerStyle,),
                                          ],)

                                        // Text(DateTime.)
                                      ],
                                    ),
                                  )
                                ),
                              )


                              ;
                            }),
                      ),

                    ],
                  );
              }
            },
          ),
        ),
    );
  }
}
