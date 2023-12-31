//
//  CreateTaskView.swift
//  DailyTask
//
//  Created by Victor Hugo Pacheco Araujo on 24/09/23.
//

import Foundation
import UIKit

protocol TaskCreationViewDelegate: AnyObject{
    func taskCreated()
}

class CreateTaskView: UIViewController, UISheetPresentationControllerDelegate {
    
    var viewModel: CreateTaskViewModel?
    
    let selectionFeedbackGenerator = UISelectionFeedbackGenerator()
    let impactFeedbackGenerator = UIImpactFeedbackGenerator(style: .soft)
    
    override var sheetPresentationController: UISheetPresentationController? {
        presentationController as? UISheetPresentationController
    }
    
    private var sheetDetents: Double = 0
    
    weak var delegate: TaskCreationViewDelegate?
    
    // Containers
    var priorityContainer: ContainerComponent?
    var dateContainer: ContainerComponent?
    var descriptionContainer: ContainerComponent?
    var subTasksContainer: ContainerComponent?
    
    //Dates
    var dateStart: Date?
    var dateEnd: Date?
    
    // Pickers
    let segmentedControl = SegmentedControl()
    let deadLine = DeadlineComponent()
    var icon: ChooseIconComponent?
    
    let colorPicker: ColorChooseComponent = {
        let colorPicker = ColorChooseComponent()
        colorPicker.translatesAutoresizingMaskIntoConstraints = false
        return colorPicker
    }()
    
    // Buttons
    let buttonDone: UIBarButtonItem = {
        let button = UIBarButtonItem()
        button.title = String(localized: "Done")
        return button
    }()
    
    let buttonCancel: UIBarButtonItem = {
        let button = UIBarButtonItem()
        button.title = String(localized: "Cancel")
        button.tintColor = .red
        return button
    }()
    
