import UIKit

class PatientLibraryViewController: UIViewController {
    
    // MARK: - Outlets
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var emptyStateView: UIView!
    @IBOutlet weak var emptyStateLabel: UILabel!
    
    // MARK: - Properties
    private let coreDataManager = CoreDataManager.shared
    private var patients: [Patient] = []
    private var filteredPatients: [Patient] = []
    private var isSearching = false
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupTableView()
        setupSearchBar()
        loadPatients()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        loadPatients()
        navigationController?.setNavigationBarHidden(false, animated: animated)
    }
    
    // MARK: - UI Setup
    private func setupUI() {
        title = "Patient Library"
        view.backgroundColor = .systemGroupedBackground
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(
            barButtonSystemItem: .add,
            target: self,
            action: #selector(addPatientTapped)
        )
        
        setupEmptyState()
    }
    
    private func setupTableView() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.backgroundColor = .systemGroupedBackground
        tableView.separatorStyle = .none
        tableView.showsVerticalScrollIndicator = true
        
        // Register custom cell
        tableView.register(PatientTableViewCell.self, forCellReuseIdentifier: "PatientCell")
    }
    
    private func setupSearchBar() {
        searchBar.delegate = self
        searchBar.placeholder = "Search patients..."
        searchBar.searchBarStyle = .minimal
        searchBar.backgroundColor = .systemGroupedBackground
    }
    
    private func setupEmptyState() {
        emptyStateView.backgroundColor = .systemGroupedBackground
        
        emptyStateLabel.text = "No patients registered yet.\nTap the + button to add your first patient."
        emptyStateLabel.font = .systemFont(ofSize: 18, weight: .medium)
        emptyStateLabel.textColor = .secondaryLabel
        emptyStateLabel.textAlignment = .center
        emptyStateLabel.numberOfLines = 0
    }
    
    // MARK: - Data Loading
    private func loadPatients() {
        patients = coreDataManager.fetchAllPatients()
        updateFilteredPatients()
        updateUI()
    }
    
    private func updateFilteredPatients() {
        if isSearching, let searchText = searchBar.text, !searchText.isEmpty {
            filteredPatients = coreDataManager.searchPatients(by: searchText)
        } else {
            filteredPatients = patients
            isSearching = false
        }
        
        DispatchQueue.main.async { [weak self] in
            self?.tableView.reloadData()
        }
    }
    
    private func updateUI() {
        let isEmpty = patients.isEmpty
        emptyStateView.isHidden = !isEmpty
        tableView.isHidden = isEmpty
        searchBar.isHidden = isEmpty
        
        if isEmpty {
            navigationItem.rightBarButtonItem?.title = "Add First Patient"
        } else {
            navigationItem.rightBarButtonItem?.title = nil
        }
    }
    
    // MARK: - Actions
    @objc private func addPatientTapped() {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        if let vc = storyboard.instantiateViewController(withIdentifier: "PatientRegistrationViewController") as? PatientRegistrationViewController {
            let navController = UINavigationController(rootViewController: vc)
            navController.modalPresentationStyle = .fullScreen
            present(navController, animated: true)
        }
    }
    
    // MARK: - Navigation
    private func showPatientDetail(patient: Patient) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        if let vc = storyboard.instantiateViewController(withIdentifier: "PatientDetailViewController") as? PatientDetailViewController {
            vc.patient = patient
            navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    // MARK: - Patient Actions
    private func showPatientActionSheet(for patient: Patient, at indexPath: IndexPath) {
        let alert = UIAlertController(title: patient.name, message: nil, preferredStyle: .actionSheet)
        
        let viewAction = UIAlertAction(title: "View Details", style: .default) { [weak self] _ in
            self?.showPatientDetail(patient: patient)
        }
        
        let editAction = UIAlertAction(title: "Edit Patient", style: .default) { [weak self] _ in
            self?.editPatient(patient)
        }
        
        let deleteAction = UIAlertAction(title: "Delete Patient", style: .destructive) { [weak self] _ in
            self?.confirmDeletePatient(patient, at: indexPath)
        }
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel)
        
        alert.addAction(viewAction)
        alert.addAction(editAction)
        alert.addAction(deleteAction)
        alert.addAction(cancelAction)
        
        // For iPad
        if let popover = alert.popoverPresentationController {
            if let cell = tableView.cellForRow(at: indexPath) {
                popover.sourceView = cell
                popover.sourceRect = cell.bounds
            }
        }
        
        present(alert, animated: true)
    }
    
    private func editPatient(_ patient: Patient) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        if let vc = storyboard.instantiateViewController(withIdentifier: "PatientRegistrationViewController") as? PatientRegistrationViewController {
            vc.existingPatient = patient
            let navController = UINavigationController(rootViewController: vc)
            navController.modalPresentationStyle = .fullScreen
            present(navController, animated: true)
        }
    }
    
    private func confirmDeletePatient(_ patient: Patient, at indexPath: IndexPath) {
        let alert = UIAlertController(
            title: "Delete Patient",
            message: "Are you sure you want to delete \(patient.name)? This action cannot be undone.",
            preferredStyle: .alert
        )
        
        let deleteAction = UIAlertAction(title: "Delete", style: .destructive) { [weak self] _ in
            self?.deletePatient(patient, at: indexPath)
        }
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel)
        
        alert.addAction(deleteAction)
        alert.addAction(cancelAction)
        
        present(alert, animated: true)
    }
    
    private func deletePatient(_ patient: Patient, at indexPath: IndexPath) {
        coreDataManager.deletePatient(patient)
        
        // Remove from arrays
        if let index = patients.firstIndex(of: patient) {
            patients.remove(at: index)
        }
        if let index = filteredPatients.firstIndex(of: patient) {
            filteredPatients.remove(at: index)
        }
        
        // Update table view
        tableView.deleteRows(at: [indexPath], with: .fade)
        updateUI()
        
        // Show success message
        let successAlert = UIAlertController(
            title: "Patient Deleted",
            message: "\(patient.name) has been removed from the system.",
            preferredStyle: .alert
        )
        successAlert.addAction(UIAlertAction(title: "OK", style: .default))
        present(successAlert, animated: true)
    }
}

