class OnboardingScreenItem {
  final String title;
  final String content;
  final String image;

  OnboardingScreenItem(this.title, this.content, this.image);
}

List<OnboardingScreenItem> onboardingScreenItems = [
  OnboardingScreenItem(
    'The Future of Schools. Now.',
    'Now you can access all your kid\'s school administrative features online.',
    'assets/lottie/schools.json',
  ),
  OnboardingScreenItem(
    'The Future of Principals. Now.',
    'Principal can view the whole school Attendance Dashboard by 9:00 AM.',
    'assets/lottie/principal onboarding.json',
  ),

  OnboardingScreenItem(
    'The Future of Educators. Now',
    '.',
    'assets/lottie/educators onboarding.json',
  ),
  OnboardingScreenItem(
    'The Future of Parents. Now',
    'Parents can view their child attendance, download multimedia content, apply for leave.',
    'assets/lottie/parents on Boarding.json',
  ),
  // OnboardingScreenItem(
  //   'Your personal data is secure',
  //   '',
  //   'assets/lottie/lock_icon_animation.json',
  // ),
];
