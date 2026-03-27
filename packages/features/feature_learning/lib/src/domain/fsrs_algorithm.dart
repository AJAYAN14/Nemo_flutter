import 'dart:math';

/// FSRS 6 Memory State
///
/// [stability] Memory stability (in days) — the number of days until the probability of recall drops to 90%
/// [difficulty] Difficulty (range: 1-10)
class MemoryState {
  final double stability;
  final double difficulty;

  const MemoryState({
    this.stability = 0.0,
    this.difficulty = 0.0,
  });

  @override
  String toString() => 'MemoryState(stability: $stability, difficulty: $difficulty)';
}

/// FSRS Ratings (aligned with Anki)
enum FsrsRating {
  again(1),
  hard(2),
  good(3),
  easy(4);

  final int value;
  const FsrsRating(this.value);
}

/// Next state preview for each rating button
class NextStates {
  final ItemState again;
  final ItemState hard;
  final ItemState good;
  final ItemState easy;

  const NextStates({
    required this.again,
    required this.hard,
    required this.good,
    required this.easy,
  });
}

class ItemState {
  final MemoryState memory;
  final double interval;

  const ItemState({
    required this.memory,
    required this.interval,
  });
}

/// FSRS 6 Core Algorithm
///
/// Ported from Kotlin implementation which references fsrs-rs v5.1.0.
/// Contains the complete 21-parameter model.
class FsrsAlgorithm {
  final List<double> parameters;
  final double desiredRetention;

  static const List<double> defaultParameters = [
    0.212,     // w[0]: init_stability for Again
    1.2931,    // w[1]: init_stability for Hard
    2.3065,    // w[2]: init_stability for Good
    8.2956,    // w[3]: init_stability for Easy
    6.4133,    // w[4]: init_difficulty base
    0.8334,    // w[5]: init_difficulty rating factor
    3.0194,    // w[6]: next_difficulty delta factor
    0.001,     // w[7]: mean_reversion weight
    1.8722,    // w[8]: stability_after_success exp base
    0.1666,    // w[9]: stability_after_success stability power
    0.796,     // w[10]: stability_after_success retrievability factor
    1.4835,    // w[11]: stability_after_failure base
    0.0614,    // w[12]: stability_after_failure difficulty power
    0.2629,    // w[13]: stability_after_failure stability power
    1.6483,    // w[14]: stability_after_failure retrievability factor
    0.6014,    // w[15]: hard_penalty
    1.8729,    // w[16]: easy_bonus
    0.5425,    // w[17]: short_term factor
    0.0912,    // w[18]: short_term rating offset
    0.0658,    // w[19]: short_term stability power
    0.1542     // w[20]: decay (FSRS 6)
  ];

  static const double sMin = 0.01;
  static const double sMax = 36500.0;
  static const double dMin = 1.0;
  static const double dMax = 10.0;
  static const int maxInterval = 36500;

  FsrsAlgorithm({
    List<double>? parameters,
    this.desiredRetention = 0.9,
  }) : parameters = parameters ?? List.from(defaultParameters);

  List<double> get w => parameters;

  // ========== Core Formulas ==========

  /// Power-law forgetting curve
  /// R(t, S) = (1 + factor * t/S)^(-decay)
  double forgettingCurve(double elapsedDays, double stability) {
    final decay = w[20];
    final factor = pow(0.9, 1.0 / -decay) - 1.0;
    return pow(elapsedDays / stability * factor + 1.0, -decay).toDouble();
  }

  /// Calculate optimal next interval
  /// I(S, R) = S / factor * (R^(1/-decay) - 1)
  double nextInterval(double stability, {double? retention}) {
    final r = retention ?? desiredRetention;
    final decay = w[20];
    final factor = pow(0.9, 1.0 / -decay) - 1.0;
    return stability / factor * (pow(r, 1.0 / -decay) - 1.0);
  }

  /// Initial stability for a new card
  double initStability(FsrsRating rating) {
    return w[rating.value - 1].clamp(sMin, sMax);
  }

  /// Initial difficulty for a new card
  double initDifficulty(FsrsRating rating) {
    return (w[4] - exp(w[5] * (rating.value - 1.0)) + 1.0).clamp(dMin, dMax);
  }

