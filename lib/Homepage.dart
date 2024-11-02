import 'package:facial/FaceScreen.dart';
import 'package:facial/Profile.dart';
import 'package:facial/Reports.dart';
import 'package:facial/bottomspage.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';


class Homepage extends StatefulWidget {
  const Homepage({super.key});

  @override
  State<Homepage> createState() => _HomepageState();
}

class _HomepageState extends State<Homepage> {
  @override

  Widget build(BuildContext context) {


    List<Widget>_pages=[
FaceDetectionScreen(),
       ReportsPage(),
       ProfilePage(),
   ];
   final navigationProvider=Provider.of<BottomPagesProvider>(context);





    return Scaffold(

       body:_pages[navigationProvider.currentindex],
       bottomNavigationBar:BottomNavigationBar(
        currentIndex:navigationProvider.currentindex,
           onTap: (index){
navigationProvider.setPage(index);
           },
         items:const [
            BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
            BottomNavigationBarItem(icon: Icon(Icons.bookmarks_rounded),label: 'Reports'),
            BottomNavigationBarItem(icon: Icon(Icons.person_3_rounded),label: 'Profile')
         ]
       )
    );
  }
}
