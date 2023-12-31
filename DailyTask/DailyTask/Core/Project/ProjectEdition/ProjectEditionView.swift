//
//  ProjectEditionView.swift
//  DailyTask
//
//  Created by Leonardo Mesquita Alves on 05/10/23.
//

import UIKit

protocol ProjectEditionViewDelegate: AnyObject{
    func projectEdit()
}

class ProjectEditionView: UIViewController, UISheetPresentationControllerDelegate {
  
  var isEditable: Bool = false
  
  var viewModel: ProjectEditionViewModel?
  
  override var sheetPresentationController: UISheetPresentationController? {
      presentationController as? UISheetPresentationController
  }
  
  private var sheetDetents: Double = 0
  
  weak var delegate: ProjectEditionViewDelegate?
  
  let selectionFeedbackGenerator = UISelectionFeedbackGenerator()
  let impactFeedbackGenerator = UIImpactFeedbackGenerator(style: .soft)
  
  // MARK: - OFICIAL
  
  let stackViewForCancleAndoDone = {
      let stackView = UIStackView()
      stackView.axis = .horizontal
      stackView.distribution = .equalSpacing
      stackView.translatesAutoresizingMaskIntoConstraints = false
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
  
    var iconButton: ChooseIconComponent?
  
  let textFieldToGetTheName: TextFieldComponent = {
    let textField = TextFieldComponent()
    textField.translatesAutoresizingMaskIntoConstraints = false
    textField.textFieldToGetTheName.textColor = UIColor(.customDescriptionText)
    if let currentFont = textField.textFieldToGetTheName.font {
      textField.textFieldToGetTheName.font = UIFont(descriptor: currentFont.fontDescriptor.withSymbolicTraits(.traitBold)!, size: currentFont.pointSize)
    }
    return textField
  }()
  
  let colorChooser: ColorChooseComponent = {
    let colorChooser = ColorChooseComponent()
    return colorChooser
  }()
  
  let scrollView: UIScrollView = {
    let sv = UIScrollView()
    sv.translatesAutoresizingMaskIntoConstraints = false
    sv.showsVerticalScrollIndicator = false
    return sv
  }()
  
  let stackViewForTheContainer: UIStackView = {
    let stackView = UIStackView()
    stackView.axis = .vertical
    stackView.spacing = 25
    stackView.translatesAutoresizingMaskIntoConstraints = false
    stackView.isLayoutMarginsRelativeArrangement = true
    stackView.layoutMargins = UIEdgeInsets(top: 15, left: 20, bottom: 15, right: 20)
    return stackView
  }()
  
  var methodologyContainer: ContainerComponent?
  let methodologyButton: ChooseMethodologyComponent = {
      let met = ChooseMethodologyComponent(font: UIFont.preferredFont(forTextStyle: .body), text: "Challenge Based Learning (CBL)", textColor: .label)
    return met
  }()
  
  
  var dateContainer: ContainerComponent?
  let deadLine: DeadlineComponent = {
    let deadLine = DeadlineComponent()
    
    return deadLine
  }()
  
  
  var descriptionContainer: ContainerComponent?
  let descriptionTextField: TextDescriptionComponent = {
      let textField = TextDescriptionComponent(placeholderColor: .descriptionPlaceholder, textColor: .descriptionText)
    textField.translatesAutoresizingMaskIntoConstraints = false
    textField.horizontalPadding = 10
    textField.verticalPadding = 10
    return textField
  }()
  
  let updateButton: UIButton = {
    let button = UIButton(primaryAction: nil)
    button.setTitleColor(.white, for: .normal)
      button.backgroundColor = .primaryBlue
    button.layer.cornerRadius = 10
    button.setTitle(String(localized: "Update the project"), for: .normal)
    button.titleLabel?.font = UIFont.preferredFont(forTextStyle: .body)
    button.translatesAutoresizingMaskIntoConstraints = false
    
    return button
  }()
  
  let deleteButton: UIButton = {
    let button = UIButton(primaryAction: nil)
    button.setTitleColor(.systemRed, for: .normal)
    button.setTitle(String(localized: "Delete the project"), for: .normal)
    button.titleLabel?.font = UIFont.preferredFont(forTextStyle: .body)
    button.translatesAutoresizingMaskIntoConstraints = false
    return button
  }()
  
  let barButton = UIBarButtonItem(image: UIImage(systemName: "ellipsis.circle"), style: .plain, target: ProjectEditionView.self, action: nil)
  
  let editLeftButtoniPad: UIButton = {
      let button = UIButton()
      button.setTitle(String(localized: "Cancel"), for: .normal)
      button.setTitleColor(.systemRed, for: .normal)

      return button
  }()
  
  let editRightButtoniPad: UIButton = {
    let button = UIButton()
    button.setTitle(String(localized: "Done"), for: .normal)
    button.setTitleColor(.systemBlue, for: .normal)
    return button
  }()

    let barButtonHamburguer: UIButton = {
      let button = UIButton()
      button.setImage(UIImage(systemName: "ellipsis.circle"), for: .normal)
      return button
    }()
  
  let invisibleSquare: UIView = {
    let square = UIView()
    square.backgroundColor = UIColor(.customLabel)
    square.translatesAutoresizingMaskIntoConstraints = false
    return square
  }()

  let pencilName: UIButton = {
    let pencil = UIButton()
    pencil.setImage(UIImage(systemName: "pencil"), for: .normal)
    pencil.isUserInteractionEnabled = false
    pencil.translatesAutoresizingMaskIntoConstraints = false
    pencil.contentMode = .scaleAspectFit
    pencil.tintColor = UIColor(.customPencilEditName)
    return pencil
  }()
  
  let pencilEditor1: UIButton = {
    let pencil = UIButton()
    pencil.setImage(UIImage(systemName: "pencil"), for: .normal)
    pencil.isUserInteractionEnabled = false
    pencil.contentMode = .scaleAspectFit
    pencil.tintColor = .white
    return pencil
  }()
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
      iconButton = ChooseIconComponent(father: self)
        iconButton!.horizontalPadding = 10
        iconButton!.verticalPadding = 15
        iconButton!.isSelectable = true
        iconButton!.translatesAutoresizingMaskIntoConstraints = false
      
    let bgColor = UIColor(red: viewModel!.project!.red, green: viewModel!.project!.green, blue: viewModel!.project!.blue, alpha: 1)
    
    colorChooser.deselectAllButtons()
    colorChooser.layoutIfNeeded()
    
    setUpDelegates()
    setUpUI()
    addAllConstraints()
    
    selectionFeedbackGenerator.prepare()
    impactFeedbackGenerator.prepare()
    
    verifyIfIsEditable()
    
    textFieldToGetTheName.textFieldToGetTheName.text = viewModel?.project?.name
    methodologyButton.methodology.text = viewModel?.project?.methodology
    deadLine.startDatePicker.setDate((viewModel?.project?.start) ?? Date.now, animated: true)
    deadLine.endDatePicker.setDate((viewModel?.project?.end) ?? Date.now, animated: true)
    descriptionTextField.descriptionBox.text = viewModel?.project?.descript
    iconButton!.changeColor(bgColor: bgColor, tintColor: UIColor.selectTheBestColor(color: bgColor, isBackground: true))
    iconButton!.iconName = viewModel?.project?.icon
    
    
    let contentHeight = stackViewForTheContainer.systemLayoutSizeFitting(UIView.layoutFittingCompressedSize).height + stackViewForTheContainer.systemLayoutSizeFitting(UIView.layoutFittingCompressedSize).height/15
    self.sheetDetents = Double(contentHeight)

    sheetPresentationController?.delegate = self
    sheetPresentationController?.prefersGrabberVisible = true
    sheetPresentationController?.preferredCornerRadius = 10
    sheetPresentationController?.detents = [.custom(resolver: { context in
        return self.sheetDetents
    })]
    
  }
  
