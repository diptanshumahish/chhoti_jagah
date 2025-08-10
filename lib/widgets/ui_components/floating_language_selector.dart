import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import '../../constants/language_constants.dart';
import '../../models/language_model.dart';
import '../../state_management/providers/language_provider.dart';

class FloatingLanguageSelector extends ConsumerStatefulWidget {
  final Color? backgroundColor;
  final Color? iconColor;
  final double size;
  final EdgeInsets margin;

  const FloatingLanguageSelector({
    super.key,
    this.backgroundColor,
    this.iconColor,
    this.size = 36.0,
    this.margin = const EdgeInsets.all(16.0),
  });

  @override
  ConsumerState<FloatingLanguageSelector> createState() => _FloatingLanguageSelectorState();
}

class _FloatingLanguageSelectorState extends ConsumerState<FloatingLanguageSelector>
    with TickerProviderStateMixin {
  bool _isExpanded = false;
  late AnimationController _mainController;
  late AnimationController _scaleController;
  late Animation<double> _scaleAnimation;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;
  late Animation<double> _rotateAnimation;

  @override
  void initState() {
    super.initState();
    _mainController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
    _scaleController = AnimationController(
      duration: const Duration(milliseconds: 150),
      vsync: this,
    );
    
    _scaleAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _scaleController,
      curve: Curves.elasticOut,
    ));
    
    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _mainController,
      curve: Curves.easeOutCubic,
    ));
    
    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.2),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _mainController,
      curve: Curves.easeOutCubic,
    ));
    
    _rotateAnimation = Tween<double>(
      begin: 0.0,
      end: 0.5,
    ).animate(CurvedAnimation(
      parent: _mainController,
      curve: Curves.easeInOut,
    ));
  }

  @override
  void dispose() {
    _mainController.dispose();
    _scaleController.dispose();
    super.dispose();
  }

  void _toggleExpanded() {
    setState(() {
      _isExpanded = !_isExpanded;
    });
    
    if (_isExpanded) {
      _mainController.forward();
      _scaleController.forward();
    } else {
      _mainController.reverse();
      _scaleController.reverse();
    }
  }

  @override
  Widget build(BuildContext context) {
    final currentLocale = ref.watch(languageControllerProvider);
  LanguageConstants.availableLanguages
        .firstWhere((lang) => lang.code == currentLocale.languageCode);
    final theme = Theme.of(context);

    return Positioned(
      top: widget.margin.top,
      right: widget.margin.right,
      child: Column(
        children: [
          // Main floating button
          GestureDetector(
            onTap: _toggleExpanded,
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              width: widget.size,
              height: widget.size,
              decoration: BoxDecoration(
                color: _isExpanded 
                    ? theme.colorScheme.primary
                    : theme.colorScheme.surface,
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: theme.colorScheme.shadow.withValues(alpha: 0.15),
                    blurRadius: 16,
                    offset: const Offset(0, 6),
                    spreadRadius: 0,
                  ),
                  if (_isExpanded)
                    BoxShadow(
                      color: theme.colorScheme.primary.withValues(alpha: 0.3),
                      blurRadius: 24,
                      offset: const Offset(0, 8),
                      spreadRadius: 0,
                    ),
                ],
                border: Border.all(
                  color: _isExpanded 
                      ? theme.colorScheme.primary.withValues(alpha: 0.3)
                      : theme.colorScheme.outline.withValues(alpha: 0.3),
                  width: 1.5,
                ),
              ),
              child: AnimatedRotation(
                turns: _isExpanded ? _rotateAnimation.value : 0,
                duration: const Duration(milliseconds: 300),
                child: Center(
                  child: Icon(
                    _isExpanded ? PhosphorIcons.x(PhosphorIconsStyle.regular) : PhosphorIcons.translate(PhosphorIconsStyle.regular),
                    color: _isExpanded 
                        ? Colors.white
                        : theme.colorScheme.primary,
                    size: widget.size * 0.45,
                  ),
                ),
              ),
            ),
          ),
          
          // Language options (shown below when expanded)
          if (_isExpanded) ...[
            const SizedBox(height: 16),
            FadeTransition(
              opacity: _fadeAnimation,
              child: SlideTransition(
                position: _slideAnimation,
                child: Container(
                  constraints: const BoxConstraints(maxWidth: 200),
                  child: Column(
                    children: LanguageConstants.availableLanguages.map((language) {
                      final isSelected = language.code == currentLocale.languageCode;
                      return Container(
                        margin: const EdgeInsets.only(bottom: 8),
                        child: ScaleTransition(
                          scale: _scaleAnimation,
                          child: _buildLanguageOption(language, isSelected, theme),
                        ),
                      );
                    }).toList(),
                  ),
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildLanguageOption(LanguageInfo language, bool isSelected, ThemeData theme) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: () {
          ref.read(languageControllerProvider.notifier).setLanguageByCode(language.code);
          _toggleExpanded();
        },
        borderRadius: BorderRadius.circular(16),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          decoration: BoxDecoration(
            color: isSelected 
                ? theme.colorScheme.primaryContainer
                : theme.colorScheme.surface,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: isSelected 
                  ? theme.colorScheme.primary
                  : theme.colorScheme.outline.withValues(alpha: 0.3),
              width: isSelected ? 2 : 1,
            ),
            boxShadow: [
              BoxShadow(
                color: theme.colorScheme.shadow.withValues(alpha: 0.08),
                blurRadius: 12,
                offset: const Offset(0, 4),
                spreadRadius: 0,
              ),
            ],
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                padding: const EdgeInsets.all(4),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8),
                  color: isSelected 
                      ? theme.colorScheme.primary.withValues(alpha: 0.1)
                      : theme.colorScheme.surfaceVariant.withValues(alpha: 0.5),
                ),
                child: Text(
                  language.flag,
                  style: const TextStyle(fontSize: 18),
                ),
              ),
              const SizedBox(width: 12),
              Flexible(
                child: Text(
                  language.nativeName,
                  style: theme.textTheme.bodyMedium?.copyWith(
                    fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
                    color: isSelected 
                        ? theme.colorScheme.onPrimaryContainer
                        : theme.colorScheme.onSurface,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              if (isSelected) ...[
                const SizedBox(width: 8),
                Icon(
                  PhosphorIcons.checkCircle(PhosphorIconsStyle.fill),
                  size: 20,
                  color: theme.colorScheme.primary,
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
