//
//  Person.swift
//  Name to Faces
//
//  Created by Michele Galvagno on 19/03/2019.
//  Copyright © 2019 Michele Galvagno. All rights reserved.
//

import UIKit

class Person: NSObject {
    var name: String
    var image: String
    
    init(name: String, image: String) {
        self.name = name
        self.image = image
    }
}
