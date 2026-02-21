package com.jian.nemo.core.ui.component

import android.graphics.Bitmap
import android.view.View
import androidx.compose.animation.core.Animatable
import androidx.compose.animation.core.FastOutSlowInEasing
import androidx.compose.animation.core.tween
import androidx.compose.foundation.Canvas
import androidx.compose.foundation.layout.fillMaxSize
import androidx.compose.runtime.*
import androidx.compose.ui.Modifier
import androidx.compose.ui.graphics.drawscope.drawIntoCanvas
import androidx.compose.ui.graphics.nativeCanvas
import androidx.compose.ui.platform.LocalView
import kotlin.math.hypot
import kotlin.math.max

/**
 * 主题切换动画触发参数
 *
 * @param centerX 动画展开中心 X 坐标（像素）
 * @param centerY 动画展开中心 Y 坐标（像素）
 * @param timestamp 触发时间戳，用于区分多次独立触发
 */
data class ThemeTransitionTrigger(
    val centerX: Float,
    val centerY: Float,
    val timestamp: Long = System.currentTimeMillis()
)

/**
 * CompositionLocal：主题切换动画触发回调
 *
 * 由 MainActivity 提供，SettingsScreen 在用户点击主题切换按钮时调用，
 * 传递点击坐标以触发渐变波纹动画。
 */
val LocalThemeTransitionTrigger = staticCompositionLocalOf<((Float, Float) -> Unit)?> { null }

/**
 * 主题切换渐变波纹覆盖层
 *
 * 工作原理：
 * 1. 当 [trigger] 不为 null 时，对当前屏幕截图
 * 2. 截图作为覆盖层显示在最上方
 * 3. 使用 RadialGradient + PorterDuff.DST_IN 从中心向外做渐变透明动画
 * 4. 动画结束后调用 [onTransitionComplete] 并清理资源
 *
 * @param trigger 动画触发参数，为 null 时不显示覆盖层
 * @param onTransitionComplete 动画完成后的回调
 * @param durationMs 动画持续时间（毫秒）
 * @param gradientEdgeWidth 渐变边缘宽度（像素），控制波纹边缘的柔和程度
 */
