import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:jac_slide_puzzle/puzzle/puzzle.dart';

class PuzzlePage extends StatelessWidget {
  const PuzzlePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => PuzzleCubit(),
      child: const PuzzleView(),
    );
  }
}

class PuzzleView extends StatelessWidget {
  const PuzzleView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: const Text('3D slide puzzle'),
        ),
        body: Center(
          //TODO: Add responsive layout for button positions
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              IconButton(
                onPressed: () => context.read<PuzzleCubit>().rotateUp(),
                icon: const Icon(Icons.arrow_upward),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  IconButton(
                    onPressed: () => context.read<PuzzleCubit>().rotateLeft(),
                    icon: const Icon(Icons.arrow_back),
                  ),
                  const SizedBox(
                    width: 500,
                    height: 500,
                    child: Center(
                      child: AnimatedPuzzleCube(),
                    ),
                  ),
                  IconButton(
                    onPressed: () => context.read<PuzzleCubit>().rotateRight(),
                    icon: const Icon(Icons.arrow_forward),
                  ),
                ],
              ),
              IconButton(
                onPressed: () => context.read<PuzzleCubit>().rotateDown(),
                icon: const Icon(Icons.arrow_downward),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
