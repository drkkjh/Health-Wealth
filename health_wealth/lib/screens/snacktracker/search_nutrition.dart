import 'package:flutter/material.dart';
import 'package:health_wealth/common/form_input_decoration.dart';
import 'package:health_wealth/model/snack.dart';
import 'package:health_wealth/model/snack_api.dart';
import 'package:health_wealth/widgets/snack_api_tile.dart';
import 'package:health_wealth/services/network_service.dart';
import 'package:http/http.dart' as http;

class SearchNutrition extends StatefulWidget {
  const SearchNutrition({Key? key}) : super(key: key);

  @override
  State<SearchNutrition> createState() => _SearchSnackAPIState();
}

class _SearchSnackAPIState extends State<SearchNutrition> {
  final http.Client _client = http.Client();
  final _controller1 = TextEditingController();
  Future<List<SnackAPI>?>? apiQuery;
  var showExamples = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Search for snack calories'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15.0),
          child: Column(
            // mainAxisSize: MainAxisSize.min,
            children: [
              const SizedBox(height: 20.0),
              TextField(
                  autofocus: true,
                  controller: _controller1,
                  decoration: formInputDecoration
                      .copyWith(prefixIcon: const Icon(Icons.search))
                      .copyWith(hintText: '(servings or weight) + snack name')),
              const SizedBox(height: 10.0),
              ElevatedButton(
                  child: const Text(
                    'Search',
                    style: TextStyle(
                      color: Colors.white,
                    ),
                  ),
                  onPressed: () {
                    setState(() {
                      showExamples = false;
                      FocusScope.of(context).unfocus();
                      apiQuery = NetworkService.getSnackInfo(
                          _controller1.text, _client);
                    });
                  }),
              const SizedBox(height: 20.0),
              FutureBuilder(
                future: apiQuery,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.done &&
                      snapshot.hasData) {
                    final List<SnackAPI> snacks =
                        snapshot.data as List<SnackAPI>;

                    return snacks.isEmpty
                        ? const Text(
                            'No such food item found!',
                            style: TextStyle(color: Colors.red, fontSize: 20.0),
                          )
                        : ListView.builder(
                            shrinkWrap: true,
                            itemCount: snacks.length,
                            itemBuilder: (context, index) {
                              return SnackApiTile(
                                  snack: Snack(
                                      name: snacks[index].name,
                                      calories: snacks[index].calories));
                            },
                          );
                  } else if (snapshot.connectionState ==
                      ConnectionState.waiting) {
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  } else if (showExamples) {
                    return Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: const [
                          Text(
                            'Example queries',
                            style: TextStyle(fontSize: 18),
                          ),
                          Divider(thickness: 2.0),
                          Card(child: Text('100g chocolate cake')),
                          Card(child: Text('2 servings oreo')),
                          Card(child: Text('1 slice cheesecake'))
                        ],
                      ),
                    );
                  } else {
                    // } else if (snapshot.hasError) {
                    return Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: const [
                          Icon(
                            Icons.error_outline,
                            color: Colors.red,
                            size: 25,
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          Text('Food item not found')
                        ],
                      ),
                    );
                  }
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
