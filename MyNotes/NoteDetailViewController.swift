//
//  NoteDetailViewController.swift
//  MyNotes
//
//  Created by Christian Arzaluz on 28/03/26.
//

import UIKit

class NoteDetailViewController: UIViewController {

    private let existingNote: Note?
    private let onSave: (Note) -> Void

    // MARK: - UI Components

    private let scrollView: UIScrollView = {
        let sv = UIScrollView()
        sv.translatesAutoresizingMaskIntoConstraints = false
        return sv
    }()

    private let contentContainer: UIView = {
        let v = UIView()
        v.translatesAutoresizingMaskIntoConstraints = false
        return v
    }()

    private let formStackView: UIStackView = {
        let sv = UIStackView()
        sv.axis = .vertical
        sv.spacing = 12
        sv.translatesAutoresizingMaskIntoConstraints = false
        return sv
    }()

    private let titleSectionLabel: UILabel = {
        let label = UILabel()
        label.text = "Título"
        label.font = .preferredFont(forTextStyle: .subheadline)
        label.textColor = .secondaryLabel
        return label
    }()

    private let titleTextField: UITextField = {
        let tf = UITextField()
        tf.placeholder = "Escribe el título de tu nota..."
        tf.borderStyle = .roundedRect
        tf.font = .preferredFont(forTextStyle: .body)
        tf.clearButtonMode = .whileEditing
        return tf
    }()

    private let contentSectionLabel: UILabel = {
        let label = UILabel()
        label.text = "Contenido"
        label.font = .preferredFont(forTextStyle: .subheadline)
        label.textColor = .secondaryLabel
        return label
    }()

    private let contentTextView: UITextView = {
        let tv = UITextView()
        tv.font = .systemFont(ofSize: 17)
        tv.layer.borderColor = UIColor.systemGray4.cgColor
        tv.layer.borderWidth = 1
        tv.layer.cornerRadius = 8
        tv.textContainerInset = UIEdgeInsets(top: 8, left: 4, bottom: 8, right: 4)
        return tv
    }()

    private let fontSizeLabel: UILabel = {
        let label = UILabel()
        label.text = "Tamaño de fuente: 17"
        label.font = .preferredFont(forTextStyle: .subheadline)
        label.textColor = .secondaryLabel
        return label
    }()

    private let fontSizeSlider: UISlider = {
        let slider = UISlider()
        slider.minimumValue = 12
        slider.maximumValue = 32
        slider.value = 17
        slider.minimumTrackTintColor = .systemBlue
        return slider
    }()

    // MARK: - Switch para texto en negrita

    private let boldSwitchStack: UIStackView = {
        let sv = UIStackView()
        sv.axis = .horizontal
        sv.alignment = .center
        sv.spacing = 8
        return sv
    }()

    private let boldSwitchLabel: UILabel = {
        let label = UILabel()
        label.text = "Texto en negrita"
        label.font = .preferredFont(forTextStyle: .subheadline)
        label.textColor = .secondaryLabel
        return label
    }()

    private let boldSwitch: UISwitch = {
        let sw = UISwitch()
        sw.isOn = false
        sw.onTintColor = .systemBlue
        return sw
    }()

    private let saveButton: UIButton = {
        var config = UIButton.Configuration.filled()
        config.title = "Guardar Nota"
        config.cornerStyle = .medium
        config.baseBackgroundColor = .systemBlue
        let button = UIButton(configuration: config)
        return button
    }()

    // MARK: - Init

    init(note: Note?, onSave: @escaping (Note) -> Void) {
        self.existingNote = note
        self.onSave = onSave
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()

        title = existingNote == nil ? "Nueva Nota" : "Editar Nota"
        view.backgroundColor = .systemBackground

        setupLayout()
        setupActions()
        populateFields()
    }

    // MARK: - Setup

