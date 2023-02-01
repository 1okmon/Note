//
//  NotesViewController.swift
//  Note
//
//  Created by 1okmon on 01.02.2023.
//

import UIKit

class NotesViewController: UIViewController {
    @IBOutlet weak var collectionView: UICollectionView!
    var notes = [Note]()
    var storageManager = ServiceLocator.notesStorageManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView.delegate = self
        collectionView.dataSource = self
        let nib = UINib(nibName: NoteCollectionViewCell.className, bundle: nil)
        collectionView.register(nib, forCellWithReuseIdentifier: NoteCollectionViewCell.className)
        collectionView.collectionViewLayout = layout()
        addRightButtonToNavigationBar()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        loadNotes()
        collectionView.reloadData()
    }
    
    func layout() -> UICollectionViewLayout {
        return
            UICollectionViewCompositionalLayout(sectionProvider: provider())
    }
    
    func provider() -> UICollectionViewCompositionalLayoutSectionProvider {
        return { int, inviroment in
            return self.generateSection(horizontal: false)
        }
    }
    
    func addRightButtonToNavigationBar() {
        let addButton: UIBarButtonItem = UIBarButtonItem(title: "", style: .done, target: self, action: #selector(createNewNote))
        let infoImage = UIImage(systemName: "plus")
        addButton.setBackgroundImage(infoImage, for: .normal, barMetrics: .default)
        self.navigationItem.rightBarButtonItem = addButton
    }
    
    @objc func createNewNote(sender: AnyObject) {
        if let targetVC = MainNavigator.getVCFromMain(withIdentifier: NoteEditorViewController.className) as? NoteEditorViewController {
            navigationController?.show(targetVC, sender: nil)
        }
    }
    
    func generateSection(horizontal: Bool) -> NSCollectionLayoutSection {
        let spacing: CGFloat = 10
        let itemSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1),
            heightDimension: .fractionalHeight(1)
        )
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        let groupSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1),
            heightDimension: .fractionalWidth(0.5)
        )
        let group = NSCollectionLayoutGroup.horizontal(
            layoutSize: groupSize,
            subitem: item,
            count: 2
        )
        group.interItemSpacing = .fixed(spacing)
        let section = NSCollectionLayoutSection(group: group)
        section.contentInsets = .init(
            top: spacing,
            leading: spacing,
            bottom: spacing,
            trailing: spacing
        )
        section.interGroupSpacing = 2*spacing
        if horizontal {
            section.orthogonalScrollingBehavior = .continuous
        }
        return section
    }
    
    func loadNotes() {
        notes = storageManager.getAllNotesFromUserDefaults()
    }
}

extension NotesViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if let targetVC = MainNavigator.getVCFromMain(withIdentifier: NoteEditorViewController.className) as? NoteEditorViewController {
            let note = notes[indexPath.row]
            targetVC.noteId = note.id
            targetVC.head = note.title
            targetVC.body = note.body
            navigationController?.show(targetVC, sender: nil)
        }
    }
}
extension NotesViewController: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        notes.count
    }

    func numberOfSections(in collectionView: UICollectionView) -> Int {
        1
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: NoteCollectionViewCell.className, for: indexPath) as? NoteCollectionViewCell {
            let note = notes[indexPath.row]
            cell.TitleLabel.text = note.title
            cell.BodyLabel.text = note.body
            return cell
        }
        return UICollectionViewCell()
    }
}
