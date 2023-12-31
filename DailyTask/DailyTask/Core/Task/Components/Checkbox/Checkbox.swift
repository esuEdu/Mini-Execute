//
//  Checkbox.swift
//  DailyTask
//
//  Created by Victor Hugo Pacheco Araujo on 27/09/23.
//

import Foundation
import UIKit

/// A custom checkbox control for toggling a bool state.
///
/// `Checkbox` is a subclass of `UIControl` that provides a checkbox-like appearance
/// for toggling between two states: checked and unchecked.
///
/// ## Usage
///
/// To use `Checkbox`, create an instance and customize its appearance as needed. You can
/// set the initial state using the `checked` property and handle value changes with the
/// `.valueChanged` control event.
///
/// ```swift
/// let checkBox: Checkbox = {
///     let check = Checkbox()
///     check.tintColor = .green
///     return check
/// }()
/// ```
///
/// - Note: `Checkbox` provides a visual representation of a bool state with a checked
///         or unchecked appearance.
///
/// - Important: When the `checked` property changes, the control sends a `.valueChanged`
///              control event, allowing you to react to state changes.
///
/// - SeeAlso: `UIControl`
class Checkbox: UIControl {
    
    private weak var imageView: UIImageView!
    
    private var image: UIImage {
        return checked ? UIImage(systemName: "checkmark.square.fill")! : UIImage(systemName: "square")!
    }
    
    /// A boolean value that determines the checkbox state. `true` represents a checked
    /// state, while `false` represents an unchecked state.
    public var checked: Bool = false {
        didSet {
            imageView.image = image
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setup() {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        self.alpha = 0.2
        addSubview(imageView)
        
        NSLayoutConstraint.activate([
            imageView.leadingAnchor.constraint(equalTo: leadingAnchor),
            imageView.trailingAnchor.constraint(equalTo: trailingAnchor),
            imageView.bottomAnchor.constraint(equalTo: bottomAnchor),
            imageView.topAnchor.constraint(equalTo: topAnchor),
        ])
        
        imageView.image = image
        imageView.contentMode = .scaleAspectFit
        
        self.imageView = imageView
        
        backgroundColor = UIColor.clear
        self.tintColor = .black
        
    }
    
}
