//
//  Sponsor.swift
//  GreachConf
//
//  Created by Softamo S.L.U on 22/05/16.
//  Copyright © 2016 Razeware LLC. All rights reserved.
//

import UIKit

class Sponsor {
    var kind: String!
    var url: String!
    var imageUrl: String!
    
    init(kind: String!, url: String!, imageUrl: String!) {
        self.kind = kind
        self.url = url
        self.imageUrl = imageUrl
    }
}
