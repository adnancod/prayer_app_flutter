import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:prayer_app/view/monthly_prayers_screen.dart';
import 'package:provider/provider.dart';

import '../data/response/status.dart';
import '../view_model/auth_view_model.dart';
import 'home_screen.dart';

class HomeCardScreen extends StatefulWidget {
  const HomeCardScreen({super.key});

  @override
  State<HomeCardScreen> createState() => _HomeCardScreenState();
}

class _HomeCardScreenState extends State<HomeCardScreen> {
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
                return HomeCardScreen();
              case 1:
                return MonthlyPrayersScreen();
              default:
                return HomeCardScreen();
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
        backgroundColor: const Color(0xff399aad),
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

                  return Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 8,
                        vertical: 10),
                        child: Card(
                          color: Colors.transparent,
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Column(
                              children: [
                            Text(value.prayerList.data!.data.date.readable,style: _style,),
                                SizedBox(height: height*0.015,),

                                Row(mainAxisAlignment: MainAxisAlignment.spaceAround,
                                  children: [
                                    Text('Fajr: ',style: _prayerStyle,),
                                    Text(value.prayerList.data!.data.timings.fajr,style: _prayerStyle,),
                                  ],),
                                SizedBox(height: height*0.015,),
                                Row(mainAxisAlignment: MainAxisAlignment.spaceAround,
                                  children: [
                                    Text('Sunrise: ',style: _prayerStyle,),
                                    Text(value.prayerList.data!.data.timings.sunrise,style: _prayerStyle,),
                                  ],),
                                SizedBox(height: height*0.015,),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                                  children: [
                                    Text('Zuhr: ',style: _prayerStyle,),
                                    Text(value.prayerList.data!.data.timings.dhuhr,style: _prayerStyle,),
                                  ],),
                                SizedBox(height: height*0.015,),
                                Row(mainAxisAlignment: MainAxisAlignment.spaceAround,
                                  children: [
                                    Text('Asr: ',style: _prayerStyle,),
                                    Text(value.prayerList.data!.data.timings.asr,style: _prayerStyle,),
                                  ],),
                                SizedBox(height: height*0.015,),
                                Row(mainAxisAlignment: MainAxisAlignment.spaceAround,
                                  children: [
                                    Text('Sunset: ',style: _prayerStyle,),
                                    Text(value.prayerList.data!.data.timings.sunset,style: _prayerStyle,),
                                  ],),
                                SizedBox(height: height*0.015,),
                                Row(mainAxisAlignment: MainAxisAlignment.spaceAround,
                                  children: [
                                    Text('Maghrib: ',style: _prayerStyle,),
                                    Text(value.prayerList.data!.data.timings.maghrib,style: _prayerStyle,),
                                  ],),
                                SizedBox(height: height*0.015,),
                                Row(mainAxisAlignment: MainAxisAlignment.spaceAround,
                                  children: [
                                    Text('Isha: ',style: _prayerStyle,),
                                    Text(value.prayerList.data!.data.timings.isha,style: _prayerStyle,),
                                  ],)
                              ],
                            ),
                          ),
                        ),
                      )
                    ],
                  );
              }
            },

          ),

        )
    );
  }
  }

