import SwiftUI

struct MealPlanView: View {
    var meals = [
        ("Avocado Salmon Salad", 450, 30, 20, 15),
        ("Chicken Pesto Pasta", 600, 40, 50, 18),
        ("Greek Yogurt Parfait", 300, 20, 35, 5)
    ]

    var body: some View {
        List(meals, id: \\.0) { meal in
            VStack(alignment: .leading) {
                Text(meal.0)
                    .font(.headline)
                Text("Calories: \\(meal.1) | Protein: \\(meal.2)g | Carbs: \\(meal.3)g | Fat: \\(meal.4)g")
                    .font(.subheadline)
            }
            .padding()
        }
        .navigationTitle("Today's Meal Plan")
    }
}
