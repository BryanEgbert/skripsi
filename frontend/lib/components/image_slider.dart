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
        if (widget.images.isEmpty) return;
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
                  child: Image.network(
                    widget.images[_currentIndex],
                    fit: BoxFit.cover,
                    loadingBuilder: (context, child, loadingProgress) {
                      return Center(child: child);
                    },
                    errorBuilder: (context, error, stackTrace) {
                      return Container(
                        color: Colors.transparent,
                        height: 20,
                        width: 20,
                        child: Column(
                          spacing: 8,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.image_not_supported,
                              size: 32,
                              semanticLabel: "Fail to load image",
                            ),
                            Text(
                              "Failed to load image",
                              style: TextStyle(
                                fontSize: 16,
                                decoration: TextDecoration.none,
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
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
                loadingBuilder: (context, child, loadingProgress) {
                  return Center(child: child);
                },
                errorBuilder: (context, error, stackTrace) {
                  return Container(
                    color: Colors.grey,
                    child: Center(
                      child: Icon(Icons.image_not_supported),
                    ),
                  );
                },
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
