import 'dart:math';

/// Learning queue selection results (ported from Kotlin LearningQueueManager)
abstract class QueueSelectionResult<T> {
  const QueueSelectionResult();
}

class QueueNext<T> extends QueueSelectionResult<T> {
  final int index;
  final T item;
  QueueNext(this.index, this.item);
}

class QueueWait<T> extends QueueSelectionResult<T> {
  final int waitingUntil;
  QueueWait(this.waitingUntil);
}

class QueueEmpty<T> extends QueueSelectionResult<T> {
  QueueEmpty();
}

class LearningQueueManager {
  const LearningQueueManager();

  /// Select the next item from [items].
  ///
  /// [getDueTime] should return the due timestamp in milliseconds for an item.
  QueueSelectionResult<T> selectNextItem<T>(
    List<T> items,
    int Function(T) getDueTime,
    int now,
    int learnAheadLimitMs, {
    int preferredIndex = 0,
  }) {
    if (items.isEmpty) return QueueEmpty<T>();

    int bestIndex = 0;
    int minDueTime = 1 << 62; // large sentinel

    for (var i = 0; i < items.length; i++) {
      final due = getDueTime(items[i]);
      if (due < minDueTime) {
        minDueTime = due;
        bestIndex = i;
      } else if (due == minDueTime) {
        if (i >= preferredIndex && bestIndex < preferredIndex) {
          bestIndex = i;
        }
      }
    }

    if (minDueTime > now) {
      final waitTime = minDueTime - now;
      if (waitTime > learnAheadLimitMs) {
        return QueueWait<T>(minDueTime);
      }
      // otherwise allow "learn ahead"
    }

    return QueueNext<T>(bestIndex, items[bestIndex]);
  }
}
