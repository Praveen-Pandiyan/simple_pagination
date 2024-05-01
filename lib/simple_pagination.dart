library simple_pagination;

import 'package:flutter/material.dart';

class SimplePagenation extends StatefulWidget {
  final List<Widget> children;
  final int itemsPerPage;
  final Icon nextIcon, previousIcon;
  final Decoration decoration, currentPageDecoration;
  final EdgeInsetsGeometry padding;
  final TextStyle textStyle;
  const SimplePagenation(
      {Key? key,
      required this.children,
      this.itemsPerPage = 5,
      this.nextIcon = const Icon(Icons.arrow_forward, size: 20),
      this.previousIcon = const Icon(Icons.arrow_back, size: 20),
      this.decoration = const BoxDecoration(
        color: Colors.blue,
      ),
      this.currentPageDecoration = const BoxDecoration(
        color: Colors.blueAccent,
      ),
      this.padding = const EdgeInsets.all(0.0),
      this.textStyle = const TextStyle(fontSize: 18)})
      : super(key: key);

  @override
  _SimplePagenationState createState() => _SimplePagenationState();
}

class _SimplePagenationState extends State<SimplePagenation> {
  late int currentPage = 0, showFrom, showTo, numberOfPages, maxNumOfPages = 4;
  late List<Widget> lastState;
  _update() {
    setState(() {
      lastState = widget.children;
      showFrom = 0;
      showTo = widget.itemsPerPage >= widget.children.length
          ? widget.children.length
          : widget.itemsPerPage;
      numberOfPages = (widget.children.length / widget.itemsPerPage).ceil();
    });
    if (currentPage <= numberOfPages) {
      _moveTo(currentPage);
    } else {
      _moveTo(0);
    }
  }

  _moveTo(index) {
    if (index >= 0 && index <= numberOfPages - 1) {
      setState(() {
        showFrom = index * widget.itemsPerPage;
        if (showFrom + widget.itemsPerPage <= widget.children.length)
          showTo = showFrom + widget.itemsPerPage;
        else
          showTo = widget.children.length;
        currentPage = index;
      });
    }
  }

  @override
  void initState() {
    _update();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    if (lastState != widget.children) {
      _update();
    }
    if ((showTo > 0 && widget.children.length > 0)) {
      return Container(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            // slised list

            ...widget.children.sublist(showFrom, showTo),

            // nav
            Container(
              alignment: Alignment.bottomRight,
              width: MediaQuery.of(context).size.width,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  // previous Button
                  InkWell(
                    onTap: () {
                      _moveTo(currentPage - 1);
                    },
                    child: Container(
                      padding: const EdgeInsets.all(6.0),
                      height: 30,
                      decoration: widget.decoration,
                      child: widget.previousIcon,
                    ),
                  ),
                  //page numbers list
                  ...List.generate(
                    numberOfPages,
                    (index) => index,
                  ).crop(currentPage, numberOfPages, 4).map((index) => InkWell(
                        onTap: () {
                          _moveTo(index);
                        },
                        child: Container(
                          padding: const EdgeInsets.all(6.0),
                          decoration: (currentPage == index)
                              ? widget.currentPageDecoration
                              : widget.decoration,
                          height: 30,
                          child: Text(
                            (index + 1).toString(),
                            style: widget.textStyle,
                          ),
                        ),
                      )),
                  // next Button
                  InkWell(
                    onTap: () {
                      _moveTo(currentPage + 1);
                    },
                    child: Container(
                      padding: const EdgeInsets.all(6.0),
                      height: 30,
                      decoration: widget.decoration,
                      child: widget.nextIcon,
                    ),
                  ),
                ]
                    .map((e) => Padding(
                          padding: widget.padding,
                          child: e,
                        ))
                    .toList(),
              ),
            )
          ],
        ),
      );
    } else {
      return Text("List is empty");
    }
  }
}

extension FocusCrop on List {
  List focusCrop(currentIndex, int length) {
    int start, end = 0;
    if (currentIndex - length ~/ 2 > 0) {
      start = currentIndex - length ~/ 2;
    } else {
      start = 0;
    }

    if ((currentIndex + length ~/ 2) + 1 < this.length) {
      end = currentIndex + length ~/ 2;
    } else {
      end = this.length - 1;
    }
    return this.sublist(start, end + 1);
  }

  List crop(currentIndex, int length, int maxLength) {
    int start = currentIndex, end = currentIndex;
    List<int> list = [currentIndex];
    for (var i = 1; i <= maxLength; i++) {
      if (start + 1 < length) {
        start++;
        list.add(start);
      } else if (end - 1 >= 0) {
        end--;
        list.insert(0, end);
      }
    }
    return list;
  }
}
