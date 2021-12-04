// class TimerProgress extends StatefulWidget {
//   const TimerProgress({Key? key, this.minutes = 0, this.seconds = 0}) : super(key: key);
//
//   final int minutes, seconds;
//
//   @override
//   State<TimerProgress> createState() => _TimerProgressState();
//
// }
//
// class _TimerProgressState extends State<TimerProgress> with TickerProviderStateMixin{
//   late AnimationController controller;
//   //var displayedMinutes = 0, displayedSeconds = 0;
//   var _counter = 0;
//   @override
//   void initState() {
//     controller = AnimationController(
//       vsync: this,
//       duration: Duration(minutes: widget.minutes,
//           seconds: widget.seconds),
//     )..addListener(() {
//       setState(() {
//         _counter++;
//       });
//     });
//
//     //controller.repeat(reverse: true);
//
//     super.initState();
//   }
//
//   @override
//   void dispose() {
//     controller.dispose();
//     super.dispose();
//   }
//
//   @override
//   Widget build(BuildContext context){
//     return Stack(
//
//       children: [
//         Center(
//             child: SizedBox(
//                 width: 200,
//                 height: 200,
//                 child:
//                 CircularProgressIndicator(value: controller.value,
//                   semanticsLabel: 'Timer Progress Indicator',
//                   backgroundColor: Colors.red,)
//             )
//         ),
//         Center(
//             child: Text('$_counter')
//         )
//       ],
//     );
//   }
// }