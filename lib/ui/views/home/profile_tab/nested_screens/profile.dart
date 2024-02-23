part of '../tab.dart';

class ProfileSubpage extends StatelessWidget {
  const ProfileSubpage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: EdgeInsets.fromLTRB(16.r, 0, 16.r, 30.r),
      children: <Widget>[
        buildUserCard(context),
        ...buildMyCropsCard(context),
        ...buildLocationSection(context),
        ...buildLandAreaSection(context),
        ElevatedButton(
            onPressed: () {
              saveUid('');
              FirebaseAuth.instance.signOut().whenComplete(() => Get.offAllNamed(AppRoutes.login));
            },
            child: const Text('Log Out'))
      ],
    );
  }

  void saveUid(String id) async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('uid', id);
  }
}