  func verifyIfIsEditable(){
    if isEditable {
      
      if UIDevice.current.userInterfaceIdiom == .phone {
        pencilEditor1.isHidden = false
        self.iconButton!.isUserInteractionEnabled = true
        self.descriptionTextField.isUserInteractionEnabled = true
        self.deadLine.isUserInteractionEnabled = true
        self.methodologyButton.hideButton(false)
        self.textFieldToGetTheName.isUserInteractionEnabled = true
        self.colorChooser.isHidden = false
        self.navigationItem.rightBarButtonItem = self.createRightButtom()
        self.navigationItem.leftBarButtonItem = self.createLeftButtom()
        self.stackViewForTitleAndColor.isLayoutMarginsRelativeArrangement = false
        self.updateButton.isHidden = false
        self.deleteButton.isHidden = false
        self.invisibleSquare.isHidden = true
        self.barButtonHamburguer.isHidden = true
      } else if UIDevice.current.userInterfaceIdiom == .pad {
        pencilEditor1.isHidden = false
        self.iconButton!.isUserInteractionEnabled = true
        self.descriptionTextField.isUserInteractionEnabled = true
        self.deadLine.isUserInteractionEnabled = true
        self.methodologyButton.hideButton(false)
        self.textFieldToGetTheName.isUserInteractionEnabled = true
        self.colorChooser.isHidden = false
        self.editLeftButtoniPad.isHidden = false
        self.editRightButtoniPad.isHidden = false
        self.barButtonHamburguer.isHidden = true
        self.invisibleSquare.isHidden = true
        self.stackViewForTitleAndColor.isLayoutMarginsRelativeArrangement = false
        self.updateButton.isHidden = false
        self.deleteButton.isHidden = false
      }
      
      isEditable.toggle()
    } else {
      
      if UIDevice.current.userInterfaceIdiom == .phone {
        pencilEditor1.isHidden = true
        pencilName.isHidden = true
        self.iconButton!.isUserInteractionEnabled = false
        self.descriptionTextField.isUserInteractionEnabled = false
        self.deadLine.isUserInteractionEnabled = false
        self.methodologyButton.hideButton(true)
        self.textFieldToGetTheName.isUserInteractionEnabled = false
        self.colorChooser.isHidden = true
        self.barButton.menu = self.menu()
        self.navigationItem.rightBarButtonItem = self.barButton
        self.barButtonHamburguer.isHidden = true
        self.invisibleSquare.isHidden = true
        self.navigationItem.leftBarButtonItem = nil
        self.stackViewForTitleAndColor.isLayoutMarginsRelativeArrangement = true
        self.stackViewForTitleAndColor.layoutMargins = UIEdgeInsets(top: 19, left: 0, bottom: 19, right: 0)
        self.updateButton.isHidden = true
        self.deleteButton.isHidden = true
        
      } else if UIDevice.current.userInterfaceIdiom == .pad {
        pencilEditor1.isHidden = true
        pencilName.isHidden = true
        self.iconButton!.isUserInteractionEnabled = false
        self.descriptionTextField.isUserInteractionEnabled = false
        self.deadLine.isUserInteractionEnabled = false
        self.methodologyButton.hideButton(true)
        self.textFieldToGetTheName.isUserInteractionEnabled = false
        self.colorChooser.isHidden = true
        self.barButtonHamburguer.isHidden = false
        self.barButtonHamburguer.menu = self.menu()
        self.barButtonHamburguer.showsMenuAsPrimaryAction = true
        self.invisibleSquare.isHidden = false
        self.editLeftButtoniPad.isHidden = true
        self.editRightButtoniPad.isHidden = true
        self.stackViewForTitleAndColor.isLayoutMarginsRelativeArrangement = true
        self.stackViewForTitleAndColor.layoutMargins = UIEdgeInsets(top: 19, left: 0, bottom: 19, right: 0)
        self.updateButton.isHidden = true
        self.deleteButton.isHidden = true
        
      }
    
      isEditable.toggle()
    }
  }
  
