//
//  BookAppointmentViewController.swift
//  Bomane
//
//  Created by Jeremy Sharvit on 2016-12-24.
//  Copyright © 2016 com.bomane. All rights reserved.
//

import UIKit
import CVCalendar
import PopupDialog

class BookAppointmentViewController: UIViewController {
    
    struct Color {
        static let selectedText = UIColor.white
        static let text = UIColor.black
        static let textDisabled = UIColor.gray
        static let selectionBackground = UIColor(red: 0.2, green: 0.2, blue: 1.0, alpha: 1.0)
        static let sundayText = UIColor(red: 1.0, green: 0.2, blue: 0.2, alpha: 1.0)
        static let sundayTextDisabled = UIColor(red: 1.0, green: 0.6, blue: 0.6, alpha: 1.0)
        static let sundaySelectionBackground = sundayText
    }
    
//    static let shared = BookAppointmentViewController()

    @IBOutlet weak var selectedTimeLabel: UILabel!
    @IBOutlet weak var serviceLabel: UILabel!
    @IBOutlet weak var stylistLabel: UILabel!
    @IBOutlet weak var monthLabel: UILabel!
    @IBOutlet weak var calendarView: CVCalendarView!
    @IBOutlet var menuView: CVCalendarMenuView!

    @IBOutlet weak var selectedDateLabel: UILabel!
    
    var selectedStylist:Stylist?
    var selectedService:Service?
    var selectedTimeSlot:TimeSlot?
    var shouldShowDaysOut = true
    var animationFinished = true
    
    var selectedDay:DayView! {
        didSet {
            self.selectedDateLabel.text = selectedDay.date!.commonDescription
        }
    }
    
    var currentCalendar: Calendar?
    
