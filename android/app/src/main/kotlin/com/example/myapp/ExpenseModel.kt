package com.example.myapp

import java.util.Date

/**
 * A data class to represent a single expense.
 * This is part of the native Android model layer.
 */
data class Expense(
    val id: String,
    val title: String,
    val amount: Double,
    val date: Date
)
