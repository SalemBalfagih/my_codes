## Circular picture with frame

```dart
CircleAvatar(
  backgroundColor: AppColor.primaryColor,
  radius: 25,
  child: CircleAvatar(
    backgroundColor: AppColor.secondaryColor,
    radius: 22.5,
    backgroundImage: NetworkImage(
      "https://images.unsplash.com/photo-1633332755192-727a05c4013d?ixlib=rb-4.0.3&ixid=MnwxMjA3fDB8MHxzZWFyY2h8Mnx8dXNlcnxlbnwwfHwwfHw%3D&w=1000&q=80",
    ),
  ),
),
```

## إنشاء scroll للشاشة كاملة مع الاحتفاظ بالاداء بواسطة SliverList
```dart
 CustomScrollView(
            slivers: [
              SliverToBoxAdapter(
                child: SizedBox(
                    height: 85,
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: 10,
                      itemBuilder: (context, index) {
                        return Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 8.0),
                          child: Container(
                            height: 85,
                            width: 160,
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                                color: Colors.amber),
                          ),
                        );
                      },
                    )),
              ),
              SliverToBoxAdapter(
                child: SizedBox(
                  height: 10,
                ),
              ),
              SliverList(
                childCount: 10,
                delegate: SliverChildBuilderDelegate(
                  (context, index) {
                    return NewsTile();
                  },
                 
                ),
              )
            ],
          ),
