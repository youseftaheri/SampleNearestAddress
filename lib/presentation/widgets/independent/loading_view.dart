import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:sample_nearest_address/presentation/widgets/independent/CustomBackground.dart';

class LoadingView extends StatelessWidget {
  const LoadingView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        const CustomBackground(),
        Center(
          child: Lottie.asset('assets/lottieFiles/loading_1.json',
              width: 110,
              height: 110,
              fit: BoxFit.fill
          ),
        )
      ],
    );
  }
}
