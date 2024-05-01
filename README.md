# Simple pagination

A simple widget used to paginate list of widgets.

## Usage
1. Add the simple_pagination package to your pubspec dependencies.

2. Import SimplePagination.

``` dart
import 'package:simple_pagination/simple_pagination.dart';
```

``` dart
 SimplePagenation(
   children: [
    Text("1"),Text("2"),Text("3")
   ]
 )
```
We can overide the default values like.

```
   itemsPerPage: 3,
   nextIcon: Icon(Icons.arrow_forward,size: 20,),
   previousIcon: Icon(Icons.arrow_back,size: 20,)
```