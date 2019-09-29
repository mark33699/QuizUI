//
//  UITableView+Extension.swift
//  QuizUI
//
//  Created by Mark33699 on 2019/9/26.
//  Copyright © 2019 eLove_ePhone. All rights reserved.
//

import UIKit

extension UITableView
{
	func isLastVisibleCell(at indexPath: IndexPath) -> Bool
    {
		guard let lastIndexPath = indexPathsForVisibleRows?.last else
        {
			return false
		}
		return lastIndexPath == indexPath
	}
}
