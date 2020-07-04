//
//  AlertController.swift
//  CoreDataDemoApp
//
//  Created by Ирина Кузнецова on 04.07.2020.
//  Copyright © 2020 Alexey Efimov. All rights reserved.
//

import UIKit

class AlertController: UIAlertController {
        
    func action(task: Task?, completion: @escaping (String) -> Void) {
        let saveAction = UIAlertAction(title: "Save", style: .default) { _ in
            guard let newValue = self.textFields?.first?.text else { return }
            guard !newValue.isEmpty else { return }
            completion(newValue)
        }
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .destructive)
        
        addAction(saveAction)
        addAction(cancelAction)
        addTextField { textField in
            textField.placeholder = "Task"
            textField.text = task?.name
        }
    }
}