@Composable
fun ThemeTransitionOverlay(
    trigger: ThemeTransitionTrigger?,
    onScreenshotCaptured: () -> Unit = {},
    onTransitionComplete: () -> Unit,
    durationMs: Int = 600,
    gradientEdgeWidth: Float = 200f
) {
    val view = LocalView.current

    // 保存截图的 Bitmap
    var screenshotBitmap by remember { mutableStateOf<Bitmap?>(null) }

    // 动画进度：0f = 完全遮盖旧主题，1f = 完全揭示新主题
    val animationProgress = remember { Animatable(0f) }

    // 当前正在处理的 trigger 时间戳，防止重复处理
    var currentTimestamp by remember { mutableStateOf(0L) }

    // 监听 trigger 变化
    LaunchedEffect(trigger) {
        if (trigger != null && trigger.timestamp != currentTimestamp) {
            currentTimestamp = trigger.timestamp

            // 1. 截图当前屏幕（同步，在主线程安全执行）
            val bitmap = captureViewToBitmap(view)
            if (bitmap != null) {
                screenshotBitmap = bitmap

                // 2. 通知截图完成，可以切换底层主题
                onScreenshotCaptured()

                // 3. 重置动画进度
                animationProgress.snapTo(0f)

                // 3. 启动渐变波纹动画
                animationProgress.animateTo(
                    targetValue = 1f,
                    animationSpec = tween(
                        durationMillis = durationMs,
                        easing = FastOutSlowInEasing
                    )
                )

                // 4. 动画完成，清理
                screenshotBitmap = null
                bitmap.recycle()
                onTransitionComplete()
            } else {
                // 截图失败，直接完成
                onTransitionComplete()
            }
        }
    }

    // 渲染截图覆盖层 + 渐变遮罩
    val bitmap = screenshotBitmap
    if (bitmap != null && trigger != null && !bitmap.isRecycled) {
        val progress = animationProgress.value

        Canvas(modifier = Modifier.fillMaxSize()) {
            val canvasWidth = size.width
            val canvasHeight = size.height
            val cx = trigger.centerX
            val cy = trigger.centerY

            // 计算从中心到四个角的最大距离，作为动画终止半径
            val maxRadius = maxDistanceToCorner(cx, cy, canvasWidth, canvasHeight)

            // 当前动画半径（含渐变边缘区域）
            val currentRadius = maxRadius * progress + gradientEdgeWidth

            // 内部完全透明区域的边界半径
            val innerRadius = max(0f, currentRadius - gradientEdgeWidth)
            val safeCurrentRadius = max(currentRadius, 1f)

            drawIntoCanvas { canvas ->
                val nativeCanvas = canvas.nativeCanvas

                // 使用 saveLayer 隔离混合操作
                val saveCount = nativeCanvas.saveLayer(
                    0f, 0f, canvasWidth, canvasHeight, null
                )

                // 先绘制截图（旧主题画面）
                val srcRect = android.graphics.Rect(0, 0, bitmap.width, bitmap.height)
                val dstRect = android.graphics.RectF(0f, 0f, canvasWidth, canvasHeight)
                nativeCanvas.drawBitmap(bitmap, srcRect, dstRect, null)

                // 使用 PorterDuff.DST_IN 模式 + RadialGradient 做渐变遮罩
                // DST_IN: 保留目标（截图）中与源（渐变）重叠的部分，使用源的 alpha
                val maskPaint = android.graphics.Paint().apply {
                    isAntiAlias = true
                    xfermode = android.graphics.PorterDuffXfermode(
                        android.graphics.PorterDuff.Mode.DST_IN
                    )
                    shader = android.graphics.RadialGradient(
                        cx, cy,
                        safeCurrentRadius,
                        intArrayOf(
                            android.graphics.Color.TRANSPARENT,  // 中心：透明 → 新主题可见
                            android.graphics.Color.TRANSPARENT,  // 到 innerRadius 为止都透明
                            android.graphics.Color.WHITE,        // 渐变过渡区
                            android.graphics.Color.WHITE         // 外部：完全不透明 → 保留截图
                        ),
                        floatArrayOf(
                            0f,
                            innerRadius / safeCurrentRadius,
                            currentRadius / safeCurrentRadius,
                            1f
                        ),
                        android.graphics.Shader.TileMode.CLAMP
                    )
                }

                nativeCanvas.drawRect(0f, 0f, canvasWidth, canvasHeight, maskPaint)
                nativeCanvas.restoreToCount(saveCount)
            }
        }
    }
}

/**
 * 计算从指定中心点到矩形四个角的最大距离
 */
private fun maxDistanceToCorner(
    cx: Float, cy: Float,
    width: Float, height: Float
): Float {
    val d1 = hypot(cx.toDouble(), cy.toDouble())
    val d2 = hypot((width - cx).toDouble(), cy.toDouble())
    val d3 = hypot(cx.toDouble(), (height - cy).toDouble())
    val d4 = hypot((width - cx).toDouble(), (height - cy).toDouble())
    return maxOf(d1, d2, d3, d4).toFloat()
}

/**
 * 对 View 进行截图
 *
 * 使用 View.draw() 绘制到 Canvas 上生成 Bitmap
 */
private fun captureViewToBitmap(view: View): Bitmap? {
    return try {
        val width = view.width
        val height = view.height
        if (width <= 0 || height <= 0) return null

        val bitmap = Bitmap.createBitmap(width, height, Bitmap.Config.ARGB_8888)
        val canvas = android.graphics.Canvas(bitmap)
        view.draw(canvas)
        bitmap
    } catch (e: Exception) {
        e.printStackTrace()
        null
    }
}
