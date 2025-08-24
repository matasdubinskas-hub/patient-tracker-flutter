import Foundation
import CoreData

@objc(Patient)
public class Patient: NSManagedObject {
    
}

extension Patient {
    
    @nonobjc public class func fetchRequest() -> NSFetchRequest<Patient> {
        return NSFetchRequest<Patient>(entityName: "Patient")
    }
    
    @NSManaged public var id: String
    @NSManaged public var name: String
    @NSManaged public var age: Int32
    @NSManaged public var weight: Double
    @NSManaged public var address: String
    @NSManaged public var phoneNumber: String
    @NSManaged public var registrationDate: Date
    @NSManaged public var selectedAssessmentScale: String
    @NSManaged public var shoulderROM: Double
    @NSManaged public var kneeROM: Double
    @NSManaged public var elbowROM: Double
    @NSManaged public var hipROM: Double
    @NSManaged public var progressEntries: NSSet?
    
}

// MARK: Generated accessors for progressEntries
extension Patient {
    
    @objc(addProgressEntriesObject:)
    @NSManaged public func addToProgressEntries(_ value: ProgressEntry)
    
    @objc(removeProgressEntriesObject:)
    @NSManaged public func removeFromProgressEntries(_ value: ProgressEntry)
    
    @objc(addProgressEntries:)
    @NSManaged public func addToProgressEntries(_ values: NSSet)
    
    @objc(removeProgressEntries:)
    @NSManaged public func removeFromProgressEntries(_ values: NSSet)
    
}

// MARK: - Convenience methods
extension Patient {
    
    /// Create a new patient with the given parameters
    static func create(
        in context: NSManagedObjectContext,
        id: String = UUID().uuidString,
        name: String,
        age: Int,
        weight: Double,
        address: String,
        phoneNumber: String,
        selectedAssessmentScale: String,
        shoulderROM: Double = 0.0,
        kneeROM: Double = 0.0,
        elbowROM: Double = 0.0,
        hipROM: Double = 0.0
    ) -> Patient {
        let patient = Patient(context: context)
        patient.id = id
        patient.name = name
        patient.age = Int32(age)
        patient.weight = weight
        patient.address = address
        patient.phoneNumber = phoneNumber
        patient.registrationDate = Date()
        patient.selectedAssessmentScale = selectedAssessmentScale
        patient.shoulderROM = shoulderROM
        patient.kneeROM = kneeROM
        patient.elbowROM = elbowROM
        patient.hipROM = hipROM
        return patient
    }
    
    /// Update patient ROM values
    func updateROM(
        shoulder: Double? = nil,
        knee: Double? = nil,
        elbow: Double? = nil,
        hip: Double? = nil
    ) {
        if let shoulder = shoulder { self.shoulderROM = shoulder }
        if let knee = knee { self.kneeROM = knee }
        if let elbow = elbow { self.elbowROM = elbow }
        if let hip = hip { self.hipROM = hip }
    }
    
    /// Get formatted registration date
    var formattedRegistrationDate: String {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .none
        return formatter.string(from: registrationDate)
    }
    
    /// Get progress entries as array
    var progressEntriesArray: [ProgressEntry] {
        let set = progressEntries as? Set<ProgressEntry> ?? []
        return set.sorted { $0.date < $1.date }
    }
    
    /// Get latest progress entry
    var latestProgressEntry: ProgressEntry? {
        return progressEntriesArray.last
    }
}

extension Patient: Identifiable {
    
}
