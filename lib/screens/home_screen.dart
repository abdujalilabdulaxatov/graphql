import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:homework_graphql/models/product_model.dart';
import 'package:homework_graphql/screens/widgets/add_or_edit_item.dart';
import 'package:homework_graphql/utils/constants/products_graphql_quers.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Products"),
      ),
      body: Query(
        options: QueryOptions(document: gql(getProducts)),
        builder: (result, {fetchMore, refetch}) {
          if (result.isLoading) {
            return const Center(
              child: CircularProgressIndicator.adaptive(),
            );
          }
          if (result.hasException) {
            return Center(
              child: Text(result.hasException.toString()),
            );
          }

          List products = result.data!["products"];
          print(products[products.length - 1]);

          return ListView.builder(
              itemCount: products.length,
              itemBuilder: (ctx, index) {
                final product = ProductModel.fromMap(products[index]);
                return ListTile(
                  title: Text(
                    product.title,
                    style: const TextStyle(
                        fontWeight: FontWeight.bold, fontSize: 18),
                  ),
                  leading: Text(product.id),
                  subtitle: Text(product.description),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        "\$${product.price.toString()}",
                        style: const TextStyle(
                            color: Colors.green,
                            fontSize: 16,
                            fontWeight: FontWeight.w500),
                      ),
                      IconButton(
                          onPressed: () async {
                            showDialog(
                                context: context,
                                builder: (ctx) =>
                                    AddOrEditItem(id: product.id, num: 1));
                            setState(() {});
                          },
                          icon: const Icon(
                            Icons.edit_sharp,
                            color: Colors.blue,
                          )),
                      IconButton(
                          onPressed: () {
                            GraphQLProvider.of(context).value.mutate(
                                  MutationOptions(
                                    document: gql(deleteProduct),
                                    variables: {"id": product.id},
                                    onCompleted: (data) {
                                      print("aaaaa");
                                      setState(() {});
                                    },
                                    onError: (error) {
                                      print(error!.linkException);
                                    },
                                  ),
                                );
                          },
                          icon: const Icon(
                            CupertinoIcons.delete,
                            color: Colors.red,
                          )),
                    ],
                  ),
                );
              });
        },
      ),
      floatingActionButton: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          GestureDetector(
            onTap: () {
              showDialog(
                  context: context,
                  builder: (ctx) => AddOrEditItem(id: "", num: 2));
              setState(() {});
            },
            child: const CircleAvatar(
              backgroundColor: Colors.amber,
              radius: 30,
              child: Icon(Icons.add),
            ),
          )
        ],
      ),
    );
  }
}
