//
//  AddLocationViewController.swift
//  CoffeNote
//
//  Created by Vatsal Chandel on 10/27/24.
//

protocol AddLocationDelegate: AnyObject {
    func didAddCoffeePlace(_ coffeePlace: CoffeePlace)
}

import UIKit
import UserNotifications




class AddLocationViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    weak var delegate: AddLocationDelegate?
    
    private let coffeePlaceTextField = UITextField()
    private let ratingTextField = UITextField()
    private let itemsTextField = UITextField()
    private let priceTextField = UITextField()
    private let imageView = UIImageView()
    private let uploadImageButton = UIButton()
    private let saveButton = UIButton()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupDismissKeyboardGesture()

    }
    
    private func setupDismissKeyboardGesture() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        view.addGestureRecognizer(tapGesture)
    }

    @objc private func dismissKeyboard() {
        view.endEditing(true) // This dismisses the keyboard
    }
    
    
    
    private func setupUI() {
        view.backgroundColor = .systemBackground
        
        coffeePlaceTextField.placeholder = "Coffee Place Name"
        coffeePlaceTextField.borderStyle = .roundedRect
        
        ratingTextField.placeholder = "Rating (1-5)"
        ratingTextField.keyboardType = .numberPad
        ratingTextField.borderStyle = .roundedRect
        
        itemsTextField.placeholder = "Items Ordered"
        itemsTextField.borderStyle = .roundedRect
        
        priceTextField.placeholder = "Price"
        priceTextField.keyboardType = .decimalPad
        priceTextField.borderStyle = .roundedRect
        
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = 10
        imageView.backgroundColor = .secondarySystemBackground
        
        uploadImageButton.setTitle("Upload Image", for: .normal)
        uploadImageButton.addTarget(self, action: #selector(uploadImageTapped), for: .touchUpInside)
        
        saveButton.setTitle("Save", for: .normal)
        saveButton.backgroundColor = .systemBlue
        saveButton.layer.cornerRadius = 8
        saveButton.addTarget(self, action: #selector(saveTapped), for: .touchUpInside)
        
        let stackView = UIStackView(arrangedSubviews: [coffeePlaceTextField, ratingTextField, itemsTextField, priceTextField, imageView, uploadImageButton, saveButton])
        stackView.axis = .vertical
        stackView.spacing = 10
        stackView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(stackView)
        
        NSLayoutConstraint.activate([
            stackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            stackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            stackView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            imageView.heightAnchor.constraint(equalToConstant: 150)
        ])
    }
    
    @objc private func uploadImageTapped() {
        let imagePickerController = UIImagePickerController()
        imagePickerController.delegate = self
        imagePickerController.sourceType = .photoLibrary
        present(imagePickerController, animated: true, completion: nil)
    }
    
    @objc private func saveTapped() {
        guard let name = coffeePlaceTextField.text,
              let ratingText = ratingTextField.text, let rating = Int(ratingText),
              let items = itemsTextField.text,
              let priceText = priceTextField.text, let price = Double(priceText),
              let image = imageView.image else {
            print("Please fill in all fields.")
            return
        }
        
        let coffeePlace = CoffeePlace(name: name, rating: rating, items: items, price: price, image: image)
        delegate?.didAddCoffeePlace(coffeePlace)
        navigationController?.popViewController(animated: true)
    }
    
    // UIImagePickerControllerDelegate Methods
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        picker.dismiss(animated: true, completion: nil)
        if let selectedImage = info[.originalImage] as? UIImage {
            imageView.image = selectedImage
        }
    }
}

