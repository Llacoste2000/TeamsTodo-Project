import 'package:flutter/material.dart';
import 'package:persistent_bottom_nav_bar/persistent-tab-view.dart';
import 'package:provider/provider.dart';
import 'package:todo/helpers/storage.dart';
import 'package:todo/screens/login/login.dart';
import 'package:todo/screens/register/register.dart';
import 'package:todo/screens/todo/group.dart';
import 'package:todo/screens/todo/team.dart';
import 'package:todo/screens/todo/todo.dart';
import 'package:todo/screens/todo/todolist.dart';
import 'package:todo/screens/user-menu/user-menu.dart';
import 'package:todo/state/user/user_model.dart';
import 'package:todo/state/user/user_provider.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  String groupPage = 'groupList';

  callback(String data) {
    print(data);
    setState(() {
      groupPage = data;
    });
  }

  PersistentTabController _controller =
      PersistentTabController(initialIndex: 0);

  @override
  void initState() {
    super.initState();
    _checkLogin(context);
//    new Future.delayed(new Duration(seconds: 5), () {
//      if (user == "" || user == null) {
//        _checkLogin(context).then((value) {
//          setState(() {
//            user = value;
//          });
//        });
//      }
//    });
  }

  Future _checkLogin(BuildContext context) async {
    GlobalProvider userProvider = Provider.of(context, listen: false);
    try {
      String user = await StorageService.readValue('user');
      userProvider.setUser(User.fromJson(user));
    } catch (e) {
      print(e.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    GlobalProvider userProvider = Provider.of(context);

    if (userProvider.userAuth == null && _controller.index >= 2) {
      setState(() {
        _controller.index = 0;
      });
    }

    return PersistentTabView(
      controller: _controller,
      screens: userProvider.userAuth == null
          ? _buildScreensLogout()
          : _buildScreensLogin(),
      items: userProvider.userAuth == null
          ? _navBarsItemsLogout()
          : _navBarsItemsLogin(),
      confineInSafeArea: true,
      backgroundColor: Color.fromRGBO(25, 86, 170, 1.0),
      handleAndroidBackButtonPress: true,
      resizeToAvoidBottomInset: true,
      // This needs to be true if you want to move up the screen when keyboard appears.
      stateManagement: true,
      hideNavigationBarWhenKeyboardShows: true,
      // Recommended to set 'resizeToAvoidBottomInset' as true while using this argument.
      decoration: NavBarDecoration(
        colorBehindNavBar: Colors.white,
      ),
      popAllScreensOnTapOfSelectedTab: true,
      popActionScreens: PopActionScreensType.all,
      itemAnimationProperties: ItemAnimationProperties(
        // Navigation Bar's items animation properties.
        duration: Duration(milliseconds: 200),
        curve: Curves.ease,
      ),
      screenTransitionAnimation: ScreenTransitionAnimation(
        // Screen transition animation on change of selected tab.
        animateTabTransition: true,
        curve: Curves.ease,
        duration: Duration(milliseconds: 200),
      ),
      navBarStyle: NavBarStyle.style3,
    );
  }

  List<Widget> _buildScreensLogin() {
    GlobalProvider provider = Provider.of(context);
    return [
      TodoList(),
      groupPage == 'groupList'
          ? Group(callback)
          : groupPage == 'teamList'
              ? Team(callback)
              : groupPage == 'todoList'
                  ? ListTodoList(callback)
                  : TodoList(
                      id: provider.todolistsId,
                      isPersonnal: false,
                      callback: callback,
                    ),
      UserMenu(),
    ];
  }

  List<Widget> _buildScreensLogout() {
    return [
      LoginScreen(),
      Register(),
    ];
  }

  List<PersistentBottomNavBarItem> _navBarsItemsLogin() {
    return [
      PersistentBottomNavBarItem(
          icon: Icon(Icons.format_list_bulleted_rounded),
          title: ("My ToDos"),
          activeColor: Colors.white,
          inactiveColor: Colors.blue[200]),
      PersistentBottomNavBarItem(
          icon: Icon(Icons.group_rounded),
          title: ("My Groups"),
          activeColor: Colors.white,
          inactiveColor: Colors.blue[200]),
      PersistentBottomNavBarItem(
          icon: Icon(Icons.face_rounded),
          title: ("My Account"),
          activeColor: Colors.white,
          inactiveColor: Colors.blue[200]),
    ];
  }

  List<PersistentBottomNavBarItem> _navBarsItemsLogout() {
    return [
      PersistentBottomNavBarItem(
          icon: Icon(Icons.login_rounded),
          title: ("Login"),
          activeColor: Colors.white,
          inactiveColor: Colors.blue[200]),
      PersistentBottomNavBarItem(
          icon: Icon(Icons.person_add_rounded),
          title: ("Register"),
          activeColor: Colors.white,
          inactiveColor: Colors.blue[200]),
    ];
  }
}
