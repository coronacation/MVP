//
//  SearchableRecord.swift
//  MVP
//
//  Created by Anthroman on 5/14/20.
//  Copyright © 2020 coronacation. All rights reserved.
//

import Foundation

protocol SearchableRecord {
    func matches(searchTerm: String) -> Bool
}
