//
//  ProjectListView.swift
//  DailyTask
//
//  Created by Leonardo Mesquita Alves on 23/09/23.
//

import UIKit

class ProjectListView: UIViewController {
  
  var projectListViewModel: ProjectListViewModel?
  
  let selectionFeedbackGenerator = UISelectionFeedbackGenerator()
  let impactFeedbackGenerator = UIImpactFeedbackGenerator(style: .heavy)
  let impactFeedback = UIImpactFeedbackGenerator(style: .soft)
  
  // MARK: - Creating and setting the UIElements
  let scrollView = ScrollContainerComponent()
  
  let buttonToCreateANewProject: UIButton = {
    let button = UIButton()
    button.setTitle("+ \(String(localized: "NewProjectKey"))", for: .normal)
    
    button.translatesAutoresizingMaskIntoConstraints = false
    
    var config = UIButton.Configuration.filled()
    
    config.baseBackgroundColor = UIColor.accent
    config.background.cornerRadius = 10
    
    let spacing: CGFloat = 5
    config.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: spacing, bottom: 0, trailing: spacing)
    
    button.configuration = config
    
    return button
  }()
  
  let searchBar: UISearchBar = {
    let search = UISearchBar()
    search.placeholder = String(localized: "SearchProjectsPlaceholder")
    search.translatesAutoresizingMaskIntoConstraints = false
    search.setBackgroundImage(UIImage(), for: .any, barMetrics: .default)
    return search
  }()
  
  let stackViewForHeader: UIStackView = {
    let stackView = UIStackView()
    stackView.axis = .horizontal
    stackView.distribution = .equalSpacing
    stackView.translatesAutoresizingMaskIntoConstraints = false
    stackView.isLayoutMarginsRelativeArrangement = true
    stackView.layoutMargins = UIEdgeInsets(top: 20, left: 0, bottom: 0, right: 0)
    return stackView
  }()
  
    let myProjectLabel: LabelComponent = {
        let label = LabelComponent(text: String(localized: "MyProjectKey"), accessibilityLabel: String(localized: "MyProjectKey"), textColor: .accent, font: .title1)
        label.translatesAutoresizingMaskIntoConstraints =  false
        label.textLabel.font = .boldTitle1
        return label
    }()
  
  // Setting up the UIElements and constraint
  override func viewDidLoad() {
    super.viewDidLoad()
    
    selectionFeedbackGenerator.prepare()
    impactFeedbackGenerator.prepare()
    impactFeedback.prepare()
    
    setUpUI()
    addAllConstraints()
  }
  
  // Creating the UIElements setups
  func setUpUI(){
    
    view.backgroundColor = .background
    
    scrollView.translatesAutoresizingMaskIntoConstraints = false
    
    navigationController?.setNavigationBarHidden(true, animated: false)
    view.addSubview(scrollView)
    
    view.addSubview(searchBar)
    view.addSubview(stackViewForHeader)
    
    
    stackViewForHeader.addArrangedSubview(myProjectLabel)
    stackViewForHeader.addArrangedSubview(buttonToCreateANewProject)
    
    searchBar.delegate = self
    
    buttonToCreateANewProject.addTarget(self, action: #selector(createNewProject), for: .touchUpInside)
    
    let tapGesture = UITapGestureRecognizer(target: self, action: #selector(UIInputViewController.dismissKeyboard))
    tapGesture.cancelsTouchesInView = false
    view.addGestureRecognizer(tapGesture)
  }
  
  // Adding constraint
  func addAllConstraints(){
    NSLayoutConstraint.activate([
      stackViewForHeader.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
      stackViewForHeader.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
      stackViewForHeader.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
      stackViewForHeader.bottomAnchor.constraint(equalTo: searchBar.topAnchor, constant: -10),
      
      searchBar.topAnchor.constraint(equalTo: stackViewForHeader.bottomAnchor, constant: 10),
      searchBar.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 8),
      searchBar.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -7),
      searchBar.bottomAnchor.constraint(equalTo: scrollView.topAnchor),
      
      scrollView.topAnchor.constraint(equalTo: searchBar.bottomAnchor),
      scrollView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
      scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
      scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
    ])
  }
  
  func addElements(){
    
    scrollView.removeAllElements()
    
    projectListViewModel?.fetchProjectViewModel()
    for element in projectListViewModel!.project{
      let color = UIColor(red: element.red, green: element.green, blue: element.blue, alpha: 1)
      let textColor = UIColor.selectTheBestColor(color: color, isBackground: true)
      let container = ContainerProjectsList(title: element.name!, acessibilityLabelNameProject: element.name! ,titleColor: textColor, description: element.descript!, acessibilityLabelDescProject: element.descript!, descriptionColor: .label, percentage: "50", percentageColor: .label, imageIcon:  UIImage(systemName: element.icon!)!, imageIconColor: textColor, chevronColor: textColor,bgColor: color, id: element.id!, element: element)
      container.delegate = self
      scrollView.addNewElements(container)
      scrollView.layoutIfNeeded()
    }
  }
  
  func removeAtPosition(project: Project){
    for n in scrollView.stackViewToShowElements.arrangedSubviews{
      let r = n as! ContainerProjectsList
      if r.project == project{
        r.removeFromSuperview()
        self.scrollView.layoutIfNeeded()
      }
    }
  }
  
  // MARK: - Button functions
  @objc func createNewProject(){
    self.selectionFeedbackGenerator.selectionChanged()
      projectListViewModel?.coordinator?.goToProjectCreation(delegate: self)
  }
  
  @objc func dismissKeyboard(){
    view.endEditing(true)
  }
  
  override func viewIsAppearing(_ animated: Bool) {
    addElements()
    navigationController?.isNavigationBarHidden = true
  }
  
}

