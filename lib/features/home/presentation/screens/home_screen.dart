import 'package:flutter/material.dart';
import '../../../../core/widgets/widgets.dart';
import '../../../../core/theme/theme.dart';

/// Home screen for the Cleo app.
class HomeScreen extends StatelessWidget {
  /// Constructor
  const HomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CleoAppBar(
        title: 'Cleo',
        showBackButton: false,
        // actions:  [ThemeToggle()],
      ),
      body: SingleChildScrollView(
        padding: CleoSpacing.pagePadding,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Welcome to Cleo',
              style: Theme.of(context).textTheme.displayLarge,
            ),
            const SizedBox(height: CleoSpacing.md),
            Text(
              'Your vinyl collection manager',
              style: Theme.of(context).textTheme.bodyLarge,
            ),
            const SizedBox(height: CleoSpacing.lg),
            _buildThemeDemo(context),
            const SizedBox(height: CleoSpacing.lg),
            _buildButtonsDemo(context),
            const SizedBox(height: CleoSpacing.lg),
            _buildCardsDemo(context),
            const SizedBox(height: CleoSpacing.lg),
            _buildLoadingDemo(context),
          ],
        ),
      ),
    );
  }

  Widget _buildThemeDemo(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Typography',
          style: Theme.of(context).textTheme.displayMedium,
        ),
        const SizedBox(height: CleoSpacing.md),
        Card(
          child: Padding(
            padding: CleoSpacing.cardPadding,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Display Large (Headline 1)',
                  style: Theme.of(context).textTheme.displayLarge,
                ),
                const SizedBox(height: CleoSpacing.sm),
                Text(
                  'Display Medium (Headline 2)',
                  style: Theme.of(context).textTheme.displayMedium,
                ),
                const SizedBox(height: CleoSpacing.sm),
                Text(
                  'Title Large (Headline 3)',
                  style: Theme.of(context).textTheme.titleLarge,
                ),
                const SizedBox(height: CleoSpacing.sm),
                Text(
                  'Body Large - Main content text that is easy to read',
                  style: Theme.of(context).textTheme.bodyLarge,
                ),
                const SizedBox(height: CleoSpacing.sm),
                Text(
                  'Body Medium - Secondary text for descriptions',
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
                const SizedBox(height: CleoSpacing.sm),
                Text(
                  'Body Small - Smaller text for less important content',
                  style: Theme.of(context).textTheme.bodySmall,
                ),
                const SizedBox(height: CleoSpacing.sm),
                Text(
                  'Caption - Very small text for labels',
                  style: Theme.of(context).textTheme.labelSmall,
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: CleoSpacing.md),
        Text(
          'Colors',
          style: Theme.of(context).textTheme.displayMedium,
        ),
        const SizedBox(height: CleoSpacing.md),
        Card(
          child: Padding(
            padding: CleoSpacing.cardPadding,
            child: Wrap(
              spacing: CleoSpacing.sm,
              runSpacing: CleoSpacing.sm,
              children: [
                _buildColorBox('Primary', CleoColors.primary, Colors.white),
                _buildColorBox('Primary Light', CleoColors.primaryLight, Colors.white),
                _buildColorBox('Primary Dark', CleoColors.primaryDark, Colors.white),
                _buildColorBox('Success', CleoColors.success, Colors.white),
                _buildColorBox('Error', CleoColors.error, Colors.white),
                _buildColorBox('Info', CleoColors.info, Colors.white),
                _buildColorBox('Surface', CleoColors.surface, CleoColors.textPrimary),
                _buildColorBox('Surface Container', CleoColors.surfaceContainer, CleoColors.textPrimary),
                _buildColorBox('Text Primary', CleoColors.textPrimary, Colors.white),
                _buildColorBox('Text Secondary', CleoColors.textSecondary, Colors.white),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildColorBox(String name, Color color, Color textColor) {
    return Container(
      width: 100,
      height: 100,
      decoration: BoxDecoration(
        color: color,
        borderRadius: CleoSpacing.borderRadius,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withAlpha(100),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Center(
        child: Text(
          name,
          style: TextStyle(
            color: textColor,
            fontWeight: FontWeight.bold,
          ),
          textAlign: TextAlign.center,
        ),
      ),
    );
  }

  Widget _buildButtonsDemo(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Buttons',
          style: Theme.of(context).textTheme.displayMedium,
        ),
        const SizedBox(height: CleoSpacing.md),
        Card(
          child: Padding(
            padding: CleoSpacing.cardPadding,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Wrap(
                  spacing: CleoSpacing.md,
                  runSpacing: CleoSpacing.md,
                  children: [
                    CleoButtons.primary(
                      onPressed: () {},
                      child: const Text('Primary Button'),
                    ),
                    CleoButtons.secondary(
                      onPressed: () {},
                      child: const Text('Secondary Button'),
                    ),
                    CleoButtons.text(
                      onPressed: () {},
                      child: const Text('Text Button'),
                    ),
                    CleoButtons.icon(
                      onPressed: () {},
                      icon: Icons.favorite,
                      tooltip: 'Favorite',
                    ),
                  ],
                ),
                const SizedBox(height: CleoSpacing.md),
                Text(
                  'Loading State',
                  style: Theme.of(context).textTheme.titleLarge,
                ),
                const SizedBox(height: CleoSpacing.sm),
                Wrap(
                  spacing: CleoSpacing.md,
                  runSpacing: CleoSpacing.md,
                  children: [
                    CleoButtons.primary(
                      onPressed: () {},
                      isLoading: true,
                      child: const Text('Primary Loading'),
                    ),
                    CleoButtons.secondary(
                      onPressed: () {},
                      isLoading: true, 
                      child: const Text('Secondary Loading'),
                    ),
                    CleoButtons.text(
                      onPressed: () {},
                      isLoading: true,
                      child: const Text('Text Loading'),
                    ),
                  ],
                ),
                const SizedBox(height: CleoSpacing.md),
                Text(
                  'Full Width',
                  style: Theme.of(context).textTheme.titleLarge,
                ),
                const SizedBox(height: CleoSpacing.sm),
                CleoButtons.primary(
                  onPressed: () {},
                  isFullWidth: true,
                  child: const Text('Full Width Primary'),
                ),
                const SizedBox(height: CleoSpacing.sm),
                CleoButtons.secondary(
                  onPressed: () {},
                  isFullWidth: true,
                  child: const Text('Full Width Secondary'),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildCardsDemo(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Cards',
          style: Theme.of(context).textTheme.displayMedium,
        ),
        const SizedBox(height: CleoSpacing.md),
        CleoCard(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Basic Card',
                style: Theme.of(context).textTheme.titleLarge,
              ),
              const SizedBox(height: CleoSpacing.sm),
              Text(
                'This is a basic card with default styling',
                style: Theme.of(context).textTheme.bodyMedium,
              ),
            ],
          ),
        ),
        const SizedBox(height: CleoSpacing.md),
        CleoCard(
          onTap: () {},
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Tappable Card',
                style: Theme.of(context).textTheme.titleLarge,
              ),
              const SizedBox(height: CleoSpacing.sm),
              Text(
                'This card has a tap action, try tapping it!',
                style: Theme.of(context).textTheme.bodyMedium,
              ),
            ],
          ),
        ),
        const SizedBox(height: CleoSpacing.md),
        CleoCard(
          elevation: 8,
          margin: const EdgeInsets.all(CleoSpacing.md),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Custom Card',
                style: Theme.of(context).textTheme.titleLarge,
              ),
              const SizedBox(height: CleoSpacing.sm),
              Text(
                'This card has custom elevation and margin',
                style: Theme.of(context).textTheme.bodyMedium,
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildLoadingDemo(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Loading Indicators',
          style: Theme.of(context).textTheme.displayMedium,
        ),
        const SizedBox(height: CleoSpacing.md),
        Card(
          child: Padding(
            padding: CleoSpacing.cardPadding,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Wrap(
                  spacing: CleoSpacing.xl,
                  runSpacing: CleoSpacing.lg,
                  alignment: WrapAlignment.spaceAround,
                  children: [
                    Column(
                      children: [
                        CleoLoading(),
                        SizedBox(height: CleoSpacing.sm),
                        Text('Default'),
                      ],
                    ),
                    Column(
                      children: [
                        CleoLoading(
                          size: 30,
                          color: CleoColors.success,
                        ),
                        SizedBox(height: CleoSpacing.sm),
                        Text('Custom Color'),
                      ],
                    ),
                    Column(
                      children: [
                        CleoLoading(
                          message: 'Loading...',
                        ),
                        SizedBox(height: CleoSpacing.sm),
                        Text('With Message'),
                      ],
                    ),
                  ],
                ),
                const SizedBox(height: CleoSpacing.lg),
                Text(
                  'Linear Loading',
                  style: Theme.of(context).textTheme.titleLarge,
                ),
                const SizedBox(height: CleoSpacing.sm),
                const CleoLoading(
                  isCircular: false,
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