    override func awakeFromNib() {
        let timeZoneBias = 480 // (UTC+08:00)
        currentCalendar = Calendar.init(identifier: .gregorian)
        if let timeZone = TimeZone.init(secondsFromGMT: -timeZoneBias * 60) {
            currentCalendar?.timeZone = timeZone
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.white
        setUpNavBar()
        // Do any additional setup after loading the view.
        
        // Appearance delegate [Unnecessary]
        self.calendarView.calendarAppearanceDelegate = self
        
        // Animator delegate [Unnecessary]
        self.calendarView.animatorDelegate = self
        
        // Menu delegate [Required]
        self.menuView.menuViewDelegate = self
        
        // Calendar delegate [Required]
        self.calendarView.calendarDelegate = self
        
        let date = Date()
        let calendar = Calendar.current
        let components = calendar.component(.month, from: date)
        let monthName = DateFormatter().monthSymbols[components - 1]
        monthLabel.text = monthName
        
        guard let user = DatabaseController.shared.loadUser(), let token = user.apiKey else {return}
        //check if the users access token is still valid
        NetworkController.shared.checkIfTokenValid(token: token) {
            valid in
            self.updateUserToken()
        }
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.clearBookingData), name: Notifications.kClearAllBookingData, object: nil)
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self, name: Notifications.kClearAllBookingData, object: nil)
    }
    
    func clearBookingData() {
        self.selectedStylist = nil
        self.selectedService = nil
        self.selectedTimeSlot = nil
        self.stylistLabel.text = "Select Stylist"
        self.serviceLabel.text = "Select Service"
        self.selectedTimeLabel.text = ""
    }
    
    func updateUserToken() {
        NetworkController.shared.getAccessToken() {
            string in
            
            guard let token = string else {
                //if this fails then relogin
                DatabaseController.shared.deleteUserFile()
                AppDelegate.shared().showLogin()
                return
            }
            guard let user = DatabaseController.shared.loadUser() else {return}
            user.apiKey = token
            DatabaseController.shared.saveUser(user: user)
        }
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        menuView.commitMenuViewUpdate()
        calendarView.commitCalendarViewUpdate()
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        navigationController?.navigationBar.barTintColor = UIColor.white
        navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName:UIColor.black, NSFontAttributeName:UIFont(name: "Baskerville", size: 20)!]
        navigationController?.navigationBar.isTranslucent = false
    }
    
    func setUpNavBar() {
        navigationController?.navigationBar.barTintColor = UIColor.white
        navigationItem.title = "BOOK APPOINTMENT"
        navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName:UIColor.black, NSFontAttributeName:UIFont(name: "Baskerville", size: 20)!]
        navigationController?.navigationBar.isTranslucent = false
        
        //This line sets the back button title to "" so that it doesnt show up at < Messages when pushing
        //the next view controller
        self.navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: UIBarButtonItemStyle.plain, target: nil, action: nil)
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(image: #imageLiteral(resourceName: "hamburgerIcon"), style: .plain, target: self, action: #selector(self.menuButtonPressed(sender:)))
        self.navigationItem.leftBarButtonItem?.tintColor = UIColor.black
        
    }
        
    func nextOrEdit() {
        let alert = PopupDialog(title: "Go to confirm screen?", message: "")
        alert.buttonAlignment = .horizontal
        let buttonOne = DefaultButton(title: "Next") {
            guard let stylist = self.selectedStylist, let service = self.selectedService, let time = self.selectedTimeSlot else {return}
            
            if time.employeeId! != stylist.id {
                self.showErrorAlert(title: "Error", body: "The time you selected conflicts with the selected stylist.")
                return
            }
            
            if time.treatmentId! != service.id! {
                self.showErrorAlert(title: "Error", body: "The service you selected is not available at this time.")
                return
            }
            
            let app = Appointment(stylist: stylist, service: service, timeslot: time)
            let confirmVC = ConfirmViewController()
            confirmVC.appointment = app
            self.navigationController?.pushViewController(confirmVC, animated: true)
        }
        
        let buttonTwo = CancelButton(title: "Edit") {
            
        }
        
        alert.addButtons([buttonTwo, buttonOne])
        alert.transitionStyle = .zoomIn
        // Present dialog
        self.present(alert, animated: true, completion: nil)
    }
    
    func menuButtonPressed(sender: UIBarButtonItem) {
        let menu = ScreenMenuViewController.shared
        let navVC = UINavigationController(rootViewController: menu)
        navVC.transitioningDelegate = self
        navVC.modalPresentationStyle = .overFullScreen
        self.present(navVC, animated: true, completion: nil)
    }
    
    @IBAction func selectStylistPressed(_ sender: UIButton) {
        let stylistVC = StylistSelectionViewController()
        stylistVC.delegate = self
        stylistVC.transitioningDelegate = self
        stylistVC.modalPresentationStyle = .overFullScreen
        self.present(stylistVC, animated: true, completion: nil)
    }
    
    @IBAction func selectServiceTapped(_ sender: UIButton) {
        let serviceVC = ServiceSelectionViewController()
        serviceVC.delegate = self
        if let sty = self.selectedStylist {
            serviceVC.stylist = sty
        }
        serviceVC.transitioningDelegate = self
        serviceVC.modalPresentationStyle = .overFullScreen
        self.present(serviceVC, animated: true, completion: nil)
    }
    
    @IBAction func viewAvailableAppointmentsPressed(_ sender: UIButton) {
        
        guard self.selectedStylist != nil else {
            self.showErrorAlert(title: "Select a stylist", body: "Please select a stylist to view available appointments.")
            return
        }
        
        guard self.selectedService != nil else {
            self.showErrorAlert(title: "Select a service", body: "Please select a service to view available appointments.")
            return
        }
        
        guard (selectedDay) != nil else {
            self.showErrorAlert(title: "Select a date", body: "Please select a date to view available appointments.")
            return
        }
        
        let timeVC = TimeSelectionViewController()
        timeVC.delegate = self
        timeVC.stylist = self.selectedStylist
        timeVC.service = self.selectedService
        timeVC.selectedDate = self.selectedDay.date.date
        timeVC.transitioningDelegate = self
        timeVC.modalPresentationStyle = .overFullScreen
        self.present(timeVC, animated: true, completion: nil)
        
    }
    
}

extension BookAppointmentViewController:UIViewControllerTransitioningDelegate {
    func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        if dismissed.isKind(of: TimeSelectionViewController.self) || dismissed.isKind(of: StylistSelectionViewController.self) || dismissed.isKind(of: ServiceSelectionViewController.self) {
            return DimissAnimator()
        }
        
        let animator = SlideAnimator()
        animator.presenting = false
        return animator
    }
    
    func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        
        if presented.isKind(of: TimeSelectionViewController.self) || presented.isKind(of: StylistSelectionViewController.self) || presented.isKind(of: ServiceSelectionViewController.self) {
            let animator = PresentAnimator()
            return animator
        }
        
        return SlideAnimator()
    }
    
}

// MARK: - CVCalendarViewDelegate & CVCalendarMenuViewDelegate
extension BookAppointmentViewController: CVCalendarViewDelegate, CVCalendarMenuViewDelegate {
    
    /// Required method to implement!
    func presentationMode() -> CalendarMode {
        return .monthView
    }
    
    /// Required method to implement!
    func firstWeekday() -> Weekday {
        return .sunday
    }
    
