//
//  CustomSegue.swift
//  vkontakteVS
//
//  Created by Admin on 19.08.2021.
//

import UIKit

class CustomSegue: UIStoryboardSegue {
    private let animationDuration: TimeInterval = 1
    
    override func perform() {
        guard let conteinerView = source.view else { return }
        conteinerView.addSubview(destination.view)
        
        destination.view.frame = conteinerView.frame
        destination.view.transform = CGAffineTransform(translationX: 0, y: -source.view.bounds.height)
        
        UIView.animate(withDuration: animationDuration) {
            self.destination.view.transform = .identity
        } //completion: { _ in
          //  self.source.present(self.destination, animated: false)
      //  }
    }
}
