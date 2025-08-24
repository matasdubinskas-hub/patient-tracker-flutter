import UIKit

class DashboardViewController: UIViewController {
    
    // MARK: - Outlets
    @IBOutlet weak var appIconImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var subtitleLabel: UILabel!
    @IBOutlet weak var registerPatientButton: UIButton!
    @IBOutlet weak var patientLibraryButton: UIButton!
    @IBOutlet weak var statisticsView: UIView!
    @IBOutlet weak var patientCountLabel: UILabel!
    
    // MARK: - Properties
    private let coreDataManager = CoreDataManager.shared
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        updatePatientCount()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        updatePatientCount()
        navigationController?.setNavigationBarHidden(true, animated: animated)
    }
    
    // MARK: - UI Setup
    private func setupUI() {
        view.backgroundColor = UIColor.systemGray6
        
        setupAppHeader()
        setupActionButtons()
        setupStatisticsView()
    }
    
    private func setupAppHeader() {
        // App icon container
        appIconImageView.backgroundColor = UIColor.systemBlue.withAlphaComponent(0.1)
        appIconImageView.layer.cornerRadius = 20
        appIconImageView.image = UIImage(systemName: "heart.text.square.fill")
        appIconImageView.tintColor = .systemBlue
        appIconImageView.contentMode = .scaleAspectFit
        
        // Title
        titleLabel.text = "Patient Tracker"
        titleLabel.font = .systemFont(ofSize: 28, weight: .bold)
        titleLabel.textColor = .label
        titleLabel.textAlignment = .center
        
        // Subtitle
        subtitleLabel.text = "Physiotherapy Progress Management"
        subtitleLabel.font = .systemFont(ofSize: 16, weight: .regular)
        subtitleLabel.textColor = .secondaryLabel
        subtitleLabel.textAlignment = .center
        subtitleLabel.numberOfLines = 0
    }
    
    private func setupActionButtons() {
        // Register Patient Button
        setupActionButton(
            registerPatientButton,
            title: "Register New Patient",
            subtitle: "Add a new patient to the system",
            iconName: "person.badge.plus.fill",
            backgroundColor: .systemBlue
        )
        
        // Patient Library Button
        setupActionButton(
            patientLibraryButton,
            title: "Patient Library",
            subtitle: "Browse and search existing patients",
            iconName: "folder.fill",
            backgroundColor: .systemGreen
        )
    }
    
    private func setupActionButton(_ button: UIButton, title: String, subtitle: String, iconName: String, backgroundColor: UIColor) {
        button.backgroundColor = .systemBackground
        button.layer.cornerRadius = 12
        button.layer.shadowColor = UIColor.black.cgColor
        button.layer.shadowOffset = CGSize(width: 0, height: 2)
        button.layer.shadowRadius = 4
        button.layer.shadowOpacity = 0.1
        
        // Create custom button content
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.alignment = .center
        stackView.spacing = 20
        stackView.isUserInteractionEnabled = false
        
        // Icon container
        let iconContainer = UIView()
        iconContainer.backgroundColor = backgroundColor.withAlphaComponent(0.1)
        iconContainer.layer.cornerRadius = 12
        iconContainer.translatesAutoresizingMaskIntoConstraints = false
        
        let iconImageView = UIImageView()
        iconImageView.image = UIImage(systemName: iconName)
        iconImageView.tintColor = backgroundColor
        iconImageView.contentMode = .scaleAspectFit
        iconImageView.translatesAutoresizingMaskIntoConstraints = false
        
        iconContainer.addSubview(iconImageView)
        
        // Text stack
        let textStackView = UIStackView()
        textStackView.axis = .vertical
        textStackView.alignment = .leading
        textStackView.spacing = 4
        
        let titleLabel = UILabel()
        titleLabel.text = title
        titleLabel.font = .systemFont(ofSize: 18, weight: .bold)
        titleLabel.textColor = .label
        
        let subtitleLabel = UILabel()
        subtitleLabel.text = subtitle
        subtitleLabel.font = .systemFont(ofSize: 14, weight: .regular)
        subtitleLabel.textColor = .secondaryLabel
        subtitleLabel.numberOfLines = 0
        
        textStackView.addArrangedSubview(titleLabel)
        textStackView.addArrangedSubview(subtitleLabel)
        
        // Arrow icon
        let arrowImageView = UIImageView()
        arrowImageView.image = UIImage(systemName: "chevron.right")
        arrowImageView.tintColor = .tertiaryLabel
        arrowImageView.contentMode = .scaleAspectFit
        
        stackView.addArrangedSubview(iconContainer)
        stackView.addArrangedSubview(textStackView)
        stackView.addArrangedSubview(arrowImageView)
        
        button.addSubview(stackView)
        
        // Constraints
        stackView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            iconContainer.widthAnchor.constraint(equalToConstant: 56),
            iconContainer.heightAnchor.constraint(equalToConstant: 56),
            
            iconImageView.centerXAnchor.constraint(equalTo: iconContainer.centerXAnchor),
            iconImageView.centerYAnchor.constraint(equalTo: iconContainer.centerYAnchor),
            iconImageView.widthAnchor.constraint(equalToConstant: 28),
            iconImageView.heightAnchor.constraint(equalToConstant: 28),
            
            arrowImageView.widthAnchor.constraint(equalToConstant: 16),
            arrowImageView.heightAnchor.constraint(equalToConstant: 16),
            
            stackView.leadingAnchor.constraint(equalTo: button.leadingAnchor, constant: 24),
            stackView.trailingAnchor.constraint(equalTo: button.trailingAnchor, constant: -24),
            stackView.topAnchor.constraint(equalTo: button.topAnchor, constant: 24),
            stackView.bottomAnchor.constraint(equalTo: button.bottomAnchor, constant: -24)
        ])
    }
    
    private func setupStatisticsView() {
        statisticsView.backgroundColor = .systemBackground
        statisticsView.layer.cornerRadius = 12
        statisticsView.layer.borderWidth = 1
        statisticsView.layer.borderColor = UIColor.separator.cgColor
        
        patientCountLabel.font = .systemFont(ofSize: 16, weight: .medium)
        patientCountLabel.textColor = .secondaryLabel
        patientCountLabel.textAlignment = .center
    }
    
    // MARK: - Data Updates
    private func updatePatientCount() {
        let count = coreDataManager.getTotalPatientCount()
        let patientText = count == 1 ? "patient" : "patients"
        patientCountLabel.text = "👥 \(count) \(patientText) registered"
    }
    
    // MARK: - Actions
    @IBAction func registerPatientTapped(_ sender: UIButton) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        if let vc = storyboard.instantiateViewController(withIdentifier: "PatientRegistrationViewController") as? PatientRegistrationViewController {
            let navController = UINavigationController(rootViewController: vc)
            navController.modalPresentationStyle = .fullScreen
            present(navController, animated: true)
        }
    }
    
    @IBAction func patientLibraryTapped(_ sender: UIButton) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        if let vc = storyboard.instantiateViewController(withIdentifier: "PatientLibraryViewController") as? PatientLibraryViewController {
            navigationController?.pushViewController(vc, animated: true)
        }
    }
}
