import Foundation
import UIKit


class CachingImages {
  static  let shared = CachingImages()
  var imageCache: NSCache<AnyObject, AnyObject>?
  private init() {
    imageCache = NSCache<AnyObject, AnyObject>()
  }
}