    let buttonCreateSubtask: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(systemName: "plus"), for: .normal)
        button.tintColor = UIColor(.customAddIcon)
        return button
    }()
    
    // TextFields
    let nameTextField: TextFieldComponent = {
        let textField = TextFieldComponent()
        textField.textFieldToGetTheName.placeholder = String(localized: "PlaceholderNameTask", comment: "Placeholder text name task")
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.backgroundColor = UIColor(.customTertiaryBlue)
        return textField
    }()
    let descriptionTextField: TextDescriptionComponent = {
        let textField = TextDescriptionComponent(placeholderColor: .descriptionPlaceholder, textColor: .descriptionText)
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.horizontalPadding = 10
        textField.verticalPadding = 10
        return textField
    }()
    
    // Main ScrollView and View
    
    let scrollView: UIScrollView = {
        let sv = UIScrollView()
        sv.translatesAutoresizingMaskIntoConstraints = false
        sv.showsVerticalScrollIndicator = false
        return sv
    }()
    
    // Stack Views
    
    let stackViewForCancleAndoDone = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.distribution = .equalSpacing
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    let stackViewContainers: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = 25
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.isLayoutMarginsRelativeArrangement = true
        if UIDevice.current.userInterfaceIdiom == .pad {
            stackView.layoutMargins = UIEdgeInsets(top: 20, left: 40, bottom: 40, right: 40)
        } else if UIDevice.current.userInterfaceIdiom == .phone {
            stackView.layoutMargins = UIEdgeInsets(top: 20, left: 16, bottom: 16, right: 16)
        }
        return stackView
    }()
    
    let stackViewForTitleAndColor = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.distribution = .fillEqually
        stackView.spacing = 14
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    let stackViewForIcon = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.distribution = .fillProportionally
        stackView.spacing = 14
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    let createButton: UIButton = {
        let button = UIButton(primaryAction: nil)
        button.setTitleColor(.white, for: .normal)
        button.backgroundColor = UIColor(.customPrimaryBlue)
        button.layer.cornerRadius = 10
        button.setTitle(String(localized: "CreateTaskTitleKey"), for: .normal)
        button.titleLabel?.font = UIFont.preferredFont(forTextStyle: .body)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    override func viewDidLoad(){
        super.viewDidLoad()
        
        impactFeedbackGenerator.prepare()
        
        
        configurateComponents()
        setUpUI()
        setConstraints()
        
        let contentHeight = stackViewContainers.systemLayoutSizeFitting(UIView.layoutFittingCompressedSize).height + stackViewContainers.systemLayoutSizeFitting(UIView.layoutFittingCompressedSize).height/15
        self.sheetDetents = Double(contentHeight)
        
        sheetPresentationController?.delegate = self
        sheetPresentationController?.prefersGrabberVisible = true
        sheetPresentationController?.preferredCornerRadius = 10
        sheetPresentationController?.detents = [.custom(resolver: { context in
            return self.sheetDetents
        })]
        
    }
    
    // Configuração para retirar o observador do teclado
    deinit{
        if UIDevice.current.userInterfaceIdiom == .phone {
            NotificationCenter.default.removeObserver(self)
        }
    }
    
    func configurateComponents(){
        // View configuration
        title = String(localized: "CreateTaskTitleKey")
        view.backgroundColor = UIColor(.customBackground)
        icon = ChooseIconComponent(father: self)
        icon!.iconName = "pencil.tip"
        icon!.horizontalPadding = 10
        icon!.verticalPadding = 15
        icon!.isSelectable = true
        icon!.translatesAutoresizingMaskIntoConstraints = false
        
        deadLine.startDatePicker.minimumDate = viewModel?.project?.start
        deadLine.startDatePicker.maximumDate = viewModel?.project?.end
        
        deadLine.startDatePicker.setDate(viewModel?.date ?? Date.now, animated: true)
        
        deadLine.endDatePicker.minimumDate = viewModel?.project?.start
        deadLine.endDatePicker.maximumDate = viewModel?.project?.end
        
        deadLine.endDatePicker.setDate(viewModel?.date ?? Date.now, animated: true)
        
        // Configurate the textfield
        nameTextField.textFieldToGetTheName.returnKeyType = .done
        nameTextField.textFieldToGetTheName.autocapitalizationType = .none
        nameTextField.textFieldToGetTheName.autocorrectionType = .no
        nameTextField.textFieldToGetTheName.keyboardAppearance = .default
        
        // Delegates
        nameTextField.delegate = self
        icon!.delegate = self
        colorPicker.delegate = self
        
        // Constraints activated
        segmentedControl.translatesAutoresizingMaskIntoConstraints = false
        priorityContainer?.translatesAutoresizingMaskIntoConstraints = false
        dateContainer?.translatesAutoresizingMaskIntoConstraints = false
        descriptionContainer?.translatesAutoresizingMaskIntoConstraints = false
        subTasksContainer?.translatesAutoresizingMaskIntoConstraints = false
        
        // Container configuration
        priorityContainer = ContainerComponent(text: String(localized: "PriorityName"), textColor: .white, acessibilityLabel: String(localized: "PriorityName"), components: [segmentedControl])
        dateContainer = ContainerComponent(text: String(localized: "DeadLineKey"), acessibilityLabel: String(localized: "DeadLineKey") , components: [deadLine])
        descriptionContainer = ContainerComponent(text: String(localized: "DescriptionKey"), textColor: .white, acessibilityLabel: String(localized: "DescriptionKey"), components: [descriptionTextField])
        subTasksContainer = ContainerComponent(text: String(localized: "SubtasksKey"), acessibilityLabel: String(localized: "SubtasksKey"), button: buttonCreateSubtask, components: [])
        subTasksContainer?.stackViewContainer.spacing = 8
        
        
        // Button setted with targets and actions
        buttonDone.target = self
        buttonDone.action = #selector(createTask)
        buttonCancel.target = self
        buttonCancel.action = #selector(cancelTask)
        deadLine.startDatePicker.addTarget(self, action: #selector(getStartDate), for: .valueChanged)
        deadLine.endDatePicker.addTarget(self, action: #selector(getEndDate), for: .valueChanged)
        buttonCreateSubtask.addTarget(self, action: #selector(createSubtask), for: .touchUpInside)
        createButton.addTarget(self, action: #selector(createTask), for: .touchUpInside)
        
        
        // Configuração para retirar o observador do teclado
        if UIDevice.current.userInterfaceIdiom == .phone {
            NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(_:)), name: UIResponder.keyboardWillShowNotification, object: nil)
            NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(_:)), name: UIResponder.keyboardWillHideNotification, object: nil)
        }
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(UIInputViewController.dismissKeyboard))
        tapGesture.cancelsTouchesInView = false
        view.addGestureRecognizer(tapGesture)
        
        deadLine.startDatePicker.minimumDate = viewModel?.project?.start
        deadLine.startDatePicker.maximumDate = viewModel?.project?.end
        
        deadLine.endDatePicker.minimumDate = viewModel?.project?.start
        deadLine.endDatePicker.maximumDate = viewModel?.project?.end
        
    }
    
    func setUpUI(){
        navigationController?.isNavigationBarHidden = false
        
        navigationItem.rightBarButtonItem = buttonDone
        navigationItem.leftBarButtonItem = buttonCancel
        
        view.addSubview(scrollView)
        scrollView.addSubview(stackViewContainers)
        
        
        
        stackViewContainers.addArrangedSubview(stackViewForIcon)
        stackViewContainers.addArrangedSubview(dateContainer!)
        stackViewContainers.addArrangedSubview(priorityContainer!)
        stackViewContainers.addArrangedSubview(subTasksContainer!)
        stackViewContainers.addArrangedSubview(descriptionContainer!)
        stackViewContainers.addArrangedSubview(createButton)
        
        stackViewForIcon.addArrangedSubview(icon!)
        stackViewForIcon.addArrangedSubview(stackViewForTitleAndColor)
        
        stackViewForTitleAndColor.addArrangedSubview(nameTextField)
        stackViewForTitleAndColor.addArrangedSubview(colorPicker)
        
        if UIDevice.current.userInterfaceIdiom == .pad {
            view.addSubview(stackViewForCancleAndoDone)
            stackViewForCancleAndoDone.addArrangedSubview(createLeftButtoniPad())
            stackViewForCancleAndoDone.addArrangedSubview(createTaskIpad())
            stackViewForCancleAndoDone.addArrangedSubview(createRightButtoniPad())
        }
        
    }
    
    func createNewSubtask(){
        let subTasksComponent = SubtasksInTasksComponent(name: "teste")
        subTasksContainer?.stackViewContainer.addArrangedSubview(subTasksComponent)
    }
    
    func setConstraints(){
        
        if UIDevice.current.userInterfaceIdiom == .pad {
            NSLayoutConstraint.activate([
                stackViewForCancleAndoDone.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 17),
                //stackViewForCancleAndoDone.bottomAnchor.constraint(equalTo: scrollView.topAnchor),
                stackViewForCancleAndoDone.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
                stackViewForCancleAndoDone.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
                
                scrollView.topAnchor.constraint(equalTo: stackViewForCancleAndoDone.bottomAnchor),
                
            ])
        } else if UIDevice.current.userInterfaceIdiom == .phone {
            scrollView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor).isActive = true
        }
        
        NSLayoutConstraint.activate([
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            //            scrollView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            
            stackViewContainers.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            stackViewContainers.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            stackViewContainers.topAnchor.constraint(equalTo: scrollView.topAnchor),
            stackViewContainers.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            stackViewContainers.widthAnchor.constraint(equalTo: scrollView.widthAnchor),
            
            icon!.widthAnchor.constraint(equalToConstant: 93),
            icon!.heightAnchor.constraint(equalToConstant: 93),
            
            createButton.heightAnchor.constraint(equalToConstant: 55),
            
            descriptionTextField.heightAnchor.constraint(equalToConstant: 150),
        ])
    }
    
}

