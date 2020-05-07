import MapKit
import Foundation
import Contacts

class Artwork: NSObject, MKAnnotation {
  var title: String?
  var locationName: String?
  var discipline: String?
  var coordinate: CLLocationCoordinate2D
  
  init(
    title: String?,
    locationName: String?,
    discipline: String?,
    coordinate: CLLocationCoordinate2D)
  {
    self.title = title
    self.locationName = locationName
    self.discipline = discipline
    self.coordinate = coordinate
    
    super.init()
  }
  
  init?(feature: MKGeoJSONFeature) {
    //1
    guard
      let point = feature.geometry.first as? MKPointAnnotation,
      let propertiesData = feature.properties,
      let json = try? JSONSerialization.jsonObject(with: propertiesData),
      let properties = json as? [String: Any]
      else {
        return nil
    }
    
    //3
    title = properties["title"] as? String
    locationName = properties["location"] as? String
    discipline = properties["discipline"] as? String
    coordinate = point.coordinate
    super.init()
  }
  
  var subtitle: String? {
    return locationName
  }
  
  var mapItem: MKMapItem? {
    guard let location = locationName else {
      return nil
    }
    
    let adressDict = [CNPostalAddressStreetKey: location]
    let placemark = MKPlacemark(coordinate: coordinate,
                                addressDictionary: adressDict)
    let mapItem = MKMapItem(placemark: placemark)
    mapItem.name = title
    return mapItem
  }
  
  var markerTintColor: UIColor {
    switch discipline {
    case "Monument":
      return .red
    case "Mural":
      return .cyan
    case "Plaque":
      return .blue
    case "Sculpture":
      return .purple
    default:
      return .green
    }
  }
  
  var image: UIImage {
    guard let name = discipline else {
      return #imageLiteral(resourceName: "Flag")
    }
    
    switch name {
    case "Monument":
      return #imageLiteral(resourceName: "Monument")
    case "Sculpture":
      return #imageLiteral(resourceName: "Sculpture")
    case "Plaque":
      return #imageLiteral(resourceName: "Plaque")
    case "Mural":
      return #imageLiteral(resourceName: "Mural")
    default:
      return #imageLiteral(resourceName: "Flag")
    }
  }
}
