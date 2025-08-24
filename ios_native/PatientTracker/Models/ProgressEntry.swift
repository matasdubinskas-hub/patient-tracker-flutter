import Foundation
import CoreData

@objc(ProgressEntry)
public class ProgressEntry: NSManagedObject {
    
}

extension ProgressEntry {
    
    @nonobjc public class func fetchRequest() -> NSFetchRequest<ProgressEntry> {
        return NSFetchRequest<ProgressEntry>(entityName: "ProgressEntry")
    }
    
    @NSManaged public var id: String
    @NSManaged public var patientId: String
    @NSManaged public var date: Date
    @NSManaged public var notes: String
    @NSManaged public var shoulderROM: Double
    @NSManaged public var kneeROM: Double
    @NSManaged public var elbowROM: Double
    @NSManaged public var hipROM: Double
    @NSManaged public var painLevel: Int32
    @NSManaged public var assessmentScale: String
    @NSManaged public var assessmentScore: Double
    @NSManaged public var patient: Patient?
    
}

// MARK: - Convenience methods
extension ProgressEntry {
    
    /// Create a new progress entry
    static func create(
        in context: NSManagedObjectContext,
        for patient: Patient,
        notes: String,
        shoulderROM: Double = 0.0,
        kneeROM: Double = 0.0,
        elbowROM: Double = 0.0,
        hipROM: Double = 0.0,
        painLevel: Int = 0,
        assessmentScale: String,
        assessmentScore: Double = 0.0
    ) -> ProgressEntry {
        let entry = ProgressEntry(context: context)
        entry.id = UUID().uuidString
        entry.patientId = patient.id
        entry.date = Date()
        entry.notes = notes
        entry.shoulderROM = shoulderROM
        entry.kneeROM = kneeROM
        entry.elbowROM = elbowROM
        entry.hipROM = hipROM
        entry.painLevel = Int32(painLevel)
        entry.assessmentScale = assessmentScale
        entry.assessmentScore = assessmentScore
        entry.patient = patient
        return entry
    }
    
    /// Formatted date string
    var formattedDate: String {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .short
        return formatter.string(from: date)
    }
    
    /// Short date string
    var shortDateString: String {
        let formatter = DateFormatter()
        formatter.dateStyle = .short
        return formatter.string(from: date)
    }
    
    /// Pain level description
    var painLevelDescription: String {
        switch painLevel {
        case 0:
            return "No Pain"
        case 1...3:
            return "Mild Pain"
        case 4...6:
            return "Moderate Pain"
        case 7...10:
            return "Severe Pain"
        default:
            return "Unknown"
        }
    }
    
    /// Overall ROM improvement indicator
    var hasROMImprovement: Bool {
        guard let previousEntry = getPreviousEntry() else { return false }
        
        let currentTotal = shoulderROM + kneeROM + elbowROM + hipROM
        let previousTotal = previousEntry.shoulderROM + previousEntry.kneeROM + previousEntry.elbowROM + previousEntry.hipROM
        
        return currentTotal > previousTotal
    }
    
    /// Get previous progress entry for comparison
    private func getPreviousEntry() -> ProgressEntry? {
        guard let patient = patient else { return nil }
        
        let entries = patient.progressEntriesArray
        guard let currentIndex = entries.firstIndex(of: self), currentIndex > 0 else { return nil }
        
        return entries[currentIndex - 1]
    }
}

extension ProgressEntry: Identifiable {
    
}
