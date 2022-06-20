//
//  GifFavorite+CoreDataProperties.swift
//  
//
//  Created by yupzip on 2022/06/20.
//
//

import Foundation
import CoreData


extension GifFavorite {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<GifFavorite> {
        return NSFetchRequest<GifFavorite>(entityName: "GifFavorite")
    }

    @NSManaged public var id: String?
    @NSManaged public var isFavorite: String?

}
