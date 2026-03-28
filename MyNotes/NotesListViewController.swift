//
//  NotesListViewController.swift
//  MyNotes
//
//  Created by Christian Arzaluz on 28/03/26.
//

import UIKit

class NotesListViewController: UIViewController {

    private let store: NoteStore
    private let tableView = UITableView(frame: .zero, style: .insetGrouped)

    // MARK: - Empty State Views

    private let emptyStackView: UIStackView = {
        let sv = UIStackView()
        sv.axis = .vertical
        sv.alignment = .center
        sv.spacing = 8
        return sv
    }()

    private let emptyTitleLabel: UILabel = {
        let label = UILabel()
        label.text = "No hay notas"
        label.font = .preferredFont(forTextStyle: .title2)
        label.textColor = .secondaryLabel
        label.textAlignment = .center
        return label
    }()

    private let emptySubtitleLabel: UILabel = {
        let label = UILabel()
        label.text = "Toca + para crear tu primera nota"
        label.font = .preferredFont(forTextStyle: .subheadline)
        label.textColor = .tertiaryLabel
        label.textAlignment = .center
        return label
    }()

    // MARK: - Init

    init(store: NoteStore) {
        self.store = store
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()

        title = "Mis Notas"
        view.backgroundColor = .systemGroupedBackground

        navigationItem.rightBarButtonItem = UIBarButtonItem(
            barButtonSystemItem: .add,
            target: self,
            action: #selector(addNoteTapped)
        )

        setupTableView()
        setupEmptyState()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tableView.reloadData()
        updateEmptyState()
    }

    // MARK: - Setup

    private func setupTableView() {
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(NoteCell.self, forCellReuseIdentifier: NoteCell.reuseID)
        view.addSubview(tableView)

        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
    }

    private func setupEmptyState() {
        emptyStackView.addArrangedSubview(emptyTitleLabel)
        emptyStackView.addArrangedSubview(emptySubtitleLabel)
    }

    private func updateEmptyState() {
        tableView.backgroundView = store.count == 0 ? emptyStackView : nil
    }

    // MARK: - Actions

    @objc private func addNoteTapped() {
        let detailVC = NoteDetailViewController(note: nil) { [weak self] newNote in
            self?.store.add(newNote)
        }
        navigationController?.pushViewController(detailVC, animated: true)
    }
}

// MARK: - UITableViewDataSource

extension NotesListViewController: UITableViewDataSource {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        store.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: NoteCell.reuseID, for: indexPath) as! NoteCell
        cell.configure(with: store.note(at: indexPath.row))
        return cell
    }
}

// MARK: - UITableViewDelegate

extension NotesListViewController: UITableViewDelegate {

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)

        let note = store.note(at: indexPath.row)
        let detailVC = NoteDetailViewController(note: note) { [weak self] updatedNote in
            self?.store.update(updatedNote)
        }
        navigationController?.pushViewController(detailVC, animated: true)
    }

    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let deleteAction = UIContextualAction(style: .destructive, title: "Eliminar") { [weak self] _, _, completionHandler in
            guard let self else {
                completionHandler(false)
                return
            }

            let note = self.store.note(at: indexPath.row)
            let alert = UIAlertController(
                title: "Eliminar Nota",
                message: "¿Estás seguro de que deseas eliminar \"\(note.title)\"?",
                preferredStyle: .alert
            )
            alert.addAction(UIAlertAction(title: "Cancelar", style: .cancel) { _ in
                completionHandler(false)
            })
            alert.addAction(UIAlertAction(title: "Eliminar", style: .destructive) { _ in
                self.store.delete(at: indexPath.row)
                tableView.deleteRows(at: [indexPath], with: .automatic)
                self.updateEmptyState()
                completionHandler(true)
            })
            self.present(alert, animated: true)
        }

        return UISwipeActionsConfiguration(actions: [deleteAction])
    }
}
