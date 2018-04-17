//
//  RatingControl.swift
//  fourwordreviews
//
//  Created by Lewis Gavin on 17/04/2018.
//  Copyright © 2018 Lewis Gavin. All rights reserved.
//

import UIKit

@IBDesignable class RatingControl: UIStackView {
    
    //MARK: Properties
    private var ratingButtons = [UIButton]()
    @IBInspectable var starSize: CGSize = CGSize(width: 44.0, height: 44.0){
        didSet{
            setupButtons()
        }
    }
    @IBInspectable var starCount: Int = 5 {
        didSet {
            setupButtons()
        }
    }
    
    var rating = 0 {
        didSet{
            updateButtonSelectionStates()
        }
    }

    //MARK: Initialization
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupButtons()
    }
    
    required init(coder: NSCoder) {
        super.init(coder: coder)
        setupButtons()
    }
    
    //MARK: Button Action
    @objc func ratingButtonTapped(button:UIButton){
        guard let index = ratingButtons.index(of: button) else {
            fatalError("The button, \(button), is not in the ratingButtons array: \(ratingButtons)")
        }
        
        // Calculate the rating of the selected button
        let selectedRating = index + 1
        
        if selectedRating == rating {
            // If the selected beer glass represents the current rating, reset to 0
            rating = 0
        }
        else{
            // Otherwise set rating to selected beer glass
            rating = selectedRating
        }
    }
    
    //MARK: Privare methods
    
    private func setupButtons() {
        // clear any existing buttons
        for button in ratingButtons {
            removeArrangedSubview(button)
            button.removeFromSuperview()
        }
        ratingButtons.removeAll()
        
        let bundle = Bundle(for: type(of: self))
        
        let fullGlass = UIImage(named: "fullGlass", in: bundle, compatibleWith: self.traitCollection)
        let emptyGlass = UIImage(named: "emptyGlass", in: bundle, compatibleWith: self.traitCollection)  
        
        for _ in 0..<starCount {
            // Create the button
            let button = UIButton()
            button.setImage(emptyGlass, for: .normal)
            button.setImage(fullGlass, for: .selected)
            button.setImage(fullGlass, for: .highlighted)
            button.setImage(fullGlass, for: [.highlighted, .selected])
            
            
            // Add constraints
            button.translatesAutoresizingMaskIntoConstraints = false
            button.heightAnchor.constraint(equalToConstant: starSize.height).isActive = true
            button.widthAnchor.constraint(equalToConstant: starSize.width).isActive = true
            
            // Setup the button action
            button.addTarget(self, action: #selector(RatingControl.ratingButtonTapped(button:)), for: .touchUpInside)
            
            // Add the button to the stack
            addArrangedSubview(button)
            
            // Add button to the rating button array
            ratingButtons.append(button)
        }
        
        updateButtonSelectionStates()
    }
    
    private func updateButtonSelectionStates(){
        for (index, button) in ratingButtons.enumerated() {
            // If the index of a button is less than the rating, that button should be selected.
            button.isSelected = index < rating
        }
    }

}
