package com.jian.nemo.feature.test.components

import androidx.compose.animation.core.animateFloatAsState
import androidx.compose.animation.core.tween
import androidx.compose.foundation.interaction.MutableInteractionSource
import androidx.compose.foundation.interaction.PressInteraction
import androidx.compose.foundation.layout.height
import androidx.compose.foundation.shape.RoundedCornerShape
import androidx.compose.material3.Button
import androidx.compose.material3.OutlinedButton
import androidx.compose.material3.Text
import androidx.compose.runtime.*
import androidx.compose.ui.Modifier
import androidx.compose.ui.draw.scale
import androidx.compose.ui.unit.dp

// 自定义函数来收集按下状态
@Composable
fun MutableInteractionSource.collectIsPressedAsState(): State<Boolean> {
    val pressed = remember { mutableStateOf(false) }

    LaunchedEffect(this) {
        this@collectIsPressedAsState.interactions.collect { interaction ->
            when (interaction) {
                is PressInteraction.Press -> pressed.value = true
                is PressInteraction.Release -> pressed.value = false
                is PressInteraction.Cancel -> pressed.value = false
            }
        }
    }

    return pressed
}

@Composable
fun AnimatedButton(
    text: String,
    onClick: () -> Unit,
    modifier: Modifier = Modifier,
    enabled: Boolean = true,
    isOutlined: Boolean = false
) {
    val interactionSource = remember { MutableInteractionSource() }
    val isPressed by interactionSource.collectIsPressedAsState()
    val scale by animateFloatAsState(
        targetValue = if (isPressed) 0.95f else 1f,
        label = "buttonScale",
        animationSpec = tween(durationMillis = 100)
    )
    val buttonModifier = modifier
        .scale(scale)
        .height(50.dp)

    if (isOutlined) {
        OutlinedButton(
            onClick = onClick,
            modifier = buttonModifier,
            shape = RoundedCornerShape(16.dp),
            enabled = enabled,
            interactionSource = interactionSource
        ) { Text(text) }
    } else {
        Button(
            onClick = onClick,
            modifier = buttonModifier,
            shape = RoundedCornerShape(16.dp),
            enabled = enabled,
            interactionSource = interactionSource
        ) { Text(text) }
    }
}
