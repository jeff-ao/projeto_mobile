import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../services/translation_service.dart';
import '../main.dart' show themeNotifier;

class TranslatorScreen extends StatefulWidget {
  const TranslatorScreen({super.key});

  @override
  State<TranslatorScreen> createState() => _TranslatorScreenState();
}

class _TranslatorScreenState extends State<TranslatorScreen> {
  final TextEditingController _textController = TextEditingController();
  final TranslationService _translationService = TranslationService();

  String _translatedText = '';
  String _selectedTranslation = 'yoda';
  bool _isLoading = false;

  void _toggleTheme() {
    final currentBrightness = themeNotifier.value;
    themeNotifier.value = currentBrightness == Brightness.dark
        ? Brightness.light
        : Brightness.dark;
  }

  Future<void> _translate() async {
    if (_textController.text.isEmpty) {
      _showAlert('Por favor, digite um texto para traduzir.');
      return;
    }

    setState(() {
      _isLoading = true;
      _translatedText = '';
    });

    try {
      final result = await _translationService.translate(
        _textController.text,
        _selectedTranslation,
      );

      setState(() {
        _translatedText = result;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      _showAlert(e.toString());
    }
  }

  void _showAlert(String message) {
    showCupertinoDialog(
      context: context,
      builder: (context) => CupertinoAlertDialog(
        title: const Text('Aviso'),
        content: Text(message),
        actions: [
          CupertinoDialogAction(
            child: const Text('OK'),
            onPressed: () => Navigator.of(context).pop(),
          ),
        ],
      ),
    );
  }

  void _showTranslationPicker() {
    showCupertinoModalPopup(
      context: context,
      builder: (context) => Container(
        height: 250,
        color: CupertinoColors.systemBackground.resolveFrom(context),
        child: Column(
          children: [
            Container(
              height: 50,
              decoration: BoxDecoration(
                color: CupertinoColors.systemBackground.resolveFrom(context),
                border: const Border(
                  bottom: BorderSide(
                    color: CupertinoColors.separator,
                    width: 0.5,
                  ),
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  CupertinoButton(
                    child: const Text('Concluído'),
                    onPressed: () => Navigator.of(context).pop(),
                  ),
                ],
              ),
            ),
            Expanded(
              child: CupertinoPicker(
                backgroundColor: CupertinoColors.systemBackground.resolveFrom(
                  context,
                ),
                itemExtent: 32,
                onSelectedItemChanged: (index) {
                  setState(() {
                    _selectedTranslation =
                        TranslationService.availableTranslations[index]['id']!;
                  });
                },
                children: TranslationService.availableTranslations
                    .map(
                      (translation) => Text(
                        translation['name']!,
                        style: const TextStyle(fontSize: 18),
                      ),
                    )
                    .toList(),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final selectedTranslationName = TranslationService.availableTranslations
        .firstWhere((t) => t['id'] == _selectedTranslation)['name'];
    final brightness = CupertinoTheme.of(context).brightness ?? Brightness.dark;
    final isDark = brightness == Brightness.dark;

    return CupertinoPageScaffold(
      backgroundColor: isDark
          ? const Color(0xFF0A0A0A)
          : const Color(0xFFF5F5F7),
      navigationBar: CupertinoNavigationBar(
        backgroundColor: isDark
            ? const Color(0xFF1C1C1E)
            : CupertinoColors.white,
        border: Border(
          bottom: BorderSide(
            color: isDark
                ? Colors.white.withOpacity(0.1)
                : Colors.black.withOpacity(0.1),
            width: 0.5,
          ),
        ),
        middle: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              CupertinoIcons.globe,
              color: isDark
                  ? CupertinoColors.activeBlue
                  : CupertinoColors.activeBlue,
              size: 24,
            ),
            const SizedBox(width: 8),
            Text(
              'Tradutor 3000',
              style: TextStyle(
                color: isDark ? CupertinoColors.white : CupertinoColors.black,
                fontSize: 20,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
        trailing: CupertinoButton(
          padding: EdgeInsets.zero,
          child: Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: isDark
                  ? Colors.white.withOpacity(0.1)
                  : Colors.black.withOpacity(0.05),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(
              isDark ? CupertinoIcons.sun_max_fill : CupertinoIcons.moon_fill,
              color: isDark
                  ? CupertinoColors.systemYellow
                  : CupertinoColors.systemIndigo,
              size: 20,
            ),
          ),
          onPressed: _toggleTheme,
        ),
      ),
      child: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const SizedBox(height: 20),

              // Aviso sobre o idioma
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 14,
                ),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: isDark
                        ? [const Color(0xFF2C2C2E), const Color(0xFF1C1C1E)]
                        : [Colors.blue.shade50, Colors.indigo.shade50],
                  ),
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(
                    color: isDark
                        ? Colors.blue.withOpacity(0.3)
                        : Colors.blue.withOpacity(0.2),
                    width: 1.5,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: isDark
                          ? Colors.blue.withOpacity(0.1)
                          : Colors.blue.withOpacity(0.08),
                      blurRadius: 12,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: CupertinoColors.activeBlue.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: const Icon(
                        CupertinoIcons.info_circle_fill,
                        color: CupertinoColors.activeBlue,
                        size: 20,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        'Digite apenas texto em inglês',
                        style: TextStyle(
                          color: isDark
                              ? CupertinoColors.white
                              : CupertinoColors.black,
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 20),

              // Campo de texto
              Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: isDark
                          ? Colors.black.withOpacity(0.3)
                          : Colors.black.withOpacity(0.05),
                      blurRadius: 16,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: CupertinoTextField(
                  controller: _textController,
                  placeholder: 'Type your text here...',
                  placeholderStyle: TextStyle(
                    color: CupertinoColors.systemGrey.withOpacity(0.6),
                  ),
                  style: TextStyle(
                    color: isDark
                        ? CupertinoColors.white
                        : CupertinoColors.black,
                    fontSize: 16,
                    height: 1.5,
                  ),
                  maxLines: 6,
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: isDark
                        ? const Color(0xFF1C1C1E)
                        : CupertinoColors.white,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(
                      color: isDark
                          ? Colors.white.withOpacity(0.1)
                          : Colors.black.withOpacity(0.08),
                      width: 1,
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 20),

              // Seletor de tradução
              GestureDetector(
                onTap: _showTranslationPicker,
                child: Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: isDark
                        ? const Color(0xFF1C1C1E)
                        : CupertinoColors.white,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(
                      color: isDark
                          ? Colors.white.withOpacity(0.1)
                          : Colors.black.withOpacity(0.08),
                      width: 1,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: isDark
                            ? Colors.black.withOpacity(0.3)
                            : Colors.black.withOpacity(0.05),
                        blurRadius: 16,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              color: CupertinoColors.activeBlue.withOpacity(
                                0.1,
                              ),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: const Icon(
                              CupertinoIcons.textformat,
                              color: CupertinoColors.activeBlue,
                              size: 20,
                            ),
                          ),
                          const SizedBox(width: 12),
                          Text(
                            'Estilo:',
                            style: TextStyle(
                              color: isDark
                                  ? CupertinoColors.systemGrey
                                  : CupertinoColors.systemGrey,
                              fontSize: 15,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                      Row(
                        children: [
                          Text(
                            selectedTranslationName!,
                            style: TextStyle(
                              color: CupertinoColors.activeBlue,
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          const SizedBox(width: 8),
                          Icon(
                            CupertinoIcons.chevron_down_circle_fill,
                            color: CupertinoColors.activeBlue.withOpacity(0.7),
                            size: 22,
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 20),

              // Botão de traduzir
              Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(16),
                  gradient: LinearGradient(
                    colors: _isLoading
                        ? [
                            CupertinoColors.systemGrey,
                            CupertinoColors.systemGrey,
                          ]
                        : [
                            CupertinoColors.activeBlue,
                            CupertinoColors.activeBlue.darkColor,
                          ],
                  ),
                  boxShadow: _isLoading
                      ? []
                      : [
                          BoxShadow(
                            color: CupertinoColors.activeBlue.withOpacity(0.4),
                            blurRadius: 20,
                            offset: const Offset(0, 8),
                          ),
                        ],
                ),
                child: CupertinoButton(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  borderRadius: BorderRadius.circular(16),
                  onPressed: _isLoading ? null : _translate,
                  child: _isLoading
                      ? const CupertinoActivityIndicator(
                          color: CupertinoColors.white,
                        )
                      : Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Icon(
                              CupertinoIcons.arrow_right_arrow_left_circle_fill,
                              color: CupertinoColors.white,
                              size: 22,
                            ),
                            const SizedBox(width: 10),
                            const Text(
                              'Traduzir Agora',
                              style: TextStyle(
                                color: CupertinoColors.white,
                                fontSize: 18,
                                fontWeight: FontWeight.w700,
                                letterSpacing: 0.5,
                              ),
                            ),
                          ],
                        ),
                ),
              ),

              const SizedBox(height: 30),

              // Resultado da tradução
              if (_translatedText.isNotEmpty) ...[
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(6),
                      decoration: BoxDecoration(
                        color: CupertinoColors.systemGreen.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: const Icon(
                        CupertinoIcons.checkmark_circle_fill,
                        color: CupertinoColors.systemGreen,
                        size: 16,
                      ),
                    ),
                    const SizedBox(width: 8),
                    const Text(
                      'Resultado',
                      style: TextStyle(
                        color: CupertinoColors.systemGrey,
                        fontSize: 15,
                        fontWeight: FontWeight.w600,
                        letterSpacing: 0.3,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 14),
                Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: isDark
                          ? [const Color(0xFF1C1C1E), const Color(0xFF2C2C2E)]
                          : [Colors.white, Colors.grey.shade50],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(
                      color: CupertinoColors.systemGreen.withOpacity(0.3),
                      width: 1.5,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: CupertinoColors.systemGreen.withOpacity(0.15),
                        blurRadius: 20,
                        offset: const Offset(0, 6),
                      ),
                    ],
                  ),
                  child: Text(
                    _translatedText,
                    style: TextStyle(
                      color: isDark
                          ? CupertinoColors.white
                          : CupertinoColors.black,
                      fontSize: 17,
                      height: 1.6,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _textController.dispose();
    super.dispose();
  }
}