extension CreateTaskView: TextFieldComponentDelegate {
    func textFieldDidEndEditing() {
        
    }
    
    func textFieldDidBeginEditing() {
        
    }
    
    // Button actions
    @objc func createTask() {
        let color = colorPicker.returnColorCGFloat()
        let red = color[0]
        let green = color[1]
        let blue = color[2]
        
        var subtask: [String] = []
        
        for component in subTasksContainer!.stackViewContainer.arrangedSubviews {
            let compon = component as! SubtasksInTasksComponent
            subtask.append(compon.returnText())
        }
        
        self.viewModel?.createTask(name: self.nameTextField.textFieldToGetTheName.text != "" ? self.nameTextField.textFieldToGetTheName.text! : String(localized: "noNameKey"), startDate: self.dateStart ?? Date.now, endDate: self.dateEnd ?? Date.now, priority: self.segmentedControl.priority ?? Priority.noPriority.rawValue, descript: self.descriptionTextField.getText() != "" ? self.descriptionTextField.getText() : String(localized: "noDescKey"), red: red, green: green, blue: blue, subtasks: subtask, icon: icon!.iconName!)
        
        if UIDevice.current.userInterfaceIdiom == .phone {
            self.viewModel?.removeLastView()
        } else if UIDevice.current.userInterfaceIdiom == .pad {
            self.delegate?.taskCreated()
            self.dismiss(animated: true)
        }
        
        impactFeedbackGenerator.impactOccurred(intensity: 1)
        
    }
    
