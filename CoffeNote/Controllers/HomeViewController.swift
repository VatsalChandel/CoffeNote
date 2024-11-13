import UIKit
import UserNotifications

struct CoffeePlace: Codable {
    let name: String
    let rating: Double
    let item: String
    let price: Double
    let imageData: Data? // Add image data to store a photo of the item
}




func scheduleNotification() {
    let content = UNMutableNotificationContent()
    content.title = "[CoffeNote] A gentle reminder to take your pills!"
    content.body = "This is me hoping you had a great day! But to make it an even better day, you should take your pills 😎😎"
    content.sound = .default

    let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 5, repeats: false)
    let request = UNNotificationRequest(identifier: "coffeeReminder", content: content, trigger: trigger)

    UNUserNotificationCenter.current().add(request) { error in
        if let error = error {
            print("Error scheduling notification: \(error.localizedDescription)")
        } else {
            print("Notification scheduled successfully.")
        }
    }
}


func scheduleRandomDailyNotification() {
    
    // How to shedule this everyday? 
    
    let center = UNUserNotificationCenter.current()
        
    // 20 messages
    let messages = ["Message1", "Message2", "Message3", "message4"]
    
    let startHour = 9 // 9 am to 6 pm
    let endHour = 15
    let numberOfNotifications = 15

    for _ in 0..<numberOfNotifications {

        let randomHour = Int.random(in: startHour..<endHour)
        let randomMinute = Int.random(in: 0..<60)
        let randomIndex = Int.random(in: 0..<messages.count)
        
        var dateComponents = DateComponents()
        dateComponents.hour = randomHour
        dateComponents.minute = randomMinute
        
        print("sending at \(dateComponents) message: \(messages[randomIndex])")
        
        
        let content = UNMutableNotificationContent()
        content.title = "[CoffeNote] Time to discover a new coffee place!"
        content.body = "Message: \(messages[randomIndex]) \(randomHour) : \(randomMinute)"
        content.sound = .default

        
        let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: true)
        let request = UNNotificationRequest(identifier: UUID().uuidString, content: content, trigger: trigger)

        center.add(request) { error in
            if let error = error {
                print("Error scheduling random notification: \(error.localizedDescription)")
            }
        }
    }
}


func bombNotifications() {
    let center = UNUserNotificationCenter.current()
   
    let numNotifs = 500
    
    for i in 0..<numNotifs {
            // Generate a random interval in seconds (e.g., between 15 and 30 minutes)
        let randomInterval = TimeInterval(Int.random(in: 1...2)) // 900s = 15 min, 1800s = 30 min
        
        let content = UNMutableNotificationContent()
        content.title = "[CoffeNote] Time for a coffee break!"
        content.body = "Take a moment to savor some coffee ☕"
        content.sound = .default

        // Create a trigger based on the random interval
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: randomInterval, repeats: false)

        // Create a request with a unique identifier
        let request = UNNotificationRequest(identifier: "frequentNotification_\(i)", content: content, trigger: trigger)

        // Schedule the notification
        center.add(request) { error in
            if let error = error {
                print("Error scheduling frequent notification: \(error.localizedDescription)")
            } else {
                print("Notification scheduled with interval: \(randomInterval) seconds at i = \(i).")
            }
        }
    }
}



class HomeViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    private var coffeePlaces: [CoffeePlace] = []
    
    private let tableView: UITableView = {
        let table = UITableView()
        table.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        return table
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground

        loadCoffeePlaces() // Load saved coffee places from UserDefaults
        setupTableView()
        setupAddLocationButton()
        scheduleNotification()
        scheduleRandomDailyNotification()
        // bombNotifications() // Tries 500 notifications
    }
    
    private func setupTableView() {
        view.addSubview(tableView)
        tableView.dataSource = self
        tableView.delegate = self
        tableView.frame = view.bounds
    }
    
    private func setupAddLocationButton() {
        let addLocationButton = UIBarButtonItem(title: "Add Location", style: .plain, target: self, action: #selector(addLocationTapped))
        navigationItem.rightBarButtonItem = addLocationButton
    }
    
    private func saveCoffeePlaces() {
        if let encodedData = try? JSONEncoder().encode(coffeePlaces) {
            UserDefaults.standard.set(encodedData, forKey: "savedCoffeePlaces")
        }
    }
    
    private func loadCoffeePlaces() {
        if let savedData = UserDefaults.standard.data(forKey: "savedCoffeePlaces"),
           let decodedPlaces = try? JSONDecoder().decode([CoffeePlace].self, from: savedData) {
            coffeePlaces = decodedPlaces
        }
    }
    
    @objc private func addLocationTapped() {
        let addVC = AddLocationViewController()
        addVC.delegate = self
        navigationController?.pushViewController(addVC, animated: true)
    }
    
    // UITableViewDataSource Methods
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return coffeePlaces.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        let coffeePlace = coffeePlaces[indexPath.row]
        cell.textLabel?.text = "\(coffeePlace.name) - Rating: \(coffeePlace.rating)"
        
        if let imageData = coffeePlace.imageData {
            cell.imageView?.image = UIImage(data: imageData)
        } else {
            cell.imageView?.image = UIImage(systemName: "photo") // Placeholder image
        }
        
        return cell
    }
    
    // Swipe Actions
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        // Delete Action
        let deleteAction = UIContextualAction(style: .destructive, title: "Delete") { [weak self] _, _, completionHandler in
            guard let self = self else { return }
            self.coffeePlaces.remove(at: indexPath.row)
            self.saveCoffeePlaces()
            self.tableView.deleteRows(at: [indexPath], with: .automatic)
            completionHandler(true)
        }
        
        // Edit Action
        let editAction = UIContextualAction(style: .normal, title: "Edit") { [weak self] _, _, completionHandler in
            guard let self = self else { return }
            let editVC = AddLocationViewController()
            editVC.delegate = self
            
            // Pre-fill with existing data for editing
            let coffeePlace = self.coffeePlaces[indexPath.row]
            editVC.loadViewIfNeeded() // Ensure view is loaded
            editVC.nameTextField.text = coffeePlace.name
            editVC.ratingTextField.text = String(coffeePlace.rating)
            editVC.itemTextField.text = coffeePlace.item
            editVC.priceTextField.text = String(coffeePlace.price)
            if let imageData = coffeePlace.imageData {
                editVC.imageView.image = UIImage(data: imageData)
                editVC.selectedImageData = imageData
            }
            
            // Pass `editVC` to the `updateCoffeePlace` method
            editVC.saveButton.addTarget(self, action: #selector(self.updateCoffeePlace(_:editVC:)), for: .touchUpInside)
            
            self.navigationController?.pushViewController(editVC, animated: true)
            completionHandler(true)
        }
        
        editAction.backgroundColor = .systemBlue
        
        let configuration = UISwipeActionsConfiguration(actions: [deleteAction, editAction])
        return configuration
    }
    
    @objc private func updateCoffeePlace(_ sender: UIButton, editVC: AddLocationViewController) {
        guard let indexPath = tableView.indexPathForSelectedRow,
              let name = editVC.nameTextField.text,
              let ratingText = editVC.ratingTextField.text, let rating = Double(ratingText),
              let item = editVC.itemTextField.text,
              let priceText = editVC.priceTextField.text, let price = Double(priceText) else { return }
        
        // Update coffee place with new data
        coffeePlaces[indexPath.row] = CoffeePlace(name: name, rating: rating, item: item, price: price, imageData: editVC.selectedImageData)
        saveCoffeePlaces()
        tableView.reloadRows(at: [indexPath], with: .automatic)
        
        navigationController?.popViewController(animated: true)
    }
}





// Conform to the custom delegate to receive new entries
extension HomeViewController: AddLocationDelegate {
    func didAddCoffeePlace(_ coffeePlace: CoffeePlace) {
        coffeePlaces.append(coffeePlace)
        tableView.reloadData()
        saveCoffeePlaces() // Save updated coffee places to UserDefaults
    }
}



