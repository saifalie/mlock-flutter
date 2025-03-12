import 'package:logger/logger.dart';

class MyCustomPrinter extends LogPrinter {
  final int methodCount;
  final int errorMethodCount;
  final int lineLength;
  final bool colors;
  final bool printTime;
  final bool printEmojis;

  MyCustomPrinter({
    this.methodCount = 2,
    this.errorMethodCount = 8,
    this.lineLength = 120,
    this.colors = true,
    this.printTime = true,
    this.printEmojis = true,
  });

  @override
  List<String> log(LogEvent event) {
    // Determine color and level label based on log level using ANSI color codes
    AnsiColor color;
    String levelLabel;
    switch (event.level) {
      case Level.error:
        color = const AnsiColor(31); // Red
        levelLabel = "ERROR";
        break;
      case Level.warning:
        color = const AnsiColor(33); // Yellow
        levelLabel = "WARN";
        break;
      case Level.info:
        color = const AnsiColor(32); // Green
        levelLabel = "INFO";
        break;
      case Level.debug:
        color = const AnsiColor(35); // Blue
        levelLabel = "DEBUG";
        break;
      default:
        color = const AnsiColor();
        levelLabel = "LOG";
    }

    // Build timestamp and emoji strings if enabled
    final timeStr = printTime ? "[${DateTime.now().toIso8601String()}]" : "";
    final emojiStr = printEmojis ? " ${_emojiForLevel(event.level)}" : "";

    // Construct a detailed message including timestamp, level, and the log message
    final message = "$timeStr [$levelLabel]$emojiStr ${event.message}";
    return [colors ? color(message) : message];
  }

  // Returns an emoji based on the log level.
  String _emojiForLevel(Level level) {
    switch (level) {
      case Level.error:
        return "❌";
      case Level.warning:
        return "⚠️";
      case Level.info:
        return "✅";
      case Level.debug:
        return "🐛";
      default:
        return "";
    }
  }
}

// Simple AnsiColor class to wrap messages with ANSI color codes.
class AnsiColor {
  final int code;
  const AnsiColor([this.code = 0]);

  String call(String msg) {
    if (code == 0) return msg;
    return "\x1B[${code}m$msg\x1B[0m";
  }
}

// Global logger instance
final logger = Logger(printer: MyCustomPrinter());