    // MARK: Optional methods
    
    func calendar() -> Calendar? {
        return currentCalendar
    }
    
    func dayOfWeekFont() -> UIFont {
        return UIFont(name: "AvenirNext-Regular", size: 15)!
    }
    
    func dayOfWeekBackGroundColor(by weekday: Weekday) -> UIColor {
        return UIColor.clear
    }
    
    func dayOfWeekTextColor(by weekday: Weekday) -> UIColor {
        return UIColor(red: 170/255, green: 170/255, blue: 170/255, alpha: 1)
    }
    
    func shouldShowWeekdaysOut() -> Bool {
        return false
    }
    
    func shouldAnimateResizing() -> Bool {
        return true // Default value is true
    }
    
    private func shouldSelectDayView(dayView: DayView) -> Bool {
        return false
    }
    
    func shouldAutoSelectDayOnMonthChange() -> Bool {
        return false
    }
    
    func didSelectDayView(_ dayView: CVCalendarDayView, animationDidFinish: Bool) {
        selectedDay = dayView
    }
    
    func shouldSelectRange() -> Bool {
        return true
    }
    
    func didSelectRange(from startDayView: DayView, to endDayView: DayView) {
        print("RANGE SELECTED: \(startDayView.date.commonDescription) to \(endDayView.date.commonDescription)")
    }
    
    func presentedDateUpdated(_ date: CVDate) {
        if monthLabel.text != date.globalDescription && self.animationFinished {
            let updatedMonthLabel = UILabel()
            updatedMonthLabel.textColor = monthLabel.textColor
            updatedMonthLabel.font = monthLabel.font
            updatedMonthLabel.textAlignment = .center
            updatedMonthLabel.text = date.globalDescription
            updatedMonthLabel.sizeToFit()
            updatedMonthLabel.alpha = 0
            updatedMonthLabel.center = self.monthLabel.center
            
            let offset = CGFloat(48)
            updatedMonthLabel.transform = CGAffineTransform(translationX: 0, y: offset)
            updatedMonthLabel.transform = CGAffineTransform(scaleX: 1, y: 0.1)
            
            UIView.animate(withDuration: 0.35, delay: 0, options: UIViewAnimationOptions.curveEaseIn, animations: {
                self.animationFinished = false
                self.monthLabel.transform = CGAffineTransform(translationX: 0, y: -offset)
                self.monthLabel.transform = CGAffineTransform(scaleX: 1, y: 0.1)
                self.monthLabel.alpha = 0
                
                updatedMonthLabel.alpha = 1
                updatedMonthLabel.transform = CGAffineTransform.identity
                
            }) { _ in
                
                self.animationFinished = true
                self.monthLabel.frame = updatedMonthLabel.frame
                self.monthLabel.text = updatedMonthLabel.text
                self.monthLabel.transform = CGAffineTransform.identity
                self.monthLabel.alpha = 1
                updatedMonthLabel.removeFromSuperview()
            }
            
            self.view.insertSubview(updatedMonthLabel, aboveSubview: self.monthLabel)
        }
    }
    
    func topMarker(shouldDisplayOnDayView dayView: CVCalendarDayView) -> Bool {
        return false
    }
    
    
    func weekdaySymbolType() -> WeekdaySymbolType {
        return .veryShort
    }
    
    func selectionViewPath() -> ((CGRect) -> (UIBezierPath)) {
        return { UIBezierPath(rect: CGRect(x: 0, y: 0, width: $0.width, height: $0.height)) }
    }
    
    func shouldShowCustomSingleSelection() -> Bool {
        return false
    }
    
    func preliminaryView(viewOnDayView dayView: DayView) -> UIView {
        let circleView = CVAuxiliaryView(dayView: dayView, rect: dayView.frame, shape: CVShape.circle)
        circleView.fillColor = .colorFromCode(0xCCCCCC)
        return circleView
    }
    
    func preliminaryView(shouldDisplayOnDayView dayView: DayView) -> Bool {
        if (dayView.isCurrentDay) {
            return true
        }
        return false
    }
    
