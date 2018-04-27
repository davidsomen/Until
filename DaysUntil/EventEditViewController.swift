//
//  EventEditViewController.swift
//  DaysUntil
//
//  Created by David Somen on 2018/04/06.
//  Copyright © 2018 David Somen. All rights reserved.
//

import UIKit
import RealmSwift

class EventEditViewController: UIViewController, UITextFieldDelegate
{
    @IBOutlet weak var textField: UITextField!
    @IBOutlet weak var datePicker: UIDatePicker!
    @IBOutlet weak var doneButton: StyleButton!
    @IBOutlet weak var cancelButton: StyleButton!
    
    var event: Event?
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        setupTheme()
        
        datePicker.setValue(UIColor.white, forKeyPath: "textColor")
        datePicker.setValue(false, forKey: "highlightsToday")
        
        if let event = event
        {
            textField.text = event.title
            datePicker.date = event.date
        }
        
        doneButton.isEnabled = textField.hasText
    }
    
    private func setupTheme()
    {
        view.backgroundColor = Style.evenCellColor
        textField.backgroundColor = Style.tableColor
        datePicker.backgroundColor = Style.tableColor
        
        doneButton.nonHighlightColor = Style.oddCellColor!
        doneButton.highlightColor = Style.selectedColor!

        cancelButton.nonHighlightColor = Style.oddCellColor!
        cancelButton.highlightColor = Style.selectedColor!
    }
    
    @IBAction func addButtonPressed(_ sender: UIButton)
    {
        dismiss(animated: true)
        {
            let realm = try! Realm()
            
            if let event = self.event
            {
                try! realm.write
                {
                    event.title = self.textField.text!
                    event.date = self.datePicker.date
                }
            }
            else
            {
                let newEvent = Event()
                
                try! realm.write
                {
                    newEvent.title = self.textField.text!
                    newEvent.date = self.datePicker.date
                    
                    realm.add(newEvent)
                }
            }
        }
    }
    
    @IBAction func cancelButtonPressed(_ sender: UIButton)
    {
        dismiss(animated: true)
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool
    {
        let text = (textField.text! as NSString).replacingCharacters(in: range, with: string)

        doneButton.isEnabled = !text.isEmpty
        
        return true
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool
    {
        textField.resignFirstResponder()
        
        textField.text = textField.text?.trimmingCharacters(in: .whitespaces)
        
        return true
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle
    {
        return .lightContent
    }
}
