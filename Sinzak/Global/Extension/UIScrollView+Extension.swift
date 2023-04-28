//
//  UIScrollView+Extension.swift
//  Sinzak
//
//  Created by JongHoon on 2023/04/17.
//

import UIKit

public enum ScrollDirection {
    case top
    case center
    case bottom
}

public extension UIScrollView {

    func scroll(to direction: ScrollDirection, animated: Bool = true, completion: (() -> Void)? = nil) {

        DispatchQueue.main.async {
            switch direction {
            case .top:
                self.scrollToTop(animated: animated)
            case .center:
                self.scrollToCenter(animated: animated)
            case .bottom:
                self.scrollToBottom(animated: animated)
            }
            
            guard let completion = completion else { return }
            completion()
        }
    }

    private func scrollToTop(animated: Bool = true) {
        setContentOffset(.zero, animated: animated)
    }

    private func scrollToCenter(animated: Bool = true) {
        let centerOffset = CGPoint(x: 0, y: (contentSize.height - bounds.size.height) / 2)
        setContentOffset(centerOffset, animated: animated)
    }

    private func scrollToBottom(animated: Bool = true) {
        let bottomOffset = CGPoint(x: 0, y: contentSize.height - bounds.size.height + contentInset.bottom)
        if bottomOffset.y > 0 {
            setContentOffset(bottomOffset, animated: animated)
        }
    }
}