  /// New stability after success
  double stabilityAfterSuccess(
    double stability,
    double difficulty,
    double retrievability,
    FsrsRating rating,
  ) {
    final hardPenalty = (rating == FsrsRating.hard) ? w[15] : 1.0;
    final easyBonus = (rating == FsrsRating.easy) ? w[16] : 1.0;

    final newS = stability *
        (exp(w[8]) *
                (11.0 - difficulty) *
                pow(stability, -w[9]) *
                (exp((1.0 - retrievability) * w[10]) - 1.0) *
                hardPenalty *
                easyBonus +
            1.0);
    return newS.clamp(sMin, sMax);
  }

  /// New stability after failure
  double stabilityAfterFailure(
    double stability,
    double difficulty,
    double retrievability,
  ) {
    final newS = w[11] *
        pow(difficulty, -w[12]) *
        (pow(stability + 1.0, w[13]) - 1.0) *
        exp((1.0 - retrievability) * w[14]);

    // Minimum constraint: stability after failure must not be lower than S / exp(w[17]*w[18])
    final minS = stability / exp(w[17] * w[18]);

    return max(newS, minS).clamp(sMin, sMax);
  }

  /// Short-term stability (for same-day learning steps)
  double stabilityShortTerm(double stability, FsrsRating rating) {
    final sinc = exp(w[17] * (rating.value - 3.0 + w[18])) * pow(stability, -w[19]);
    final clampedSinc = (rating.value >= 2) ? max(sinc, 1.0) : sinc;
    return (stability * clampedSinc).clamp(sMin, sMax);
  }

  /// Calculate next difficulty
  double nextDifficulty(double difficulty, FsrsRating rating) {
    final deltaD = -w[6] * (rating.value - 3.0);
    final linearDamped = deltaD * (10.0 - difficulty) / 9.0;
    final newD = difficulty + linearDamped;

    // Mean reversion
    final d0Good = w[4] - exp(w[5] * (4.0 - 1.0)) + 1.0;
    final reverted = w[7] * (d0Good - newD) + newD;

    return reverted.clamp(dMin, dMax);
  }

  // ========== High-level API ==========

  /// Execute a state transition step
  MemoryState step(
    MemoryState? currentState,
    FsrsRating rating,
    double elapsedDays,
  ) {
    if (currentState == null || currentState.stability == 0.0) {
      // New card
      return MemoryState(
        stability: initStability(rating),
        difficulty: initDifficulty(rating),
      );
    }

    final s = currentState.stability.clamp(sMin, sMax);
    final d = currentState.difficulty.clamp(dMin, dMax);

    double newS;
    if (elapsedDays == 0.0) {
      // Same day
      newS = stabilityShortTerm(s, rating);
    } else {
      // Cross day
      final r = forgettingCurve(elapsedDays, s);
      if (rating == FsrsRating.again) {
        newS = stabilityAfterFailure(s, d, r);
      } else {
        newS = stabilityAfterSuccess(s, d, r, rating);
      }
    }

    final newD = nextDifficulty(d, rating);

    return MemoryState(
      stability: newS.clamp(sMin, sMax),
      difficulty: newD.clamp(dMin, dMax),
    );
  }

  /// Calculate next state preview for the four buttons
  NextStates nextStates(MemoryState? currentState, double elapsedDays) {
    final ratings = [FsrsRating.again, FsrsRating.hard, FsrsRating.good, FsrsRating.easy];
    final results = ratings.map((rating) {
      final newState = step(currentState, rating, elapsedDays);
      final interval = nextInterval(newState.stability);
      return ItemState(memory: newState, interval: interval);
    }).toList();

    return NextStates(
      again: results[0],
      hard: results[1],
      good: results[2],
      easy: results[3],
    );
  }

  /// Calculate interval and round (for actual scheduling)
  int nextIntervalDays(double stability) {
    final raw = nextInterval(stability);
    return raw.round().clamp(1, maxInterval);
  }

  /// Calculate interval with deterministic fuzz
  int nextIntervalDaysWithFuzz(double stability, int seed) {
    final base = nextIntervalDays(stability);
    return fuzzIntervalDays(base, seed);
  }

  int fuzzIntervalDays(int baseInterval, int seed) {
    if (baseInterval < 3) return baseInterval;

    final double span;
    if (baseInterval < 7) {
      span = 1.0;
    } else if (baseInterval < 30) {
      span = max(1.0, baseInterval * 0.08);
    } else if (baseInterval < 90) {
      span = max(2.0, baseInterval * 0.12);
    } else {
      span = max(4.0, baseInterval * 0.15);
    }

    final random = Random(seed ^ (baseInterval * 1103515245 + 12345));
    final delta = random.nextInt(span.round() * 2 + 1) - span.round();
    return (baseInterval + delta).clamp(1, maxInterval);
  }
}
