import 'package:flutter/material.dart';

class ImageSlider extends StatefulWidget {
  final List<String> images;
  const ImageSlider({super.key, required this.images});

  @override
  State<ImageSlider> createState() => _ImageSliderState();
}

class _ImageSliderState extends State<ImageSlider> {
  final PageController _controller = PageController();
  int _currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        showGeneralDialog(
          context: context,
          barrierColor: Colors.black.withValues(alpha: 0.5),
          barrierLabel: 'Image details',
          pageBuilder: (context, animation, secondaryAnimation) {
            return SizedBox.expand(
              child: GestureDetector(
                onTap: () {
                  Navigator.of(context).pop();
                },
                child: InteractiveViewer(
                  child: Image.network(widget.images[_currentIndex]),
                ),
              ),
            );
          },
        );
      },
      child: Stack(
        alignment: Alignment.bottomCenter,
        children: [
          SizedBox(
            height: 200,
            width: double.infinity,
            child: PageView.builder(
              controller: _controller,
              itemCount: widget.images.length,
              onPageChanged: (index) {
                setState(() => _currentIndex = index);
              },
              itemBuilder: (context, index) => Image.network(
                widget.images[index],
                fit: BoxFit.cover,
                width: double.infinity,
              ),
            ),
          ),
          Positioned(
            bottom: 8,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(
                widget.images.length,
                (index) => AnimatedContainer(
                  duration: const Duration(milliseconds: 300),
                  margin: const EdgeInsets.symmetric(horizontal: 3),
                  width: _currentIndex == index ? 10 : 8,
                  height: _currentIndex == index ? 10 : 8,
                  decoration: BoxDecoration(
                    color: _currentIndex == index
                        ? Colors.deepOrange
                        : Colors.orange[200],
                    shape: BoxShape.circle,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
