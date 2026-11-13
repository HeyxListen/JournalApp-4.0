//
//  ProfileViewController.swift
//  JournalApp-1.0
//
//  Created by csuftitan on 12/15/21.
//

import UIKit

class ProfileViewController: UIViewController, UITextFieldDelegate {

    @IBOutlet private var profileStackView: UIStackView!
    @IBOutlet private var profileFieldsStackView: UIStackView!
    @IBOutlet var nameTextField: UITextField!
    @IBOutlet var goal1TextField: UITextField!
    @IBOutlet var goal2TextField: UITextField!
    @IBOutlet var goal3TextField: UITextField!
    @IBOutlet var inspirationalQuoteSwitch: UISwitch!
    @IBOutlet var morningReminderSwitch: UISwitch!
    @IBOutlet var eveningReminderSwitch: UISwitch!
    @IBOutlet var updateProfileButton: UIButton!

    private let profileScrollView = UIScrollView()
    private let goalRowsStackView = UIStackView()
    private let habitRowsStackView = UIStackView()
    private let goalFieldsHeader = UILabel()
    private let habitFieldsHeader = UILabel()
    private let addGoalButton = UIButton(type: .system)
    private let addHabitButton = UIButton(type: .system)
    private var goalFields: [UITextField] = []
    private var habitFields: [UITextField] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        configureScrollableForm()
        configureDynamicFields()
        loadProfileIntoForm()
    }

    private func configureScrollableForm() {
        let oldConstraints = view.constraints.filter {
            ($0.firstItem as? UIView) === profileStackView ||
            ($0.secondItem as? UIView) === profileStackView
        }
        NSLayoutConstraint.deactivate(oldConstraints)
        profileStackView.removeFromSuperview()

        profileScrollView.translatesAutoresizingMaskIntoConstraints = false
        profileScrollView.backgroundColor = .clear
        profileScrollView.keyboardDismissMode = .interactive
        view.addSubview(profileScrollView)
        profileScrollView.addSubview(profileStackView)

        NSLayoutConstraint.activate([
            profileScrollView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            profileScrollView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            profileScrollView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            profileScrollView.bottomAnchor.constraint(equalTo: view.keyboardLayoutGuide.topAnchor),

            profileStackView.leadingAnchor.constraint(equalTo: profileScrollView.contentLayoutGuide.leadingAnchor, constant: 15),
            profileStackView.trailingAnchor.constraint(equalTo: profileScrollView.contentLayoutGuide.trailingAnchor, constant: -15),
            profileStackView.topAnchor.constraint(equalTo: profileScrollView.contentLayoutGuide.topAnchor, constant: 20),
            profileStackView.bottomAnchor.constraint(equalTo: profileScrollView.contentLayoutGuide.bottomAnchor, constant: -20),
            profileStackView.widthAnchor.constraint(equalTo: profileScrollView.frameLayoutGuide.widthAnchor, constant: -30)
        ])

        profileStackView.distribution = .fill
        profileStackView.spacing = 18
        profileFieldsStackView.distribution = .fill
        profileFieldsStackView.spacing = 12
    }

    private func configureDynamicFields() {
        for arrangedSubview in profileFieldsStackView.arrangedSubviews where arrangedSubview !== nameTextField {
            profileFieldsStackView.removeArrangedSubview(arrangedSubview)
            arrangedSubview.removeFromSuperview()
        }

        configureVerticalStack(goalRowsStackView, spacing: 8)
        configureVerticalStack(habitRowsStackView, spacing: 8)

        goalFieldsHeader.text = "Goals"
        habitFieldsHeader.text = "Habits"
        for header in [goalFieldsHeader, habitFieldsHeader] {
            header.font = .preferredFont(forTextStyle: .headline)
            header.adjustsFontForContentSizeCategory = true
            header.textColor = .label
        }

        addGoalButton.setTitle("＋ Add a goal", for: .normal)
        addGoalButton.contentHorizontalAlignment = .leading
        addGoalButton.addTarget(self, action: #selector(addGoalButtonPressed), for: .touchUpInside)

        addHabitButton.setTitle("＋ Add a habit", for: .normal)
        addHabitButton.contentHorizontalAlignment = .leading
        addHabitButton.addTarget(self, action: #selector(addHabitButtonPressed), for: .touchUpInside)

        profileFieldsStackView.addArrangedSubview(goalFieldsHeader)
        profileFieldsStackView.addArrangedSubview(goalRowsStackView)
        profileFieldsStackView.addArrangedSubview(addGoalButton)
        profileFieldsStackView.addArrangedSubview(habitFieldsHeader)
        profileFieldsStackView.addArrangedSubview(habitRowsStackView)
        profileFieldsStackView.addArrangedSubview(addHabitButton)

        nameTextField.delegate = self
        nameTextField.font = .preferredFont(forTextStyle: .body)
        nameTextField.adjustsFontForContentSizeCategory = true
        addGoalField(initialValue: "")
        addHabitField(initialValue: "")
    }

    private func configureVerticalStack(_ stackView: UIStackView, spacing: CGFloat) {
        stackView.axis = .vertical
        stackView.alignment = .fill
        stackView.distribution = .fill
        stackView.spacing = spacing
    }

    private func loadProfileIntoForm() {
        let savedProfile = Profile.loadFromFile()?.last ?? userProfile
        userProfile = savedProfile
        nameTextField.text = savedProfile.name

        for (index, goal) in savedProfile.goals.enumerated() {
            if index == 0 {
                goalFields[0].text = goal
            } else {
                addGoalField(initialValue: goal)
            }
        }

        for (index, habit) in savedProfile.habits.enumerated() {
            if index == 0 {
                habitFields[0].text = habit
            } else {
                addHabitField(initialValue: habit)
            }
        }
    }

    @objc private func addGoalButtonPressed() {
        addInputField(placeholder: "Goal", initialValue: "", rowsStackView: goalRowsStackView, fields: &goalFields) { [weak self] field in
            self?.removeGoalField(field)
        }
    }

    private func addGoalField(initialValue: String) {
        addInputField(placeholder: "Goal", initialValue: initialValue, rowsStackView: goalRowsStackView, fields: &goalFields) { [weak self] field in
            self?.removeGoalField(field)
        }
    }

    @objc private func addHabitButtonPressed() {
        addInputField(placeholder: "Habit", initialValue: "", rowsStackView: habitRowsStackView, fields: &habitFields) { [weak self] field in
            self?.removeHabitField(field)
        }
    }

    private func addHabitField(initialValue: String) {
        addInputField(placeholder: "Habit", initialValue: initialValue, rowsStackView: habitRowsStackView, fields: &habitFields) { [weak self] field in
            self?.removeHabitField(field)
        }
    }

    private func addInputField(
        placeholder: String,
        initialValue: String,
        rowsStackView: UIStackView,
        fields: inout [UITextField],
        onRemove: @escaping (UITextField) -> Void
    ) {
        let textField = UITextField()
        textField.borderStyle = .roundedRect
        textField.placeholder = placeholder
        textField.text = initialValue
        textField.font = .preferredFont(forTextStyle: .body)
        textField.adjustsFontForContentSizeCategory = true
        textField.returnKeyType = .next
        textField.delegate = self
        textField.accessibilityLabel = placeholder
        textField.heightAnchor.constraint(greaterThanOrEqualToConstant: 44).isActive = true

        let removeButton = UIButton(type: .system)
        removeButton.setImage(UIImage(systemName: "minus.circle"), for: .normal)
        removeButton.tintColor = .secondaryLabel
        removeButton.accessibilityLabel = "Remove \(placeholder.lowercased())"
        removeButton.addAction(UIAction { [weak textField] _ in
            guard let textField else { return }
            onRemove(textField)
        }, for: .touchUpInside)

        let row = UIStackView(arrangedSubviews: [textField, removeButton])
        row.axis = .horizontal
        row.alignment = .center
        row.spacing = 8
        removeButton.widthAnchor.constraint(equalToConstant: 44).isActive = true
        rowsStackView.addArrangedSubview(row)
        fields.append(textField)
    }

    private func removeGoalField(_ textField: UITextField) {
        removeInputField(textField, rowsStackView: goalRowsStackView, fields: &goalFields)
    }

    private func removeHabitField(_ textField: UITextField) {
        removeInputField(textField, rowsStackView: habitRowsStackView, fields: &habitFields)
    }

    private func removeInputField(
        _ textField: UITextField,
        rowsStackView: UIStackView,
        fields: inout [UITextField]
    ) {
        textField.resignFirstResponder()
        guard let row = textField.superview as? UIStackView else { return }

        if fields.count == 1 {
            textField.text = ""
            return
        }

        fields.removeAll { $0 === textField }
        rowsStackView.removeArrangedSubview(row)
        row.removeFromSuperview()
    }

    @IBAction func updateSettingsButtonPressed(_ sender: UIButton) {
        view.endEditing(true)

        let savedGoals = nonEmptyValues(from: goalFields)
        let savedHabits = nonEmptyValues(from: habitFields)
        let updatedProfile = Profile(
            name: (nameTextField.text ?? "").trimmingCharacters(in: .whitespacesAndNewlines),
            goals: savedGoals,
            habits: savedHabits
        )

        guard Profile.saveToFile(profiles: [updatedProfile]) else {
            showSaveAlert(success: false)
            return
        }

        userProfile = updatedProfile
        showSaveAlert(success: true)
    }

    private func nonEmptyValues(from fields: [UITextField]) -> [String] {
        fields.compactMap { field in
            let value = (field.text ?? "").trimmingCharacters(in: .whitespacesAndNewlines)
            return value.isEmpty ? nil : value
        }
    }

    private func showSaveAlert(success: Bool) {
        let alert = UIAlertController(
            title: success ? "Profile saved" : "Couldn’t save profile",
            message: success
                ? "Your name, goals, and habits are saved on this device."
                : "Please try again. Your changes have not been saved.",
            preferredStyle: .alert
        )
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        present(alert, animated: true)
    }

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        guard let nameTextField else {
            textField.resignFirstResponder()
            return true
        }
        let allFields = [nameTextField] + goalFields + habitFields
        if let index = allFields.firstIndex(of: textField), allFields.indices.contains(index + 1) {
            allFields[index + 1].becomeFirstResponder()
        } else {
            textField.resignFirstResponder()
        }
        return true
    }

    func textFieldDidBeginEditing(_ textField: UITextField) {
        let fieldFrame = textField.convert(textField.bounds, to: profileScrollView)
        profileScrollView.scrollRectToVisible(fieldFrame.insetBy(dx: 0, dy: -12), animated: true)
    }
}
