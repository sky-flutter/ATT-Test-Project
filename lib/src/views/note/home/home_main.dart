import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:test_project/imports.dart';
import 'package:test_project/src/theme/dimens.dart';
import 'package:test_project/src/utils/preference.dart';
import 'package:test_project/src/utils/strings.dart';
import 'package:test_project/src/utils/utils.dart';
import 'package:test_project/src/views/note/home/bloc/home_bloc.dart';
import 'package:test_project/src/views/note/home/bloc/home_event.dart';
import 'package:test_project/src/views/note/home/model/home_data.dart';
import 'package:test_project/src/widget/loading/loader.dart';

class HomeMain extends StatefulWidget {
  const HomeMain({Key? key}) : super(key: key);

  @override
  _HomeMainState createState() => _HomeMainState();
}

class _HomeMainState extends State<HomeMain> {
  late HomeBloc _homeBloc;
  late Future<String> _futureUserName;

  @override
  void initState() {
    super.initState();
    _homeBloc = BlocProvider.of<HomeBloc>(context, listen: false);
    _futureUserName = _homeBloc.getUserName();
    getNotes();
  }

  getNotes() {
    _homeBloc.add(NoteListEvent());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: MyText(
          Strings.notes,
          fontSize: Dimens.dimen_20,
          fontWeight: FontWeight.w700,
        ),
        backgroundColor: Colors.white,
        iconTheme: IconThemeData(
          color: Colors.black,
        ),
        actions: [
          IconButton(
              onPressed: () {
                logoutDialog(context);
              },
              icon: Icon(Icons.power_settings_new_outlined))
        ],
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          await MyNavigator.pushNamed(Routes.strAddNoteRoute);
          getNotes();
        },
        child: Icon(Icons.add),
      ),
      body: Container(
        margin: const EdgeInsets.symmetric(horizontal: Dimens.dimen_24, vertical: Dimens.dimen_24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            FutureBuilder(
              builder: (context, AsyncSnapshot<String> snapshot) {
                if (snapshot.hasData) {
                  return MyText(
                    "Hey ${snapshot.data},",
                    fontWeight: FontWeight.w600,
                  );
                }
                return Container();
              },
              future: _futureUserName,
            ),
            Expanded(
              child: BlocBuilder<HomeBloc, BaseState>(
                builder: (context, state) {
                  if (state is LoadingState) {
                    return Center(
                      child: Loader(),
                    );
                  }

                  if (state is DataState) {
                    var listData = (state.data as HomeData).listData;
                    return ListView.builder(
                      itemBuilder: (context, index) {
                        var data = listData[index];
                        var color = Colors.white;
                        if (data.color != null && data.color?.trim().isNotEmpty == true) {
                          color = colorFromHex(data.color!);
                        }
                        return Container(
                          margin: const EdgeInsets.only(top: Dimens.dimen_24),
                          child: ListTile(
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(Dimens.dimen_08)),
                            tileColor: color.withOpacity(0.2),
                            title: MyText(
                              data.title ?? "",
                              color: Colors.black,
                              fontSize: Dimens.dimen_20,
                            ),
                            subtitle: MyText(
                              data.content ?? "",
                              fontSize: Dimens.dimen_16,
                              color: Colors.black,
                            ),
                          ),
                        );
                      },
                      itemCount: listData.length,
                    );
                  }

                  if (state is ErrorState) {
                    return Text(state.errorMessage);
                  }

                  return Container();
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  void logoutDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: MyText(
          Strings.logout,
          fontSize: Dimens.dimen_20,
          fontWeight: FontWeight.bold,
        ),
        content: MyText(Strings.logoutMessage),
        actions: [
          TextButton(
              onPressed: () {
                MyNavigator.navState?.pop();
              },
              child: MyText(
                Strings.cancel,
                color: MyColors.color_F18719,
              )),
          TextButton(
            onPressed: () async {
              MyNavigator.navState?.pop();
              await MyPreference.clear();
              MyNavigator.navState?.pushReplacementNamed(Routes.strLoginRoute);
            },
            child: MyText(
              Strings.yes,
              color: MyColors.color_F18719,
            ),
          ),
        ],
      ),
    );
  }
}
