//
//  ListOwner.swift
//  PhotoEditor
//
//  Created by Anna Zharkova on 19.05.2022.
//

import Foundation

protocol ListOwner: AnyObject {
    func selectImage(index: Int)
}
