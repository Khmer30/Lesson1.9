//
//  AddRegistrationTableViewController.swift
//  HotelManzana
//
//  Created by Joy Marie on 3/28/22.
//

import UIKit

class AddRegistrationTableViewController: UITableViewController {
    
    let checkInDatePickerCellIndexPath = IndexPath(row: 1, section: 1)
    let checkOutDatePickerCellIndexPath = IndexPath(row: 3, section: 1)
    let checkInDateLabelCellIndexPath = IndexPath(row: 0, section: 1)
    let checkOutDateLabelCellIndexPath = IndexPath(row: 2, section: 1)
    
    var isCheckInDatePickerVisible: Bool = false {
        didSet {
            checkInDatePicker.isHidden = !isCheckInDatePickerVisible
        }
    }
    
    var isCheckOutDatePickerVisible: Bool = false {
        didSet {
            checkOutDatePicker.isHidden = !isCheckOutDatePickerVisible
        }
    }
    
    @IBOutlet var firstNameTextField: UITextField!
    @IBOutlet var lastNameTextField: UITextField!
    @IBOutlet var emailTextField: UITextField!
    
    @IBOutlet var checkInDateLabel: UILabel!
    @IBOutlet var checkInDatePicker: UIDatePicker!
    @IBOutlet var checkOutDateLabel: UILabel!
    @IBOutlet var checkOutDatePicker: UIDatePicker!
    
    @IBOutlet var numberOfAdultsLabel: UILabel!
    @IBOutlet var numberOfAdultsdStepper: UIStepper!
    @IBOutlet var numberOfChildrenLabel: UILabel!
    @IBOutlet var numberOfChildrenStepper: UIStepper!
    @IBOutlet var wifiSwitch: UISwitch!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let midnightToday = Calendar.current.startOfDay(for: Date())
        checkInDatePicker.minimumDate = midnightToday
        checkInDatePicker.date = midnightToday
        updateDateViews()
        updateNumberOfGuests()
        
    }

    @IBAction func doneBarbuttonTapped(_ sender: UIBarButtonItem) {
        let firstName = firstNameTextField.text ?? " "
        let lastName = lastNameTextField.text ?? " "
        let email = emailTextField.text ?? " "
        let checkInDate = checkInDatePicker.date
        let checkOutDate = checkOutDatePicker.date
        let numberOfAdults = Int(numberOfAdultsdStepper.value)
        let numberOfChildren = Int(numberOfChildrenStepper.value)
        let hasWifi = wifiSwitch.isOn
        
        
        print("DONE TAPPED")
        print("firstName: \(firstName)")
        print("lastName: \(lastName)")
        print("email: \(email)")
        print("checkIn: \(checkInDate)")
        print("checkOut: \(checkOutDate)")
        print("numberOdAdults: \(numberOfAdults)")
        print("numberOfChildren: \(numberOfChildren)")
        print("wifi: \(hasWifi)")
    }
    
    func updateDateViews() {
//        checkOutDatePicker.minimumDate = checkInDatePicker.date.addingTimeInterval(86400)
//
//        let dateFormatter = DateFormatter()
//        dateFormatter.dateStyle = .medium
//
//        checkInDateLabel.text = dateFormatter.string(from: checkInDatePicker.date)
//        checkOutDateLabel.text = dateFormatter.string(from: checkOutDatePicker.date)
        
        checkOutDatePicker.minimumDate = Calendar.current.date(byAdding: .day, value: 1, to: checkInDatePicker.date)
        
        checkInDateLabel.text = checkInDatePicker.date.formatted(date: .abbreviated, time: .omitted)
        checkOutDateLabel.text = checkOutDatePicker.date.formatted(date: .abbreviated, time: .omitted)
    }
    
    func updateNumberOfGuests() {
        numberOfAdultsLabel.text = "\(Int(numberOfAdultsdStepper.value))"
        numberOfChildrenLabel.text = "\(Int(numberOfChildrenStepper.value))"
    }
    
    
    @IBAction func datePickerValueChanged(_ sender: UIDatePicker) {
        updateDateViews()
        
    }
    
    @IBAction func stepperValueChanged(_ sender: UIStepper) {
        updateNumberOfGuests()
    }
    @IBAction func wifiSwitchChanged(_ sender: UISwitch) {
        
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        switch indexPath {
        case checkInDatePickerCellIndexPath where isCheckInDatePickerVisible == false:
            return 0
        case checkOutDatePickerCellIndexPath where isCheckOutDatePickerVisible == false:
            return 0
        default:
            return UITableView.automaticDimension
        }
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        if indexPath == checkInDateLabelCellIndexPath && isCheckOutDatePickerVisible == false {
            isCheckInDatePickerVisible.toggle()
        } else if indexPath == checkOutDateLabelCellIndexPath && isCheckInDatePickerVisible == false {
            isCheckOutDatePickerVisible.toggle()
        } else if indexPath == checkInDateLabelCellIndexPath || indexPath == checkOutDateLabelCellIndexPath {

            isCheckInDatePickerVisible.toggle()
            isCheckOutDatePickerVisible.toggle()
        } else {
            return
        }
        
        tableView.beginUpdates()
        tableView.endUpdates()
    }

}
