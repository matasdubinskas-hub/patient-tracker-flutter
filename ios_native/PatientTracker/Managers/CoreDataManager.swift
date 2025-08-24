import Foundation
import CoreData

class CoreDataManager {
    static let shared = CoreDataManager()
    
    private init() {}
    
    // MARK: - Core Data Stack
    
    lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "PatientTracker")
        container.loadPersistentStores { [weak self] _, error in
            if let error = error as NSError? {
                print("Core Data error: \(error), \(error.userInfo)")
                fatalError("Core Data error: \(error), \(error.userInfo)")
            }
        }
        return container
    }()
    
    var context: NSManagedObjectContext {
        return persistentContainer.viewContext
    }
    
    // MARK: - Core Data Saving
    
    func saveContext() {
        let context = persistentContainer.viewContext
        
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                let nsError = error as NSError
                print("Core Data save error: \(nsError), \(nsError.userInfo)")
                fatalError("Core Data save error: \(nsError), \(nsError.userInfo)")
            }
        }
    }
    
    // MARK: - Patient Operations
    
    func createPatient(
        name: String,
        age: Int,
        weight: Double,
        address: String,
        phoneNumber: String,
        selectedAssessmentScale: String
    ) -> Patient {
        let patient = Patient.create(
            in: context,
            name: name,
            age: age,
            weight: weight,
            address: address,
            phoneNumber: phoneNumber,
            selectedAssessmentScale: selectedAssessmentScale
        )
        saveContext()
        return patient
    }
    
    func fetchAllPatients() -> [Patient] {
        let request: NSFetchRequest<Patient> = Patient.fetchRequest()
        request.sortDescriptors = [NSSortDescriptor(keyPath: \Patient.registrationDate, ascending: false)]
        
        do {
            return try context.fetch(request)
        } catch {
            print("Error fetching patients: \(error)")
            return []
        }
    }
    
    func fetchPatient(by id: String) -> Patient? {
        let request: NSFetchRequest<Patient> = Patient.fetchRequest()
        request.predicate = NSPredicate(format: "id == %@", id)
        request.fetchLimit = 1
        
        do {
            return try context.fetch(request).first
        } catch {
            print("Error fetching patient: \(error)")
            return nil
        }
    }
    
    func searchPatients(by searchText: String) -> [Patient] {
        let request: NSFetchRequest<Patient> = Patient.fetchRequest()
        request.predicate = NSPredicate(format: "name CONTAINS[cd] %@ OR phoneNumber CONTAINS[cd] %@", searchText, searchText)
        request.sortDescriptors = [NSSortDescriptor(keyPath: \Patient.name, ascending: true)]
        
        do {
            return try context.fetch(request)
        } catch {
            print("Error searching patients: \(error)")
            return []
        }
    }
    
    func deletePatient(_ patient: Patient) {
        context.delete(patient)
        saveContext()
    }
    
    func getTotalPatientCount() -> Int {
        let request: NSFetchRequest<Patient> = Patient.fetchRequest()
        
        do {
            return try context.count(for: request)
        } catch {
            print("Error counting patients: \(error)")
            return 0
        }
    }
    
    // MARK: - Progress Entry Operations
    
    func createProgressEntry(
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
        let entry = ProgressEntry.create(
            in: context,
            for: patient,
            notes: notes,
            shoulderROM: shoulderROM,
            kneeROM: kneeROM,
            elbowROM: elbowROM,
            hipROM: hipROM,
            painLevel: painLevel,
            assessmentScale: assessmentScale,
            assessmentScore: assessmentScore
        )
        saveContext()
        return entry
    }
    
    func fetchProgressEntries(for patient: Patient) -> [ProgressEntry] {
        let request: NSFetchRequest<ProgressEntry> = ProgressEntry.fetchRequest()
        request.predicate = NSPredicate(format: "patientId == %@", patient.id)
        request.sortDescriptors = [NSSortDescriptor(keyPath: \ProgressEntry.date, ascending: true)]
        
        do {
            return try context.fetch(request)
        } catch {
            print("Error fetching progress entries: \(error)")
            return []
        }
    }
    
    func deleteProgressEntry(_ entry: ProgressEntry) {
        context.delete(entry)
        saveContext()
    }
    
    // MARK: - Assessment Scale Operations
    
    func getAvailableAssessmentScales() -> [String] {
        return [
            "Visual Analog Scale (VAS)",
            "Numeric Pain Rating Scale",
            "Oxford Knee Score",
            "Shoulder Pain and Disability Index (SPADI)",
            "Hip Disability and Osteoarthritis Outcome Score (HOOS)",
            "Quick Disabilities of Arm, Shoulder & Hand (QuickDASH)",
            "Oswestry Disability Index",
            "Neck Disability Index",
            "Custom Assessment Scale"
        ]
    }
    
    // MARK: - Utility Methods
    
    func performBackgroundTask(_ block: @escaping (NSManagedObjectContext) -> Void) {
        persistentContainer.performBackgroundTask(block)
    }
    
    func reset() {
        let entities = persistentContainer.managedObjectModel.entities
        
        for entity in entities {
            let request = NSFetchRequest<NSFetchRequestResult>(entityName: entity.name!)
            let deleteRequest = NSBatchDeleteRequest(fetchRequest: request)
            
            do {
                try context.execute(deleteRequest)
            } catch {
                print("Error resetting entity \(entity.name ?? "Unknown"): \(error)")
            }
        }
        
        saveContext()
    }
}