// MARK: - UITableViewDataSource
extension PatientLibraryViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return filteredPatients.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "PatientCell", for: indexPath) as! PatientTableViewCell
        let patient = filteredPatients[indexPath.row]
        cell.configure(with: patient)
        return cell
    }
}

// MARK: - UITableViewDelegate
extension PatientLibraryViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let patient = filteredPatients[indexPath.row]
        showPatientDetail(patient: patient)
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let patient = filteredPatients[indexPath.row]
        
        let deleteAction = UIContextualAction(style: .destructive, title: "Delete") { [weak self] _, _, completion in
            self?.confirmDeletePatient(patient, at: indexPath)
            completion(true)
        }
        
        let editAction = UIContextualAction(style: .normal, title: "Edit") { [weak self] _, _, completion in
            self?.editPatient(patient)
            completion(true)
        }
        editAction.backgroundColor = .systemBlue
        
        let moreAction = UIContextualAction(style: .normal, title: "More") { [weak self] _, _, completion in
            self?.showPatientActionSheet(for: patient, at: indexPath)
            completion(true)
        }
        moreAction.backgroundColor = .systemGray
        
        return UISwipeActionsConfiguration(actions: [deleteAction, editAction, moreAction])
    }
}

// MARK: - UISearchBarDelegate
extension PatientLibraryViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        isSearching = !searchText.isEmpty
        updateFilteredPatients()
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.text = ""
        searchBar.resignFirstResponder()
        isSearching = false
        updateFilteredPatients()
    }
}

// MARK: - Custom Patient Cell
class PatientTableViewCell: UITableViewCell {
    
    private let cardView = UIView()
    private let nameLabel = UILabel()
    private let detailsLabel = UILabel()
    private let dateLabel = UILabel()
    private let assessmentLabel = UILabel()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupUI()
    }
    
    private func setupUI() {
        backgroundColor = .clear
        selectionStyle = .none
        
        // Card view
        cardView.backgroundColor = .systemBackground
        cardView.layer.cornerRadius = 12
        cardView.layer.shadowColor = UIColor.black.cgColor
        cardView.layer.shadowOffset = CGSize(width: 0, height: 2)
        cardView.layer.shadowRadius = 4
        cardView.layer.shadowOpacity = 0.1
        
        // Name label
        nameLabel.font = .systemFont(ofSize: 18, weight: .bold)
        nameLabel.textColor = .label
        
        // Details label
        detailsLabel.font = .systemFont(ofSize: 14, weight: .medium)
        detailsLabel.textColor = .secondaryLabel
        
        // Date label
        dateLabel.font = .systemFont(ofSize: 12, weight: .regular)
        dateLabel.textColor = .tertiaryLabel
        
        // Assessment label
        assessmentLabel.font = .systemFont(ofSize: 12, weight: .medium)
        assessmentLabel.textColor = .systemBlue
        assessmentLabel.numberOfLines = 2
        
        // Add subviews
        contentView.addSubview(cardView)
        cardView.addSubview(nameLabel)
        cardView.addSubview(detailsLabel)
        cardView.addSubview(dateLabel)
        cardView.addSubview(assessmentLabel)
        
        // Setup constraints
        setupConstraints()
    }
    
    private func setupConstraints() {
        [cardView, nameLabel, detailsLabel, dateLabel, assessmentLabel].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
        }
        
        NSLayoutConstraint.activate([
            // Card view
            cardView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            cardView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            cardView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 8),
            cardView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -8),
            
            // Name label
            nameLabel.leadingAnchor.constraint(equalTo: cardView.leadingAnchor, constant: 16),
            nameLabel.topAnchor.constraint(equalTo: cardView.topAnchor, constant: 12),
            nameLabel.trailingAnchor.constraint(equalTo: dateLabel.leadingAnchor, constant: -8),
            
            // Details label
            detailsLabel.leadingAnchor.constraint(equalTo: cardView.leadingAnchor, constant: 16),
            detailsLabel.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 4),
            detailsLabel.trailingAnchor.constraint(equalTo: cardView.trailingAnchor, constant: -16),
            
            // Date label
            dateLabel.trailingAnchor.constraint(equalTo: cardView.trailingAnchor, constant: -16),
            dateLabel.topAnchor.constraint(equalTo: cardView.topAnchor, constant: 12),
            dateLabel.widthAnchor.constraint(greaterThanOrEqualToConstant: 80),
            
            // Assessment label
            assessmentLabel.leadingAnchor.constraint(equalTo: cardView.leadingAnchor, constant: 16),
            assessmentLabel.trailingAnchor.constraint(equalTo: cardView.trailingAnchor, constant: -16),
            assessmentLabel.topAnchor.constraint(equalTo: detailsLabel.bottomAnchor, constant: 8),
            assessmentLabel.bottomAnchor.constraint(lessThanOrEqualTo: cardView.bottomAnchor, constant: -12)
        ])
    }
    
    func configure(with patient: Patient) {
        nameLabel.text = patient.name
        detailsLabel.text = "Age: \(patient.age) • Weight: \(String(format: "%.1f", patient.weight))kg • 📞 \(patient.phoneNumber)"
        dateLabel.text = patient.formattedRegistrationDate
        assessmentLabel.text = "Assessment: \(patient.selectedAssessmentScale)"
    }
}