    func supplementaryView(viewOnDayView dayView: DayView) -> UIView {
        
        dayView.setNeedsLayout()
        dayView.layoutIfNeeded()
        
        let π = M_PI
        
        let ringSpacing: CGFloat = 3.0
        let ringInsetWidth: CGFloat = 1.0
        let ringVerticalOffset: CGFloat = 1.0
        var ringLayer: CAShapeLayer!
        let ringLineWidth: CGFloat = 4.0
        let ringLineColour: UIColor = .blue
        
        let newView = UIView(frame: dayView.frame)
        
        let diameter: CGFloat = (min(newView.bounds.width, newView.bounds.height)) - ringSpacing
        let radius: CGFloat = diameter / 2.0
        
        let rect = CGRect(x: newView.frame.midX-radius, y: newView.frame.midY-radius-ringVerticalOffset, width: diameter, height: diameter)
        
        ringLayer = CAShapeLayer()
        newView.layer.addSublayer(ringLayer)
        
        ringLayer.fillColor = nil
        ringLayer.lineWidth = ringLineWidth
        ringLayer.strokeColor = ringLineColour.cgColor
        
        let ringLineWidthInset: CGFloat = CGFloat(ringLineWidth/2.0) + ringInsetWidth
        let ringRect: CGRect = rect.insetBy(dx: ringLineWidthInset, dy: ringLineWidthInset)
        let centrePoint: CGPoint = CGPoint(x: ringRect.midX, y: ringRect.midY)
        let startAngle: CGFloat = CGFloat(-π/2.0)
        let endAngle: CGFloat = CGFloat(π * 2.0) + startAngle
        let ringPath: UIBezierPath = UIBezierPath(arcCenter: centrePoint, radius: ringRect.width/2.0, startAngle: startAngle, endAngle: endAngle, clockwise: true)
        
        ringLayer.path = ringPath.cgPath
        ringLayer.frame = newView.layer.bounds
        
        return newView
    }
    
    func supplementaryView(shouldDisplayOnDayView dayView: DayView) -> Bool {
        return false
    }
    
    func dayOfWeekTextColor() -> UIColor {
        return UIColor.white
    }
    
    func dayOfWeekBackGroundColor() -> UIColor {
        return UIColor.orange
    }
    
    func disableScrollingBeforeDate() -> Date {
        return Date()
    }
    
    func maxSelectableRange() -> Int {
        return 1
    }
    
    func earliestSelectableDate() -> Date {
        return Date()
    }
    
    func latestSelectableDate() -> Date {
        var dayComponents = DateComponents()
        dayComponents.day = 70
        let calendar = Calendar(identifier: .gregorian)
        if let lastDate = calendar.date(byAdding: dayComponents, to: Date()) {
            return lastDate
        } else {
            return Date()
        }
    }
}


// MARK: - CVCalendarViewAppearanceDelegate
extension BookAppointmentViewController: CVCalendarViewAppearanceDelegate {
    
    func dayLabelWeekdayDisabledColor() -> UIColor {
        return UIColor.lightGray
    }
    
    func dayLabelPresentWeekdayInitallyBold() -> Bool {
        return false
    }
    
    func spaceBetweenDayViews() -> CGFloat {
        return 0
    }
    
    func dayLabelFont(by weekDay: Weekday, status: CVStatus, present: CVPresent) -> UIFont {
        return UIFont(name: "AvenirNext-Regular", size: 15)!
    }
    
    func dayLabelColor(by weekDay: Weekday, status: CVStatus, present: CVPresent) -> UIColor? {
        switch (weekDay, status, present) {
        case (_, .selected, _), (_, .highlighted,_):
            return UIColor.white
        case (.sunday, .in, _):
            return UIColor.black//Color.sundayText
        case (.sunday, _, _):
            return UIColor.black//Color.sundayTextDisabled
        case (_, .in, _):
            return Color.text
        default:
            return Color.textDisabled
        }
    }
    
    func dayLabelBackgroundColor(by weekDay: Weekday, status: CVStatus, present: CVPresent) -> UIColor? {
        switch (weekDay, status, present) {
//        case (.sunday, .selected, _), (.sunday, .highlighted, _):
//            return Color.sundaySelectionBackground
        case (_, .selected, _), (_, .highlighted, _):
            return UIColor(red: 210/255, green: 186/255, blue: 162/255, alpha: 1)
        default: return nil
        }
    }
}

extension BookAppointmentViewController:TimeSelectionDelegate, ServiceSelectionDelegate, StylistSelectionDelegate {
    func getTimeSelection(time: TimeSlot) {
        self.selectedTimeSlot = time
        self.selectedTimeLabel.text = time.startDate!.timeString(ofStyle: .short)
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            self.nextOrEdit()
        }
    }
    
    func getServiceSelection(service: Service) {
        self.selectedService = service
        self.serviceLabel.text = service.name
    }
    
    func getStylistSelection(stylist: Stylist) {
        self.selectedStylist = stylist
        self.stylistLabel.text = stylist.firstName + " " + stylist.lastName
    }
    
}

