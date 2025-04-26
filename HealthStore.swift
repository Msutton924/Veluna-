import Foundation
import HealthKit

class HealthStore: ObservableObject {
    private var healthStore: HKHealthStore?

    @Published var weight: Double = 0.0
    @Published var activeEnergy: Double = 0.0

    init() {
        if HKHealthStore.isHealthDataAvailable() {
            healthStore = HKHealthStore()
            requestAuthorization()
        }
    }

    func requestAuthorization() {
        let toRead = Set([
            HKObjectType.quantityType(forIdentifier: .bodyMass)!,
            HKObjectType.quantityType(forIdentifier: .activeEnergyBurned)!
        ])

        healthStore?.requestAuthorization(toShare: nil, read: toRead) { success, error in
            if success {
                self.fetchWeight()
                self.fetchActiveEnergy()
            }
        }
    }

    func fetchWeight() {
        guard let weightType = HKSampleType.quantityType(forIdentifier: .bodyMass) else { return }

        let query = HKSampleQuery(sampleType: weightType, predicate: nil, limit: 1, sortDescriptors: [NSSortDescriptor(key: HKSampleSortIdentifierEndDate, ascending: false)]) { _, results, _ in
            if let result = results?.first as? HKQuantitySample {
                DispatchQueue.main.async {
                    self.weight = result.quantity.doubleValue(for: HKUnit.gramUnit(with: .kilo))
                }
            }
        }
        healthStore?.execute(query)
    }

    func fetchActiveEnergy() {
        guard let energyType = HKSampleType.quantityType(forIdentifier: .activeEnergyBurned) else { return }

        let query = HKStatisticsQuery(quantityType: energyType, quantitySamplePredicate: nil, options: .cumulativeSum) { _, result, _ in
            if let sum = result?.sumQuantity() {
                DispatchQueue.main.async {
                    self.activeEnergy = sum.doubleValue(for: HKUnit.kilocalorie())
                }
            }
        }
        healthStore?.execute(query)
    }
}
