//
//  ChooseIconComponent.swift
//  DailyTask
//
//  Created by Leonardo Mesquita Alves on 25/09/23.
//

import UIKit

/// This protcol is used to pass what was the string of the selected icon
protocol ChooseIconComponentDelegate: AnyObject{
    func menuWasPressed(_ menuIcon: String)
}

/// A custom button to choose the icon (only Visual | Not functional)
///
///  `ChooseIconComponent` is a subclass of `UIButton` that provides visual elements to the button to choose the icons in the creation of a project or a task
///
/// ## How to use?
///
/// Just create the component like a button and change the horizontal and vertical padding to adapt the button in your design and choose the name of the icon, look at the example:
///
/// ```swift
/// let iconButton: ChooseIconComponent = {
///     let iconPicker = ChooseIconComponent()
///     iconPicker.horizontalPadding = 10
///     iconPicker.verticalPadding = 15
///     iconPicker.iconName = "pencil.tip"
///     iconPicker.color = .systemIndigo
///     iconPicker.bgColor = .white
///     iconPicker.translatesAutoresizingMaskIntoConstraints = false
///     return iconPicker
/// }()
/// ```
///
class ChooseIconComponent: UIButton {
    
    weak var delegate: ChooseIconComponentDelegate?
    
    let selectionFeedbackGenerator = UISelectionFeedbackGenerator()
    var father: UIViewController?
    var verticalPadding: CGFloat = 16
    var horizontalPadding: CGFloat = 16
    var isSelectable: Bool = false {
        didSet{
            if isSelectable{
                tapGesture.isEnabled = true
            } else{
                tapGesture.isEnabled = false
            }
        }
    }
    var iconName: String? {
        didSet{
            setUpIconImage()
        }
    }
    
    var isBackgroung: Bool = false
    
    private let icon: UIImageView = {
        let UIIMageView = UIImageView()
        UIIMageView.image = UIImage(systemName: "pencil.tip")
        UIIMageView.tintColor = .white
        UIIMageView.contentMode = .scaleAspectFit
        UIIMageView.translatesAutoresizingMaskIntoConstraints = false
        return UIIMageView
    }()
    
    private var tapGesture: UITapGestureRecognizer = UITapGestureRecognizer()
    
    init(father: UIViewController) {
        self.father = father
        super.init(frame: .zero)
        
        tapGesture.addTarget(self, action: #selector(setIcon))
        tapGesture.isEnabled = false
        
        addGestureRecognizer(tapGesture)
        setUpUI()
        addAllConstraints()
        selectionFeedbackGenerator.prepare()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // With this function you can managed the icon image out of this class
    private func setUpIconImage(){
        self.icon.image = UIImage(systemName: iconName!)!
    }
    
    /// Function that change the icon and background color of this component
    ///
    /// - Note: You can use it with the `ColorChooseComponentDelegate` function `updateColor()` to change automatically the selected color in the color well
    ///
    func changeColor(bgColor: UIColor, tintColor: UIColor){
        self.backgroundColor = bgColor
        icon.tintColor = tintColor
    }
    
    private func setUpUI(){
        if isBackgroung{
            self.backgroundColor = .systemRed
            icon.tintColor = .white
        } else{
            self.backgroundColor = .systemGray5
            icon.tintColor = .systemRed
        }
        
        self.layer.cornerRadius = 10
        addSubview(icon)
    }
    
    private func addAllConstraints(){
        NSLayoutConstraint.activate([
            icon.topAnchor.constraint(equalTo: topAnchor, constant: -verticalPadding),
            icon.bottomAnchor.constraint(equalTo: bottomAnchor, constant: verticalPadding),
            icon.leadingAnchor.constraint(equalTo: leadingAnchor, constant: horizontalPadding),
            icon.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -horizontalPadding),
        ])
    }
    
    @objc private func setIcon(){

        let modalToGetICon = PickIconModalViewController()
        modalToGetICon.delegate = self.father as? any PickIconComponentDelegate
        father!.present(modalToGetICon, animated: true)
    }
    
}
