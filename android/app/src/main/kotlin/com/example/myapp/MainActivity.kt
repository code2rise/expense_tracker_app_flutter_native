package com.example.myapp

import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel
import java.util.Date
import java.text.SimpleDateFormat

class MainActivity: FlutterActivity() {
    private val CHANNEL = "com.example.myapp/expenses"

    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)
        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, CHANNEL).setMethodCallHandler {
            call, result ->
            if (call.method == "getExpenses") {
                val expenses = getExpensesFromNative()
                result.success(expenses)
            } else {
                result.notImplemented()
            }
        }
    }

    private fun getExpensesFromNative(): List<Map<String, Any>> {
        // In a real app, this would fetch data from a database or API
        val dateFormat = SimpleDateFormat("yyyy-MM-dd'T'HH:mm:ss.SSS'Z'")
        val dummyExpenses = listOf(
            Expense(id = "1", title = "Native Groceries", amount = 850.50, date = Date()),
            Expense(id = "2", title = "Native Coffee", amount = 150.00, date = Date()),
            Expense(id = "3", title = "Native Movie", amount = 1200.00, date = Date())
        )

        return dummyExpenses.map { expense ->
            mapOf(
                "id" to expense.id,
                "title" to expense.title,
                "amount" to expense.amount,
                "date" to dateFormat.format(expense.date) // Dates need to be serialized
            )
        }
    }
}
