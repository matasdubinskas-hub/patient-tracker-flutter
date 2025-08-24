import UIKit

class PatientRegistrationViewController: UIViewController {
    
    // MARK: - Outlets
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var contentView: UIView!
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var ageTextField: UITextField!
    @IBOutlet weak var weightTextField: UITextField!
    @IBOutlet weak var addressTextView: UITextView!
    @IBOutlet weak var phoneTextField: UITextField!
    @IBOutlet weak var assessmentScaleButton: UIButton!
    @IBOutlet weak var registerButton: UIButton!
    @IBOutlet weak var cancelButton: UIButton!
    
    // MARK: - Properties
    private let coreDataManager = CoreDataManager.shared
    private var selectedAssessmentScale: String?
    private let assessmentScales: [String]
    
    // MARK: - Init
    required init?(coder: NSCoder) {
        self.assessmentScales = CoreDataManager.shared.getAvailableAssessmentScales()
        super.init(coder: coder)
    }
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupTextFields()
        setupKeyboardHandling()
    }
    
    // MARK: - UI Setup
    private func setupUI() {
        title = "Register New Patient"
        view.backgroundColor = .systemGroupedBackground
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(
            barButtonSystemItem: .cancel,
            target: self,
            action: #selector(cancelTapped)
        )
        
        setupFormElements()
        setupButtons()
    }
    
    private func setupFormElements() {
        // Name field
        setupTextField(nameTextField, placeholder: "Patient Name", keyboardType: .default)
        
        // Age field
        setupTextField(ageTextField, placeholder: "Age", keyboardType: .numberPad)
        
        // Weight field
        setupTextField(weightTextField, placeholder: "Weight (kg)", keyboardType: .decimalPad)
        
        // Phone field
        setupTextField(phoneTextField, placeholder: "Phone Number", keyboardType: .phonePad)
        
        // Address text view
        addressTextView.backgroundColor = .systemBackground
        addressTextView.layer.cornerRadius = 8
        addressTextView.layer.borderWidth = 1
        addressTextView.layer.borderColor = UIColor.separator.cgColor
        addressTextView.font = .systemFont(ofSize: 16)
        addressTextView.textContainerInset = UIEdgeInsets(top: 12, left: 12, bottom: 12, right: 12)
        
        // Assessment scale button
        assessmentScaleButton.backgroundColor = .systemBackground
        assessmentScaleButton.layer.cornerRadius = 8
        assessmentScaleButton.layer.borderWidth = 1
        assessmentScaleButton.layer.borderColor = UIColor.separator.cgColor
        assessmentScaleButton.setTitle("Select Assessment Scale", for: .normal)
        assessmentScaleButton.setTitleColor(.label, for: .normal)
        assessmentScaleButton.contentHorizontalAlignment = .left
        assessmentScaleButton.contentEdgeInsets = UIEdgeInsets(top: 12, left: 16, bottom: 12, right: 16)
    }
    
    private func setupTextField(_ textField: UITextField, placeholder: String, keyboardType: UIKeyboardType) {
        textField.placeholder = placeholder
        textField.backgroundColor = .systemBackground
        textField.layer.cornerRadius = 8
        textField.layer.borderWidth = 1
        textField.layer.borderColor = UIColor.separator.cgColor
        textField.keyboardType = keyboardType
        textField.delegate = self
        
        // Add padding
        let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: 16, height: textField.frame.height))
        textField.leftView = paddingView
        textField.leftViewMode = .always
    }
    
    private func setupButtons() {
        // Register button
        registerButton.backgroundColor = .systemBlue
        registerButton.setTitleColor(.white, for: .normal)
        registerButton.layer.cornerRadius = 12
        registerButton.titleLabel?.font = .systemFont(ofSize: 18, weight: .semibold)
        
        // Cancel button
        cancelButton.backgroundColor = .systemGray5
        cancelButton.setTitleColor(.label, for: .normal)
        cancelButton.layer.cornerRadius = 12
        cancelButton.titleLabel?.font = .systemFont(ofSize: 18, weight: .medium)
    }
    
    private func setupTextFields() {
        // Add toolbar for number pad keyboards
        let toolbar = createKeyboardToolbar()
        ageTextField.inputAccessoryView = toolbar
        weightTextField.inputAccessoryView = toolbar
        phoneTextField.inputAccessoryView = toolbar
    }
    
    private func createKeyboardToolbar() -> UIToolbar {
        let toolbar = UIToolbar()
        toolbar.sizeToFit()
        
        let flexSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let doneButton = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(dismissKeyboard))
        
        toolbar.setItems([flexSpace, doneButton], animated: false)
        return toolbar
    }
    
    private func setupKeyboardHandling() {
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(keyboardWillShow),
            name: UIResponder.keyboardWillShowNotification,
            object: nil
        )
        
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(keyboardWillHide),
            name: UIResponder.keyboardWillHideNotification,
            object: nil
        )
    }
    
    // MARK: - Actions
    @IBAction func assessmentScaleButtonTapped(_ sender: UIButton) {
        showAssessmentScalePicker()
    }
    
    @IBAction func registerButtonTapped(_ sender: UIButton) {
        registerPatient()
    }
    
    @IBAction func cancelButtonTapped(_ sender: UIButton) {
        cancelTapped()
    }
    
    @objc private func cancelTapped() {
        dismiss(animated: true)
    }
    
    @objc private func dismissKeyboard() {
        view.endEditing(true)
    }
    
    // MARK: - Assessment Scale Picker
    private func showAssessmentScalePicker() {
        let alert = UIAlertController(title: "Select Assessment Scale", message: nil, preferredStyle: .actionSheet)
        
        for scale in assessmentScales {
            let action = UIAlertAction(title: scale, style: .default) { [weak self] _ in
                self?.selectedAssessmentScale = scale
                self?.assessmentScaleButton.setTitle(scale, for: .normal)
                self?.assessmentScaleButton.setTitleColor(.label, for: .normal)
            }
            alert.addAction(action)
        }
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel)
        alert.addAction(cancelAction)
        
        // For iPad
        if let popover = alert.popoverPresentationController {
            popover.sourceView = assessmentScaleButton
            popover.sourceRect = assessmentScaleButton.bounds
        }
        
        present(alert, animated: true)
    }
    
    // MARK: - Registration Logic
    private func registerPatient() {
        guard validateInput() else { return }
        
        let name = nameTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
        let age = Int(ageTextField.text!)!
        let weight = Double(weightTextField.text!)!
        let address = addressTextView.text.trimmingCharacters(in: .whitespacesAndNewlines)
        let phone = phoneTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
        let assessmentScale = selectedAssessmentScale!
        
        // Show loading
        let loadingAlert = showLoadingAlert()
        
        // Create patient
        DispatchQueue.global(qos: .userInitiated).async { [weak self] in
            guard let self = self else { return }
            
            let patient = self.coreDataManager.createPatient(
                name: name,
                age: age,
                weight: weight,
                address: address,
                phoneNumber: phone,
                selectedAssessmentScale: assessmentScale
            )
            
            DispatchQueue.main.async {
                loadingAlert.dismiss(animated: false) {
                    self.showSuccessAndDismiss(patientName: patient.name)
                }
            }
        }
    }
    
    private func validateInput() -> Bool {
        var isValid = true
        var errorMessage = ""
        
        // Name validation
        if nameTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty ?? true {
            errorMessage += "• Patient name is required\n"
            isValid = false
        }
        
        // Age validation
        if let ageText = ageTextField.text, !ageText.isEmpty {
            if Int(ageText) == nil || Int(ageText)! <= 0 || Int(ageText)! > 150 {
                errorMessage += "• Please enter a valid age (1-150)\n"
                isValid = false
            }
        } else {
            errorMessage += "• Age is required\n"
            isValid = false
        }
        
        // Weight validation
        if let weightText = weightTextField.text, !weightText.isEmpty {
            if Double(weightText) == nil || Double(weightText)! <= 0 {
                errorMessage += "• Please enter a valid weight\n"
                isValid = false
            }
        } else {
            errorMessage += "• Weight is required\n"
            isValid = false
        }
        
        // Phone validation
        if phoneTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty ?? true {
            errorMessage += "• Phone number is required\n"
            isValid = false
        }
        
        // Assessment scale validation
        if selectedAssessmentScale == nil {
            errorMessage += "• Please select an assessment scale\n"
            isValid = false
        }
        
        if !isValid {
            showError(message: errorMessage)
        }
        
        return isValid
    }
    
    // MARK: - Helper Methods
    private func showError(message: String) {
        let alert = UIAlertController(title: "Validation Error", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        present(alert, animated: true)
    }
    
    private func showLoadingAlert() -> UIAlertController {
        let alert = UIAlertController(title: "Registering Patient", message: "Please wait...", preferredStyle: .alert)
        present(alert, animated: true)
        return alert
    }
    
    private func showSuccessAndDismiss(patientName: String) {
        let alert = UIAlertController(
            title: "Success!",
            message: "\(patientName) has been registered successfully.",
            preferredStyle: .alert
        )
        
        alert.addAction(UIAlertAction(title: "OK", style: .default) { [weak self] _ in
            self?.dismiss(animated: true)
        })
        
        present(alert, animated: true)
    }
    
    // MARK: - Keyboard Handling
    @objc private func keyboardWillShow(notification: NSNotification) {
        if let keyboardFrame = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue {
            let keyboardHeight = keyboardFrame.cgRectValue.height
            scrollView.contentInset.bottom = keyboardHeight
            scrollView.scrollIndicatorInsets.bottom = keyboardHeight
        }
    }
    
    @objc private func keyboardWillHide(notification: NSNotification) {
        scrollView.contentInset.bottom = 0
        scrollView.scrollIndicatorInsets.bottom = 0
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
}

// MARK: - UITextFieldDelegate
extension PatientRegistrationViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == nameTextField {
            ageTextField.becomeFirstResponder()
        } else if textField == ageTextField {
            weightTextField.becomeFirstResponder()
        } else if textField == weightTextField {
            phoneTextField.becomeFirstResponder()
        } else {
            textField.resignFirstResponder()
        }
        return true
    }
}
