//
//  AddRegistrationTableViewController.swift
//  HotelManzana
//
//  Created by Joy Marie on 3/28/22.
//

import UIKit

class AddRegistrationTableViewController: UITableViewController, SelectRoomTypeTableViewControllerDelegate {
    
    func selectRoomTypeTableViewController(_ controller: SelectRoomTypeTableViewController, didSelect roomType: RoomType) {
        self.roomType = roomType
        updateRoomType()
    }

    var roomType: RoomType?
    var wifiIsOn = false
    
    var registration: Registration? {
        
        guard let roomType = roomType else {return nil}
        
        let firstName = firstNameTextField.text ?? " "
        let lastName = lastNameTextField.text ?? " "
        let email = emailTextField.text ?? " "
        let checkInDate = checkInDatePicker.date
        let checkOutDate = checkOutDatePicker.date
        let numberOfAdults = Int(numberOfAdultsdStepper.value)
        let numberOfChildren = Int(numberOfChildrenStepper.value)
        let hasWifi = wifiSwitch.isOn
        
        return Registration(firstName: firstName,
                            lastName: lastName,
                            emailAddress: email,
                            checkInDate: checkInDate,
                            checkOutDate: checkOutDate,
                            numberOfAdults: numberOfAdults,
                            numberOfChildren: numberOfChildren,
                            roomType: roomType,
                            wifi: hasWifi)
        
    }
    
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
    @IBOutlet var roomTypeLabel: UILabel!
    
    @IBOutlet var fromDate: UIDatePicker!
    @IBOutlet var toDate: UIDatePicker!
    @IBOutlet var nightsLabel: UILabel!
    
    @IBOutlet var totalPricePerRoomType: UILabel!
    @IBOutlet var checkInOutDateLabel: UILabel!
    @IBOutlet var roomTypeChargesLabel: UILabel!
    
    @IBOutlet var wifiChargesLabel: UILabel!
   
    @IBOutlet var wifiLabel: UILabel!
    
    @IBOutlet var totalChargeLabel: UILabel!
    
    fileprivate func updateWifilLabel(_ withWifi: Bool) {
        wifiLabel.text = withWifi ? "Yes" : "No"
    }
    
    @IBAction func onWifiChanged(_ sender: UISwitch) {
        updateWifilLabel(sender.isOn)
        updateTotalWifiCharged()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let midnightToday = Calendar.current.startOfDay(for: Date())
        checkInDatePicker.minimumDate = midnightToday
        checkInDatePicker.date = midnightToday
        updateDateViews()
        updateNumberOfGuests()
        updateRoomType()
        updateNightsLabel()
        updateCheckInCheckOutDateLabel()
        roomTypeChargesLabel.text = "Not Set"
        totalPricePerRoomType.text = "$"
        updateWifilLabel(wifiSwitch.isOn)
        updateTotalWifiCharged()
        
    }
    
    @IBAction func dateChange(_ sender: UIDatePicker) {
        print(sender.date)
        updateNightsLabel()
        updateTotalWifiCharged()
        updateTotalPricePerRoom()
    }
    
    func updateTotalWifiCharged() {
        let numberOfNights = calculateNumberOfNights()
        let wifiPrice = wifiSwitch.isOn ? 10 : 0
        let totalWifiCharges = numberOfNights *  wifiPrice
        wifiChargesLabel.text = "\(totalWifiCharges)"
    }
    
    func updateCheckInCheckOutDateLabel() {

        checkInOutDateLabel.text = "\(checkInDateLabel.text!) - \(checkOutDateLabel.text!)"
    }
    
    func updateNightsLabel() {
        let numberOfNights = calculateNumberOfNights()
        nightsLabel.text = "\(numberOfNights)"
        
    }
  
    let oneDayInSecond = Double(3600)
    fileprivate func preventInvalidDate() {
        
        let toMaximum = toDate.date.timeIntervalSinceReferenceDate - oneDayInSecond
        fromDate.maximumDate = Date(timeIntervalSinceReferenceDate: toMaximum)
        let fromMinimum = fromDate.date.timeIntervalSinceReferenceDate + oneDayInSecond
        toDate.minimumDate = Date(timeIntervalSinceReferenceDate: fromMinimum)
    }
    
    func calculateNumberOfNights () -> Int {
        
        preventInvalidDate()
        
        let diff = toDate.date.timeIntervalSinceReferenceDate - fromDate.date.timeIntervalSinceReferenceDate
        let days = floor(diff/86400)
        return Int(days)
        
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
    
    @IBAction func doneBarbuttonTapped(_ sender: UIBarButtonItem) {
        let firstName = firstNameTextField.text ?? " "
        let lastName = lastNameTextField.text ?? " "
        let email = emailTextField.text ?? " "
        let checkInDate = checkInDatePicker.date
        let checkOutDate = checkOutDatePicker.date
        let numberOfAdults = Int(numberOfAdultsdStepper.value)
        let numberOfChildren = Int(numberOfChildrenStepper.value)
        let hasWifi = wifiSwitch.isOn
        let roomChoice = roomType?.name ?? "Not Set"
        
        
        print("DONE TAPPED")
        print("firstName: \(firstName)")
        print("lastName: \(lastName)")
        print("email: \(email)")
        print("checkIn: \(checkInDate)")
        print("checkOut: \(checkOutDate)")
        print("numberOdAdults: \(numberOfAdults)")
        print("numberOfChildren: \(numberOfChildren)")
        print("wifi: \(hasWifi)")
        print("roomType: \(roomChoice)")
    }
    
    @IBAction func datePickerValueChanged(_ sender: UIDatePicker) {
        updateDateViews()
        updateCheckInCheckOutDateLabel()
    }
    
    @IBAction func stepperValueChanged(_ sender: UIStepper) {
        updateNumberOfGuests()
    }
    
    @IBAction func datePickerViewValueChanged(_ sender: UIDatePicker) {
        updateNightsLabel()
    }
    
    @IBSegueAction func selectRoomType(_ coder: NSCoder) -> SelectRoomTypeTableViewController? {
        let selectRoomTypeController = SelectRoomTypeTableViewController(coder: coder)
        selectRoomTypeController?.delegate = self
        selectRoomTypeController?.roomType = roomType
        
        return selectRoomTypeController
    }
    
    func updateTotalPricePerRoom() {
        if let roomType = roomType {
            let numberOfNights = calculateNumberOfNights()
            let roomCharges = roomType.price * numberOfNights
            totalPricePerRoomType.text = "\(roomCharges)"
        } else {
            totalPricePerRoomType.text = "$ 0"
        }
        
    }
    
    var totalCharges = 0
    
    func updateRoomType() {
        if let roomType = roomType {
            roomTypeLabel.text = roomType.name
            roomTypeChargesLabel.text = "\(roomType.name) @ $\(roomType.price)/ night"
        
        } else {
            roomTypeLabel.text = "Not Set"
        }
        updateTotalPricePerRoom()
    
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
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "selectRoomType" {
            let destinationViewController = segue.destination as? SelectRoomTypeTableViewController
            
            destinationViewController?.delegate = self
            destinationViewController?.roomType = roomType
        }
    }
    
    @IBAction func cancelButtonTapped(_ sender: UIBarButtonItem) {
        dismiss(animated: true, completion: nil)
    }
}
