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
