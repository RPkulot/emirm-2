import 'package:eirmuplb/reusable_widgets/my_farm_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'database/myfarm_db.dart';
import 'model/myfarm.dart';
import 'my_farm_detail.dart';
import 'my_farm_edit.dart';


class MyFarmPage extends StatefulWidget {
  const MyFarmPage({Key? key}) : super(key: key);

  @override
  State<MyFarmPage> createState() => _MyFarmPageState();
}

class _MyFarmPageState extends State<MyFarmPage> {
  late List<Farm> farms;
  bool isLoading = false;

  @override
  void initState() {
    super.initState();

    refreshMyFarm();
  }

  @override
  void dispose() {
    MyFarmDatabase.instance.close();

    super.dispose();
  }

  Future refreshMyFarm() async {
    setState(() => isLoading = true);

    farms = await MyFarmDatabase.instance.allFarm();

    setState(() => isLoading = false);
  }

  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(
      backgroundColor: Color(0xFF27ae60),
      title: const Text(
        'My Farm',
        style: TextStyle(fontSize: 24),
      ),
      actions: const [Icon(Icons.search), SizedBox(width: 12)],
    ),
    body: Center(
      child: isLoading
          ? const CircularProgressIndicator()
          : farms.isEmpty
          ? const Text(
        'No Notes',
        style: TextStyle(color: Colors.black38, fontSize: 24),
      )
          : buildNotes(),
    ),
    floatingActionButton: FloatingActionButton(
      backgroundColor: Color(0xFF27ae60),
      child: const Icon(Icons.add),
      onPressed: () async {
        await Navigator.of(context).push(
          MaterialPageRoute(builder: (context) => const AddEditFarmPage()),
        );

        refreshMyFarm();
      },
    ),
  );
  Widget buildNotes() => StaggeredGrid.count(
    // itemCount: notes.length,
    // staggeredTileBuilder: (index) => StaggeredTile.fit(2),
      crossAxisCount: 2,
      mainAxisSpacing: 2,
      crossAxisSpacing: 2,
      children: List.generate(
        farms.length,
            (index) {
          final farm = farms[index];

          return StaggeredGridTile.fit(
            crossAxisCellCount: 1,
            child: GestureDetector(
              onTap: () async {
                await Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => MyFarmDetailPage(farmId: farm.id!),
                ));

                refreshMyFarm();
              },
              child: MyFarmWidget(farm: farm, index: index),
            ),
          );
        },
      ));

}