import Foundation

// Định nghĩa struct MeasurementRecord
struct MeasurementRecord: Codable {
    let value: String
    let timestamp: String
}

class MeasurementManager {
    
    static let shared = MeasurementManager()
    
    private let userDefaults = UserDefaults.standard
    private let measurementsKey = "savedMeasurements"
    
    private init() {}
    
    func saveMeasurements(_ measurements: [MeasurementRecord]) {
        let encoder = JSONEncoder()
        if let encoded = try? encoder.encode(measurements) {
            userDefaults.set(encoded, forKey: measurementsKey)
        }
    }
    
    func loadMeasurements() -> [MeasurementRecord] {
        if let savedMeasurements = userDefaults.object(forKey: measurementsKey) as? Data {
            let decoder = JSONDecoder()
            if let loadedMeasurements = try? decoder.decode([MeasurementRecord].self, from: savedMeasurements) {
                return loadedMeasurements
            }
        }
        return []
    }
    
    func addMeasurement(_ measurement: MeasurementRecord) {
        var measurements = loadMeasurements()
        measurements.append(measurement)
        saveMeasurements(measurements)
    }
    
    func deleteMeasurement(at index: Int) {
        var measurements = loadMeasurements()
        if index >= 0 && index < measurements.count {
            measurements.remove(at: index)
            saveMeasurements(measurements)
        }
    }
    
    func clearAllMeasurements() {
        saveMeasurements([])
    }
}

