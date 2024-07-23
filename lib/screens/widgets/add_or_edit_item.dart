import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:homework_graphql/utils/constants/products_graphql_quers.dart';

class AddOrEditItem extends StatefulWidget {
  final String id;
  final int num;

  const AddOrEditItem({required this.id, required this.num, super.key});

  @override
  State<AddOrEditItem> createState() => _AddOrEditItemState();
}

class _AddOrEditItemState extends State<AddOrEditItem> {
  final titleController = TextEditingController();
  final descriptionController = TextEditingController();
  final priceController = TextEditingController();
  final _globalKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text(
        "Edit item",
        textAlign: TextAlign.center,
      ),
      content: Form(
          key: _globalKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextFormField(
                validator: (value) {
                  if (value!.isEmpty) {
                    return "Please enter product title";
                  }
                  return null;
                },
                controller: titleController,
                decoration: const InputDecoration(
                    hintText: "Title", border: OutlineInputBorder()),
              ),
              const Gap(20),
              TextFormField(
                validator: (value) {
                  if (value!.isEmpty) {
                    return "Please enter product description";
                  }
                  return null;
                },
                controller: descriptionController,
                decoration: const InputDecoration(
                    hintText: "Description", border: OutlineInputBorder()),
              ),
              const Gap(20),
              TextFormField(
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value!.isEmpty) {
                    return "Please enter product price";
                  }
                  return null;
                },
                controller: priceController,
                decoration: const InputDecoration(
                    hintText: "Price", border: OutlineInputBorder()),
              ),
              const Gap(60),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  TextButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      child: const Text(
                        "Cancel",
                        style: TextStyle(
                            color: Colors.red,
                            fontSize: 18,
                            fontWeight: FontWeight.w500),
                      )),
                  InkWell(
                    onTap: () {
                      if (_globalKey.currentState!.validate()) {
                        if (widget.num == 1) {
                          print("edit");
                          GraphQLProvider.of(context).value.mutate(
                                MutationOptions(
                                  document: gql(editProduct),
                                  variables: {
                                    "id": int.parse(widget.id),
                                    "title": titleController.text,
                                    "description": descriptionController.text,
                                    "price": priceController.text,
                                  },
                                  onCompleted: (data) {
                                    print("$data data");
                                  },
                                  onError: (error) {
                                    print(error!.linkException);
                                  },
                                ),
                              );
                        } else {
                          const String addProduct = """
mutation createProduct(
    \$title: String!, 
    \$price: Float!, 
    \$description: String!,
    \$categoryId: Float!,
    \$images: [String!]!
) {
    addProduct(
      data: {
        title: \$title
        price: \$price
        description: \$description
        categoryId: \$categoryId
        images: \$images
      }
    ) {
      id
      title
      price
    }
}
""";
                        }
                      }
                      Navigator.pop(context);
                    },
                    child: Container(
                      width: 110,
                      height: 40,
                      decoration: BoxDecoration(
                          color: Colors.green,
                          borderRadius: BorderRadius.circular(30)),
                      child: const Center(
                        child: Text(
                          "Save",
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                              fontWeight: FontWeight.w500),
                        ),
                      ),
                    ),
                  )
                ],
              )
            ],
          )),
    );
  }
}
