import 'dart:math';
import 'dart:typed_data';

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

  List<double> get w => parameters.map((p) => _f32(p)).toList();

  // Helper: emulate 32-bit float rounding used in Kotlin `Float` computations
  double _f32(double x) => Float32List.fromList([x])[0];

  // Helper: float32-based power using exp(log(base)*exp) with intermediate f32 rounding
  double _powf(double base, double exponent) {
    final b = _f32(base);
    final e = _f32(exponent);
    final lb = log(b);
    final prod = _f32(lb * e);
    final res = exp(prod);
    return _f32(res.toDouble());
  }

  // ========== Core Formulas ==========

  /// Power-law forgetting curve
  /// R(t, S) = (1 + factor * t/S)^(-decay)
  double forgettingCurve(double elapsedDays, double stability) {
    final decay = w[20];
    final s = _f32(stability);
    final factor = _f32(_powf(_f32(0.9), _f32(1.0 / -decay)) - 1.0);
    final eDivS = _f32(_f32(elapsedDays) / s);
    final eTimes = _f32(eDivS * factor);
    final base = _f32(eTimes + 1.0);
    final result = _f32(_powf(base, -decay));
    return result;
  }

  /// Calculate optimal next interval
  /// I(S, R) = S / factor * (R^(1/-decay) - 1)
  double nextInterval(double stability, {double? retention}) {
    final r = retention ?? desiredRetention;
    final decay = w[20];
    final s = _f32(stability);
    final factor = _f32(_powf(_f32(0.9), _f32(1.0 / -decay)) - 1.0);
    final tmp = _f32(s / factor);
    final powR = _f32(_powf(r, 1.0 / -decay) - 1.0);
    final result = _f32(tmp * powR);
    return result;
  }

  /// Initial stability for a new card
  double initStability(FsrsRating rating) {
    return _f32(w[rating.value - 1].clamp(sMin, sMax));
  }

  /// Initial difficulty for a new card
  double initDifficulty(FsrsRating rating) {
    final expTerm = _f32(exp(w[5] * (rating.value - 1.0)));
    final a = _f32(w[4] - expTerm);
    final b = _f32(a + 1.0);
    final clamped = b.clamp(dMin, dMax);
    return _f32(clamped);
  }

  /// New stability after success
  double stabilityAfterSuccess(
    double stability,
    double difficulty,
    double retrievability,
    FsrsRating rating,
  ) {
    final s = _f32(stability);
    final d = _f32(difficulty);
    final r = _f32(retrievability);
    final hardPenalty = (rating == FsrsRating.hard) ? w[15] : 1.0;
    final easyBonus = (rating == FsrsRating.easy) ? w[16] : 1.0;
    // Match Kotlin: apply toFloat() at exp(...) sites and perform left-to-right
    // float32 rounding across the multiplication chain.
    final expW8 = _f32(exp(w[8]));
    final elevenMinusD = _f32(11.0 - d);
    final step1 = _f32(expW8 * elevenMinusD);
    final powStab = _f32(_powf(s, -w[9]));
    final step2 = _f32(step1 * powStab);
    final inner = _f32((1.0 - r) * w[10]);
    final expTerm = _f32(exp(inner).toDouble());
    final diffExp = _f32(expTerm - 1.0);
    final step3 = _f32(step2 * diffExp);
    final step4 = _f32(step3 * hardPenalty);
    final step5 = _f32(step4 * easyBonus);
    final inside = _f32(step5 + 1.0);
    final newS = _f32(s * inside);
    return _f32(newS.clamp(sMin, sMax));
  }

  /// New stability after failure
  double stabilityAfterFailure(
    double stability,
    double difficulty,
    double retrievability,
  ) {
    final s = _f32(stability);
    final d = _f32(difficulty);
    final r = _f32(retrievability);

    // Compute exp term with f32 inner arg
    final expInner = _f32(_f32(1.0 - r) * _f32(w[14]));
    final expTerm = _f32(exp(expInner).toDouble());

    // pow terms: quantize bases before pow to mimic Kotlin Float.pow behavior
    final pow1 = _f32(_powf(_f32(d), -w[12]));
    final pow2raw = _f32(_powf(_f32(s + 1.0), w[13]));
    final pow2 = _f32(pow2raw - 1.0);

    final a1 = _f32(_f32(w[11]) * _f32(pow1));
    final a2 = _f32(_f32(a1) * _f32(pow2));
    final a3 = _f32(_f32(a2) * _f32(expTerm));
    final newS = a3;

    // Minimum constraint: stability after failure must not be lower than S / exp(w[17]*w[18])
    final minExpArg = _f32(_f32(w[17]) * _f32(w[18]));
    final minS = _f32(s / _f32(exp(minExpArg).toDouble()));

    return _f32(max(newS, minS).clamp(sMin, sMax));
  }

  /// Short-term stability (for same-day learning steps)
  double stabilityShortTerm(double stability, FsrsRating rating) {
    final s = _f32(stability);
    // Match Kotlin float evaluation order: compute inner arg as f32, then exp->f32,
    // compute pow term as f32, then multiply as f32.
    final innerArg = _f32(_f32(w[17]) * _f32(rating.value - 3.0 + w[18]));
    final expTerm = _f32(exp(innerArg).toDouble());
    final powTerm = _f32(_powf(s, -w[19]));
    final sinc = _f32(_f32(expTerm) * _f32(powTerm));
    final clampedSinc = (rating.value >= 2) ? max(sinc, 1.0) : sinc;
    final newS = _f32(s * clampedSinc);
    return _f32(newS.clamp(sMin, sMax));
  }

  /// Calculate next difficulty
  double nextDifficulty(double difficulty, FsrsRating rating) {
    final d = _f32(difficulty);
    final deltaD = _f32(-w[6] * (rating.value - 3.0));
    final linearDamped = _f32(deltaD * (10.0 - d) / 9.0);
    final newD = _f32(d + linearDamped);

    // Mean reversion
    final expTerm = _f32(exp(w[5] * (4.0 - 1.0)));
    final d0Good = _f32(w[4] - expTerm);
    final d0GoodPlus = _f32(d0Good + 1.0);
    final diff = _f32(d0GoodPlus - newD);
    final reverted = _f32(_f32(w[7] * diff) + newD);

    return _f32(reverted.clamp(dMin, dMax));
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

    final s = _f32(currentState.stability.clamp(sMin, sMax));
    final d = _f32(currentState.difficulty.clamp(dMin, dMax));

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
      stability: _f32(newS.clamp(sMin, sMax)),
      difficulty: _f32(newD.clamp(dMin, dMax)),
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
