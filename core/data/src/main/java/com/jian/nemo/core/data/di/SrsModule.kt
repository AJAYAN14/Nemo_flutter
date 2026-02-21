package com.jian.nemo.core.data.di

import com.jian.nemo.core.domain.service.SrsCalculator
import dagger.Binds
import dagger.Module
import dagger.hilt.InstallIn
import dagger.hilt.components.SingletonComponent
import javax.inject.Singleton

/**
 * Hilt 模块: 提供 SRS 算法实例
 *
 * 使用 @Binds 绑定接口和实现，便于未来替换算法
 *
 * 参考: 实施计划 05-SRS算法实现.md Step 4
 */
@Module
@InstallIn(SingletonComponent::class)
abstract class SrsModule {

    /**
     *提供 SrsCalculator 实例
     *
     * 使用 SmTwoSrsCalculator 作为默认实现
     * 如果未来需要切换算法（如SM-15），只需修改此绑定
     */
    @Binds
    @Singleton
    abstract fun bindSrsCalculator(
        implementation: com.jian.nemo.core.domain.algorithm.SrsCalculatorImpl
    ): SrsCalculator
}