extension ProjectListView: ContainerProjectsListDelegate{

    func setUpAlert(project: Project, gesture: CGPoint, delegate: ContainerProjectsList) {
        
        let alert = UIAlertController(title: "\(project.name!)", message: nil, preferredStyle: .actionSheet)
        self.impactFeedbackGenerator.impactOccurred()
        alert.addAction(UIAlertAction(title: String(localized: "Cancel"), style: .cancel, handler: nil))
        
        alert.addAction(UIAlertAction(title: String(localized: "Edit"), style: .default, handler: { action in
            self.selectionFeedbackGenerator.selectionChanged()
          self.projectListViewModel?.goToEditProject(project, isEditable: true, delegate: self)
        }))
        alert.addAction(UIAlertAction(title: String(localized: "details"), style: .default, handler: { action in
            self.selectionFeedbackGenerator.selectionChanged()
          self.projectListViewModel?.goToEditProject(project, isEditable: false, delegate: self)
        }))
        alert.addAction(UIAlertAction(title: String(localized: "Delete"), style: .destructive, handler: { action in
            self.impactFeedback.impactOccurred(intensity: 1)
            self.removeAtPosition(project: project)
            self.projectListViewModel?.deleteAProject(project: project)
        }))
        
        if UIDevice.current.userInterfaceIdiom == .phone {
            alert.modalPresentationStyle = .overCurrentContext
        } else if UIDevice.current.userInterfaceIdiom == .pad {
            alert.modalPresentationStyle = .popover
            if let popoverPresentationController = alert.popoverPresentationController {
                popoverPresentationController.sourceView = delegate
                popoverPresentationController.sourceRect = CGRect(x: gesture.x, y: gesture.y, width: 0, height: 0)
                popoverPresentationController.permittedArrowDirections = .any
            }
        }
        
        
        present(alert, animated: true, completion: nil)
  }
  
  func goToTheTaskView(project: Project) {
    self.selectionFeedbackGenerator.selectionChanged()
    projectListViewModel?.goToTaskList(project)
  }
}

extension ProjectListView: UISearchBarDelegate {
  
  func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
    if searchText.contains("\n"){
      searchBar.resignFirstResponder()
    }
    scrollView.contains(searchText)
    scrollView.layoutIfNeeded()
  }
  
  func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
    searchBar.setShowsCancelButton(true, animated: true)
    
  }
  
  func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
    searchBar.setShowsCancelButton(false, animated: true)
  }
  
  func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
    searchBar.endEditing(true)
  }
  
}

extension ProjectListView: ProjectCreationViewDelegate, ProjectEditionViewDelegate {
  func projectEdit() {
    addElements()
  }
  
    func projectCreated() {
        addElements()
    }
    
    
}
