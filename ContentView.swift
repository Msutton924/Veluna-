import SwiftUI

struct ContentView: View {
    @EnvironmentObject var healthStore: HealthStore
    @State private var selectedGoal: String? = nil

    let goals = ["Lose Weight", "Gain Muscle", "Get in Shape"]

    var body: some View {
        NavigationView {
            VStack(spacing: 20) {
                Text("Select Your Goal")
                    .font(.largeTitle)

                ForEach(goals, id: \\.self) { goal in
                    Button(action: {
                        selectedGoal = goal
                    }) {
                        Text(goal)
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(selectedGoal == goal ? Color.blue : Color.gray.opacity(0.3))
                            .foregroundColor(.white)
                            .cornerRadius(10)
                    }
                }

                NavigationLink(destination: MealPlanView(), isActive: Binding(
                    get: { selectedGoal != nil },
                    set: { _ in }
                )) {
                    Text("Continue")
                        .font(.headline)
                        .padding()
                        .background(Color.green)
                        .foregroundColor(.white)
                        .cornerRadius(10)
                }
                .padding(.top, 40)

                Spacer()
            }
            .padding()
        }
    }
}
