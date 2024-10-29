import UIKit

protocol AddLocationDelegate: AnyObject {
    func didAddCoffeePlace(_ coffeePlace: CoffeePlace)
}

class AddLocationViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    var delegate: AddLocationDelegate?
    var selectedImageData: Data?
    
    let nameTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "Coffee Place Name"
        textField.borderStyle = .roundedRect
        return textField
    }()
    
    let ratingTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "Rating (0-5)"
        textField.keyboardType = .decimalPad
        textField.borderStyle = .roundedRect
        return textField
    }()
    
    let itemTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "What you got"
        textField.borderStyle = .roundedRect
        return textField
    }()
    
    let priceTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "Price Paid"
        textField.keyboardType = .decimalPad
        textField.borderStyle = .roundedRect
        return textField
    }()
    
    let imageView: UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFill
        iv.layer.cornerRadius = 10
        iv.clipsToBounds = true
        iv.backgroundColor = .secondarySystemBackground
        return iv
    }()
    
    let selectImageButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Select Image", for: .normal)
        button.addTarget(self, action: #selector(selectImageTapped), for: .touchUpInside)
        return button
    }()
    
    let saveButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Save", for: .normal)
        button.addTarget(self, action: #selector(saveCoffeePlace), for: .touchUpInside)
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        
        // Add subviews
        view.addSubview(nameTextField)
        view.addSubview(ratingTextField)
        view.addSubview(itemTextField)
        view.addSubview(priceTextField)
        view.addSubview(imageView)
        view.addSubview(selectImageButton)
        view.addSubview(saveButton)
        
        // Set up layout
        setupLayout()
    }
    
    private func setupLayout() {
        nameTextField.frame = CGRect(x: 20, y: 100, width: view.frame.width - 40, height: 40)
        ratingTextField.frame = CGRect(x: 20, y: 150, width: view.frame.width - 40, height: 40)
        itemTextField.frame = CGRect(x: 20, y: 200, width: view.frame.width - 40, height: 40)
        priceTextField.frame = CGRect(x: 20, y: 250, width: view.frame.width - 40, height: 40)
        
        imageView.frame = CGRect(x: 20, y: 300, width: 100, height: 100)
        selectImageButton.frame = CGRect(x: 130, y: 300, width: 100, height: 40)
        
        saveButton.frame = CGRect(x: 20, y: 420, width: view.frame.width - 40, height: 40)
    }
    
    @objc private func selectImageTapped() {
        let picker = UIImagePickerController()
        picker.delegate = self
        picker.sourceType = .photoLibrary // or .camera to take a photo
        picker.allowsEditing = true
        present(picker, animated: true)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey: Any]) {
        picker.dismiss(animated: true, completion: nil)
        
        if let editedImage = info[.editedImage] as? UIImage {
            imageView.image = editedImage
            selectedImageData = editedImage.jpegData(compressionQuality: 0.8)
        } else if let originalImage = info[.originalImage] as? UIImage {
            imageView.image = originalImage
            selectedImageData = originalImage.jpegData(compressionQuality: 0.8)
        }
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
    
    @objc private func saveCoffeePlace() {
        // Check if all inputs are valid
        guard let name = nameTextField.text,
              let ratingText = ratingTextField.text, let rating = Double(ratingText),
              let item = itemTextField.text,
              let priceText = priceTextField.text, let price = Double(priceText) else { return }
        
        let newCoffeePlace = CoffeePlace(name: name, rating: rating, item: item, price: price, imageData: selectedImageData)
        delegate?.didAddCoffeePlace(newCoffeePlace)
        navigationController?.popViewController(animated: true)
    }
}
