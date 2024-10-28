import UIKit


struct CoffeePlace {
    let name: String
    let rating: Int
    let items: String
    let price: Double
    let image: UIImage
}


import UserNotifications

func scheduleNotification() {
    let content = UNMutableNotificationContent()
    content.title = "Check Out Your Favorite Coffee Place!"
    content.body = "Remember to visit and log new coffee places!"
    content.sound = .default
    
    // Set a trigger for 5 seconds from now (for testing purposes)
    let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 5, repeats: false)
    
    // Create the request
    let request = UNNotificationRequest(identifier: "coffeeReminder", content: content, trigger: trigger)
    
    // Add the notification request to the notification center
    UNUserNotificationCenter.current().add(request) { error in
        if let error = error {
            print("Error scheduling notification: \(error.localizedDescription)")
        } else {
            print("Notification scheduled successfully.")
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
    
    private let addLocationButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Add Location", for: .normal)
        button.addTarget(self, action: #selector(addLocationTapped), for: .touchUpInside)
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        setupTableView()
        setupAddLocationButton()
        scheduleNotification()
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

    
    @objc private func addLocationTapped() {
        print("Add Location button tapped") // Check if this prints to the console
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
        cell.imageView?.image = coffeePlace.image
        return cell
    }
}

// Conform to a custom delegate to receive new entries
extension HomeViewController: AddLocationDelegate {
    func didAddCoffeePlace(_ coffeePlace: CoffeePlace) {
        coffeePlaces.append(coffeePlace)
        tableView.reloadData()
    }
}