  func setUpDelegates(){
    methodologyButton.delegate = self
    colorChooser.delegate = self
    iconButton!.delegate = self
  }
  
  func setUpUI(){
    dateContainer = ContainerComponent(text: String(localized: "DeadLineKey"), textColor: .white, acessibilityLabel: String(localized: "DeadLineKey"), components: [deadLine])
    
    descriptionContainer = ContainerComponent(text: String(localized: "DescriptionKey"),textColor: .white, acessibilityLabel: String(localized: "DescriptionKey"), button: pencilEditor1, components: [descriptionTextField])
    
    methodologyContainer = ContainerComponent(text: String(localized: "Methodology"), textColor: .white, acessibilityLabel: String(localized: "Methodology"), components: [methodologyButton])
    methodologyContainer?.translatesAutoresizingMaskIntoConstraints = false
    
    navigationController?.isNavigationBarHidden = false
    
    self.view.backgroundColor = .systemBackground
    
    self.title = viewModel?.project?.name
    
    self.view.addSubview(scrollView)
    self.scrollView.addSubview(stackViewForTheContainer)
    stackViewForTheContainer.addArrangedSubview(stackViewForIcon)
    stackViewForTheContainer.addArrangedSubview(methodologyContainer!)
    stackViewForTheContainer.addArrangedSubview(dateContainer!)
    stackViewForTheContainer.addArrangedSubview(descriptionContainer!)
    stackViewForIcon.addArrangedSubview(iconButton!)
    stackViewForIcon.addArrangedSubview(stackViewForTitleAndColor)
    stackViewForTitleAndColor.addArrangedSubview(textFieldToGetTheName)
    stackViewForTitleAndColor.addSubview(pencilName)
    stackViewForTitleAndColor.addArrangedSubview(colorChooser)
    
    if UIDevice.current.userInterfaceIdiom == .pad {
        view.addSubview(stackViewForCancleAndoDone)
        stackViewForCancleAndoDone.addArrangedSubview(editLeftButtoniPad)
        stackViewForCancleAndoDone.addArrangedSubview(invisibleSquare)
        stackViewForCancleAndoDone.addArrangedSubview(editTheProject())
        stackViewForCancleAndoDone.addArrangedSubview(editRightButtoniPad)
        stackViewForCancleAndoDone.addArrangedSubview(barButtonHamburguer)
    }
    
    stackViewForTheContainer.addArrangedSubview(updateButton)
    stackViewForTheContainer.addArrangedSubview(deleteButton)
    
    editRightButtoniPad.addTarget(self, action: #selector(defineProjectData), for: .touchUpInside)
    editLeftButtoniPad.addTarget(self, action: #selector(removeTheView), for: .touchUpInside)
        
    updateButton.addTarget(self, action: #selector(defineProjectData), for: .touchUpInside)
    deleteButton.addTarget(self, action: #selector(deleteProject), for: .touchUpInside)
    
    iconButton!.changeColor(bgColor: .systemRed , tintColor: UIColor.selectTheBestColor(color: .systemRed, isBackground: true))
    
    deadLine.startDatePicker.addTarget(self, action: #selector(getStartDate), for: .valueChanged)
    deadLine.endDatePicker.addTarget(self, action: #selector(getEndDate), for: .valueChanged)
    
    if UIDevice.current.userInterfaceIdiom == .phone {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(_:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(_:)), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    let tapGesture = UITapGestureRecognizer(target: self, action: #selector(UIInputViewController.dismissKeyboard))
    tapGesture.cancelsTouchesInView = false
    view.addGestureRecognizer(tapGesture)
  }
  
  deinit{
      if UIDevice.current.userInterfaceIdiom == .phone {
          NotificationCenter.default.removeObserver(self)
      }
  }
  
  func addAllConstraints(){
    
    if UIDevice.current.userInterfaceIdiom == .pad {
        NSLayoutConstraint.activate([
            stackViewForCancleAndoDone.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 17),
            stackViewForCancleAndoDone.bottomAnchor.constraint(equalTo: scrollView.topAnchor),
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
      scrollView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
      
      stackViewForTheContainer.topAnchor.constraint(equalTo: scrollView.topAnchor),
      stackViewForTheContainer.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
      stackViewForTheContainer.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
      stackViewForTheContainer.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
      stackViewForTheContainer.widthAnchor.constraint(equalTo: scrollView.widthAnchor),
      
      iconButton!.widthAnchor.constraint(equalToConstant: 93),
      iconButton!.heightAnchor.constraint(equalToConstant: 93),
      
      pencilName.centerYAnchor.constraint(equalTo: textFieldToGetTheName.centerYAnchor),
      pencilName.trailingAnchor.constraint(equalTo: textFieldToGetTheName.trailingAnchor, constant: -12),
      
      updateButton.heightAnchor.constraint(equalToConstant: 55),
      
      descriptionTextField.heightAnchor.constraint(equalToConstant: 150)
    ])
    
  }
  
  @objc func defineProjectData(){
    if (viewModel?.compareDates() == .orderedAscending){
      self.viewModel?.name = textFieldToGetTheName.getText() == "" ? self.viewModel?.name : textFieldToGetTheName.textFieldToGetTheName.text
      self.viewModel?.description = descriptionTextField.getText() == "" ? self.viewModel?.description : descriptionTextField.getText()
      viewModel?.editProject()
      delegate?.projectEdit()
      verifyIfIsEditable()
    } else {
      let alert = UIAlertController(title: String(localized: "ErrorCreationTaskKey"), message: String(localized: "dateFinalBeforeBegin"), preferredStyle: .alert)
      alert.addAction(UIAlertAction(title: String(localized: "TryAgainKey"), style: .cancel))
      self.present(alert, animated: true)
    }
    
    selectionFeedbackGenerator.selectionChanged()
  }
  
  @objc func dismissKeyboard(){
    view.endEditing(true)
  }
  
  @objc func removeTheView() {
    isEditable = false
    verifyIfIsEditable()
  }
  
  @objc func deleteProject() {
    let alert = UIAlertController(title: String(localized: "sureKey"), message: String(localized: "actionPermanent"), preferredStyle: .alert)
    alert.addAction(UIAlertAction(title: String(localized: "yesKey"), style: .destructive, handler: { _ in
      self.impactFeedbackGenerator.impactOccurred(intensity: 1)
      self.viewModel?.removeProject()
      if UIDevice.current.userInterfaceIdiom == .pad {
        self.delegate?.projectEdit()
        self.dismiss(animated: true)
      } else if UIDevice.current.userInterfaceIdiom == .phone{
        self.viewModel?.removeTopView()
      }
      
    }))
    alert.addAction(UIAlertAction(title: String(localized: "noKey"), style: .cancel))
    self.present(alert, animated: true)
  }
  
  @objc func getStartDate(_ sender: UIDatePicker){
    let selectedDate = sender.date
    viewModel!.start = selectedDate
  }
  
  @objc func getEndDate(_ sender: UIDatePicker){
    let selectedDate = sender.date
    viewModel!.end = selectedDate
  }
  
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

extension ProjectEditionView {
  
  func createRightButtom() -> UIBarButtonItem{
    let buttonToContinue: UIBarButtonItem = {
      let button = UIBarButtonItem()
      button.title = String(localized: "Done")
      button.target = self
      button.action = #selector(defineProjectData)
      return button
    }()
    
    return buttonToContinue
  }
  
  func createLeftButtom() -> UIBarButtonItem{
    let buttonToContinue: UIBarButtonItem = {
      let button = UIBarButtonItem()
      button.title = String(localized: "Cancel")
      button.tintColor = .systemRed
      button.target = self
      button.action = #selector(removeTheView)
      return button
    }()
    
    return buttonToContinue
  }
  
  func editTheProject() -> UILabel{
      let label = UILabel()
      label.text = String(localized: "Update the project")
      label.textColor = .customLabel
      label.font = UIFont.boldSystemFont(ofSize: UIFont.preferredFont(forTextStyle: .body).pointSize)
      return label
  }
  
  @objc func canceliPad(){
      self.dismiss(animated: true)
  }
  
  func menu() -> UIMenu {
    let menuItems = UIMenu(title: "", options: .displayInline, children: [
      UIAction(title: String(localized: "Edit"), image: nil, handler: { _ in
        self.verifyIfIsEditable()
        self.selectionFeedbackGenerator.selectionChanged()
      }),
      UIAction(title: String(localized: "Delete"), image: nil, attributes: .destructive, handler: { _ in
        self.impactFeedbackGenerator.impactOccurred(intensity: 1)
        let alert = UIAlertController(title: String(localized: "sureKey"), message: String(localized: "actionPermanent"), preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: String(localized: "yesKey"), style: .destructive, handler: { _ in
          self.impactFeedbackGenerator.impactOccurred(intensity: 1)
          self.viewModel?.removeProject()
          if UIDevice.current.userInterfaceIdiom == .phone {
            self.viewModel?.removeTopView()
          } else if UIDevice.current.userInterfaceIdiom == .pad {
            self.delegate?.projectEdit()
            self.dismiss(animated: true)
          }
          
        }))
        alert.addAction(UIAlertAction(title: String(localized: "noKey"), style: .cancel))
        self.present(alert, animated: true)
      })
    ])
    
    return menuItems
  }
  
}

extension ProjectEditionView: ChooseMethodologyComponentDelegate {
  
  func setUpMenuFunction(type: Methodologies) {
    self.viewModel?.selectedMethodology(type)
    self.methodologyButton.changeTheMethodologyText(String(describing: self.viewModel!.methodology!))
  }
}

extension ProjectEditionView: ColorChooseComponentDelegate, ChooseIconComponentDelegate {
  func menuWasPressed(_ menuIcon: String) {
  }
  
  func updateColor() {
    let color = colorChooser.returnColorUIColor()
    let CGColor = colorChooser.returnColorCGFloat()
    iconButton!.changeColor(bgColor: color, tintColor: UIColor.selectTheBestColor(color: color, isBackground: true))
    viewModel?.red = CGColor[0]
    viewModel?.green = CGColor[1]
    viewModel?.blue = CGColor[2]
  }
  
}

extension ProjectEditionView: PickIconComponentDelegate{
    func buttonWasPressed(_ menuIcon: String) {
        self.viewModel?.selectedIcon(menuIcon)
        iconButton!.iconName = menuIcon
    }
    
    
}
