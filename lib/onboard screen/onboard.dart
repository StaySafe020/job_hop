import 'package:flutter/material.dart';
import '../authentication/login_screen.dart';

class OnBoardModel {
  final String title;
  final String description;
  final String image;

  OnBoardModel({
    required this.title,
    required this.description,
    required this.image,
  });
}

class OnboardScreen extends StatefulWidget {
  const OnboardScreen({Key? key}) : super(key: key);

  @override
  State<OnboardScreen> createState() => _OnboardScreenState();
}

class _OnboardScreenState extends State<OnboardScreen> {
  late PageController _pageController;
  int currentIndex = 0;

  final List<OnBoardModel> onBoardData = [
    OnBoardModel(
      title: "Find Your Dream Job",
      description: "Discover thousands of job opportunities with all the information you need.",
      image: "assets/image/Girl Laptop 1 Standing F1.png",
    ),
    OnBoardModel(
      title: "Easy Apply",
      description: "Apply to jobs with a single click and track your applications.",
      image: "assets/image/Work From Home- Girl S.png",
    ),
    OnBoardModel(
      title: "Get Hired",
      description: "Connect with employers and start your new career journey.",
      image: "assets/image/App Browsing MF S2.png",
    ),
  ];

  @override
  void initState() {
    _pageController = PageController();
    super.initState();
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              flex: 3,
              child: PageView.builder(
                controller: _pageController,
                onPageChanged: (value) {
                  setState(() {
                    currentIndex = value;
                  });
                },
                itemCount: onBoardData.length,
                itemBuilder: (context, index) => OnboardContent(
                  title: onBoardData[index].title,
                  description: onBoardData[index].description,
                  image: onBoardData[index].image,
                ),
              ),
            ),
            Expanded(
              flex: 1,
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: List.generate(
                      onBoardData.length,
                      (index) => buildDot(index),
                    ),
                  ),
                  const Spacer(),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: SizedBox(
                      width: double.infinity,
                      height: 50,
                      child: ElevatedButton(
                      onPressed: () {
  if (currentIndex == onBoardData.length - 1) {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => LoginScreen()),
    );
  } else {
    _pageController.nextPage(
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeIn,
    );
  }
},
                        child: Text(
                          currentIndex == onBoardData.length - 1
                              ? "Get Started"
                              : "Next",
                          style: const TextStyle(fontSize: 18),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }



  AnimatedContainer buildDot(int index) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      margin: const EdgeInsets.only(right: 5),
      height: 6,
      width: currentIndex == index ? 20 : 6,
      decoration: BoxDecoration(
        color: currentIndex == index ? Colors.blue : Colors.grey,
        borderRadius: BorderRadius.circular(3),
      ),
    );
  }
}

class OnboardContent extends StatelessWidget {
  final String title;
  final String description;
  final String image;

  const OnboardContent({
    Key? key,
    required this.title,
    required this.description,
    required this.image,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Image.asset(
          image,
          height: 250,
        ),
        const SizedBox(height: 30),
        Text(
          title,
          textAlign: TextAlign.center,
          style: const TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 15),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Text(
            description,
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 16,
              color: Colors.grey,
            ),
          ),
        ),
      ],
    );
  }
}