    @objc func dismissKeyboard(){
        view.endEditing(true)
    }
    
    @objc func cancelTask(){
        viewModel?.removeLastView()
        impactFeedbackGenerator.impactOccurred(intensity: 1)
    }
    
    @objc func getStartDate(_ sender: UIDatePicker){
        let selectDate = sender.date
        self.dateStart = selectDate
        deadLine.endDatePicker.minimumDate = selectDate
    }
    
    @objc func createSubtask(){
        let subtask = SubtasksInTasksComponent(name: "")
        subtask.deleteButton.tag = (subTasksContainer?.getPosition())!
        subtask.deleteButton.addTarget(self, action: #selector(removeAtPosition), for: .touchUpInside)
        subTasksContainer?.addNewElements(subtask)
        
        selectionFeedbackGenerator.selectionChanged()
        
    }
    
    @objc func removeAtPosition(_ button: UIButton){
        let tag = button.tag
        let subtask = subTasksContainer?.stackViewContainer.arrangedSubviews[tag]
        subTasksContainer?.stackViewContainer.removeArrangedSubview(subtask!)
        subtask?.removeFromSuperview()
        
        for (index,component) in subTasksContainer!.stackViewContainer.arrangedSubviews.enumerated() {
            let compon = component as! SubtasksInTasksComponent
            compon.deleteButton.tag = index
            impactFeedbackGenerator.impactOccurred()
        }
        
    }
    
    @objc func getEndDate(_ sender: UIDatePicker){
        let selectDate = sender.date
        self.dateEnd = selectDate
    }
    
    // Configuração para retirar o observador do teclado (TE AMO GEPETO)
    @objc func keyboardWillShow(_ notification: Notification) {
        if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
            
            let contentInset = UIEdgeInsets(top: 0, left: 0, bottom: keyboardSize.height, right: 0)
            scrollView.contentInset = contentInset
            scrollView.scrollIndicatorInsets = contentInset
        }
    }
    
    @objc func keyboardWillHide(_ notification: Notification) {
        scrollView.contentInset = .zero
        scrollView.scrollIndicatorInsets = .zero
    }
    
}

extension CreateTaskView: ChooseIconComponentDelegate, ColorChooseComponentDelegate{
    // Pickers cofigurations with delegate
    func updateColor() {
        let color = colorPicker.returnColorUIColor()
        icon!.changeColor(bgColor: UIColor.selectTheBestColor(color: color, isBackground: false), tintColor: color)
    }
    
    func menuWasPressed(_ menuIcon: String) {
        
    }
}

extension CreateTaskView: PickIconComponentDelegate{
    func buttonWasPressed(_ menuIcon: String) {
        icon!.iconName = menuIcon
    }
    
    
}


extension CreateTaskView {
    
    func createRightButtoniPad() -> UIButton{
        let buttonToContinue: UIButton = {
            let button = UIButton()
            button.setTitle(String(localized: "Done"), for: .normal)
            button.setTitleColor(.systemBlue, for: .normal)
            button.addTarget(self, action: #selector(createTask), for: .touchUpInside)
            return button
        }()
        
        return buttonToContinue
    }
    
    func createLeftButtoniPad() -> UIButton{
        let buttonToContinue: UIButton = {
            let button = UIButton()
            button.setTitle(String(localized: "Cancel"), for: .normal)
            button.setTitleColor(.systemRed, for: .normal)
            button.addTarget(self, action: #selector(cancelIpad), for: .touchUpInside)
            
            return button
        }()
        
        return buttonToContinue
    }
    
    func createTaskIpad() -> UILabel{
        let label = UILabel()
        label.text = String(localized: "CreateTaskTitleKey")
        label.textColor = .customLabel
        label.font = UIFont.boldSystemFont(ofSize: UIFont.preferredFont(forTextStyle: .body).pointSize)
        return label
    }
    
    @objc func cancelIpad(){
        impactFeedbackGenerator.impactOccurred(intensity: 1)
        self.dismiss(animated: true)
    }
    
    
}
