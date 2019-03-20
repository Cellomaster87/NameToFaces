//
//  ViewController.swift
//  Name to Faces
//
//  Created by Michele Galvagno on 19/03/2019.
//  Copyright © 2019 Michele Galvagno. All rights reserved.
//

import UIKit

class ViewController: UICollectionViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    // MARK: - Property
    var people = [Person]()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addNewPerson))
    }
    
    // MARK: - Collection View Data Source
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return people.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Person", for: indexPath) as? PersonCell else {
            fatalError("Unable to dequeue PersonCell.")
        }
        
        let person = people[indexPath.item]
        
        cell.name.text = person.name
        
        let path = getDocumentsDirectory().appendingPathComponent(person.image)
        cell.imageView.image = UIImage(contentsOfFile: path.path)
        
        cell.imageView.layer.borderColor = UIColor(white: 0, alpha: 0.3).cgColor
        cell.imageView.layer.borderWidth = 2
        cell.imageView.layer.cornerRadius = 3
        cell.layer.cornerRadius = 7
        
        return cell
    }
    
    
    
    // MARK: - Image Picker Delegate Methods
    @objc func addNewPerson() {
        let picker = UIImagePickerController()
        picker.allowsEditing = true
        picker.delegate = self
        
        present(picker, animated: true)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        guard let image = info[.editedImage] as? UIImage else { return }
        
        let imageName = UUID().uuidString
        let imagePath = getDocumentsDirectory().appendingPathComponent(imageName)
        
        if let jpegData = image.jpegData(compressionQuality: 0.8) {
            try? jpegData.write(to: imagePath)
        }
        
        let person = Person(name: "Unknown", image: imageName)
        people.append(person)
        collectionView.reloadData()
        
        dismiss(animated: true)
    }
    
    // MARK: - Methods
    func getDocumentsDirectory() -> URL {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        
        return paths[0]
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let person = people[indexPath.item]
        
        if person.name == "Unknown" {
            let namingAC = UIAlertController(title: "Rename person", message: nil, preferredStyle: .alert)
            namingAC.addTextField()
            
            namingAC.addAction(UIAlertAction(title: "OK", style: .default) { [weak self, weak namingAC] _ in
                guard let newName = namingAC?.textFields?[0].text else { return }
                
                person.name = newName
                self?.collectionView.reloadData()
            })
            
            namingAC.addAction(UIAlertAction(title: "Cancel", style: .cancel))
            present(namingAC, animated: true)
        } else {
            let editingAC = UIAlertController(title: "Edit person", message: "Perform your edits", preferredStyle: .alert)
            editingAC.addTextField()
            
            editingAC.addAction(UIAlertAction(title: "Rename", style: .default) { [weak self, weak editingAC] _ in
                guard let editedName = editingAC?.textFields?[0].text else { return }
                
                person.name = editedName
                self?.collectionView.reloadData()
            })
            
            editingAC.addAction(UIAlertAction(title: "Delete", style: .destructive) { [weak self] _ in
                self?.people.remove(at: indexPath.item)
                self?.collectionView.reloadData()
            })
            
            present(editingAC, animated: true)
        }
        
        
    }
}