    private func setupLayout() {
        view.addSubview(scrollView)

        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.keyboardLayoutGuide.topAnchor)
        ])

        scrollView.addSubview(contentContainer)

        NSLayoutConstraint.activate([
            contentContainer.topAnchor.constraint(equalTo: scrollView.topAnchor),
            contentContainer.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            contentContainer.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            contentContainer.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            contentContainer.widthAnchor.constraint(equalTo: scrollView.widthAnchor)
        ])

        contentContainer.addSubview(formStackView)

        NSLayoutConstraint.activate([
            formStackView.topAnchor.constraint(equalTo: contentContainer.topAnchor, constant: 20),
            formStackView.leadingAnchor.constraint(equalTo: contentContainer.leadingAnchor, constant: 20),
            formStackView.trailingAnchor.constraint(equalTo: contentContainer.trailingAnchor, constant: -20),
            formStackView.bottomAnchor.constraint(equalTo: contentContainer.bottomAnchor, constant: -20)
        ])

        // Add form elements to stack view
        formStackView.addArrangedSubview(titleSectionLabel)
        formStackView.addArrangedSubview(titleTextField)
        formStackView.addArrangedSubview(contentSectionLabel)
        formStackView.addArrangedSubview(contentTextView)
        formStackView.addArrangedSubview(fontSizeLabel)
        formStackView.addArrangedSubview(fontSizeSlider)

        // Switch para texto en negrita
        boldSwitchStack.addArrangedSubview(boldSwitchLabel)
        boldSwitchStack.addArrangedSubview(boldSwitch)
        formStackView.addArrangedSubview(boldSwitchStack)

        formStackView.addArrangedSubview(saveButton)

        // Add extra spacing before font size and save button sections
        formStackView.setCustomSpacing(20, after: titleTextField)
        formStackView.setCustomSpacing(20, after: contentTextView)
        formStackView.setCustomSpacing(16, after: fontSizeSlider)
        formStackView.setCustomSpacing(24, after: boldSwitchStack)

        // Content text view minimum height
        contentTextView.heightAnchor.constraint(greaterThanOrEqualToConstant: 200).isActive = true

        // Save button height
        saveButton.heightAnchor.constraint(equalToConstant: 50).isActive = true
    }

    private func setupActions() {
        fontSizeSlider.addTarget(self, action: #selector(sliderChanged(_:)), for: .valueChanged)
        boldSwitch.addTarget(self, action: #selector(boldSwitchChanged(_:)), for: .valueChanged)
        saveButton.addAction(UIAction { [weak self] _ in self?.saveTapped() }, for: .touchUpInside)

        // Dismiss keyboard on tap outside
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        tapGesture.cancelsTouchesInView = false
        view.addGestureRecognizer(tapGesture)
    }

    private func populateFields() {
        guard let note = existingNote else { return }
        titleTextField.text = note.title
        contentTextView.text = note.content
    }

    // MARK: - Actions

    @objc private func sliderChanged(_ sender: UISlider) {
        let size = Int(sender.value)
        fontSizeLabel.text = "Tamaño de fuente: \(size)"
        updateContentFont()
    }

    @objc private func boldSwitchChanged(_ sender: UISwitch) {
        updateContentFont()
    }

    private func updateContentFont() {
        let size = CGFloat(Int(fontSizeSlider.value))
        if boldSwitch.isOn {
            contentTextView.font = .boldSystemFont(ofSize: size)
        } else {
            contentTextView.font = .systemFont(ofSize: size)
        }
    }

    @objc private func dismissKeyboard() {
        view.endEditing(true)
    }

    private func saveTapped() {
        let trimmedTitle = titleTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) ?? ""
        let trimmedContent = contentTextView.text?.trimmingCharacters(in: .whitespacesAndNewlines) ?? ""

        if trimmedTitle.isEmpty {
            showAlert(title: "Título Vacío", message: "Por favor, escribe un título para tu nota.")
            return
        }

        if trimmedContent.isEmpty {
            showAlert(title: "Contenido Vacío", message: "Por favor, escribe algún contenido para tu nota.")
            return
        }

        let note = Note(
            id: existingNote?.id ?? UUID(),
            title: trimmedTitle,
            content: trimmedContent,
            date: Date()
        )

        onSave(note)
        navigationController?.popViewController(animated: true)
    }

    private func showAlert(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        present(alert, animated: true)
    }
}
