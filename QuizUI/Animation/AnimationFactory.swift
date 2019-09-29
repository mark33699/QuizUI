//
//  AnimationFactory.swift
//  QuizUI
//
//  Created by Mark33699 on 2019/9/26.
//  Copyright © 2019 eLove_ePhone. All rights reserved.
//

import UIKit

typealias Animation = (UITableViewCell, IndexPath, UITableView) -> Void

enum AnimationType: String
{
    case none = "None"
    case zoom = "Zoom"
    case fade = "Fade"
    case bounce = "Bounce"
    case slide = "SlideIn"
}

enum AnimationFactory
{
    static func makeZoomAnimationWith(duration: TimeInterval) -> Animation
    {
        return { cell, indexPath, _ in
            
            cell.layer.transform = CATransform3DMakeScale(0.1, 0.1, 1);
            UIView.animate(withDuration: duration)
            {
                cell.layer.transform = CATransform3DMakeScale(1, 1, 1);
            }
        }
    }
    
	static func makeFadeAnimationWith(duration: TimeInterval, delayFactor: Double) -> Animation
    {
		return { cell, indexPath, _ in
			
            cell.alpha = 0
			UIView.animate(
				withDuration: duration,
				delay: delayFactor * Double(indexPath.row),
				animations: {
					cell.alpha = 1
			})
		}
	}

	static func makeBounceAnimationWith(rowHeight: CGFloat, duration: TimeInterval, delayFactor: Double) -> Animation
    {
		return { cell, indexPath, tableView in
            
			cell.transform = CGAffineTransform(translationX: 0, y: rowHeight)

			UIView.animate(
				withDuration: duration,
				delay: delayFactor * Double(indexPath.row),
				usingSpringWithDamping: 0.4,
				initialSpringVelocity: 0.1,
				options: [.curveEaseInOut],
				animations: {
					cell.transform = CGAffineTransform(translationX: 0, y: 0)
			})
		}
	}

	static func makeSlideInAnimationWith(duration: TimeInterval, delayFactor: Double) -> Animation
    {
		return { cell, indexPath, tableView in
			cell.transform = CGAffineTransform(translationX: tableView.bounds.width, y: 0)

			UIView.animate(
				withDuration: duration,
				delay: delayFactor * Double(indexPath.row),
				options: [.curveEaseInOut],
				animations: {
					cell.transform = CGAffineTransform(translationX: 0, y: 0)
			})
		}
	}
}
