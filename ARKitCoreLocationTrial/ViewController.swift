//
//  ViewController.swift
//  ARKitCoreLocationTrial
//
//  Created by Guy Daher on 04/09/2017.
//  Copyright © 2017 OrganisationName. All rights reserved.
//

import UIKit
import ARCL
import CoreLocation
import InstantSearchCore
import AlgoliaSearch
import InstantSearch

class ViewController: UIViewController {

    var sceneLocationView = SceneLocationView()
    
    let locationManager = CLLocationManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        
        sceneLocationView.run()
        view.addSubview(sceneLocationView)
        
        InstantSearch.shared.configure(appID: "H7UHK81L3U", apiKey: "9a4b6d06db646f8a68617ead3061eaa6", index: "nearyByLocations")
        InstantSearch.shared.searcher.params.aroundRadius = Query.AroundRadius.explicit(3000)
        
        configureLocationManager()
        
        InstantSearch.shared.searcher.params.aroundLatLngViaIP = true
        InstantSearch.shared.searcher.addResultHandler(algoliaResultHandler)
        InstantSearch.shared.searcher.search()
        
//        let sacreCoeur = LocationAnnotationNodeModel(latitude: 48.887784, longitude: 2.340796, altitude: 0, name: "Sacre Coeur")
//        let moulinRouge = LocationAnnotationNodeModel(latitude: 48.884050, longitude: 2.332214, altitude: 0, name: "Mouling Rouge")
//        let EiffelTower = LocationAnnotationNodeModel(latitude: 48.858410, longitude: 2.294427, altitude: 0, name: "EiffelTower")
//        let arcDeTriomphe = LocationAnnotationNodeModel(latitude: 48.873742, longitude: 2.295027, altitude: 0, name: "arcDeTriomphe")
//        let louvre = LocationAnnotationNodeModel(latitude: 48.860597, longitude: 2.337665, altitude: 0, name: "Musee du Louvre")
//        let oldOffice = LocationAnnotationNodeModel(latitude: 48.858287, longitude: 2.349482, altitude: 0, name: "Old Office")
//        let montmartreCemetery = LocationAnnotationNodeModel(latitude: 48.887834, longitude: 2.329844, altitude: 0, name: "Montmartre Cemetery")
//
//         let locationAnnotationNodes: [LocationAnnotationNodeModel] = [sacreCoeur, moulinRouge, EiffelTower, arcDeTriomphe, louvre, oldOffice, montmartreCemetery]
//
//        for locationAnnotationNode in locationAnnotationNodes {
//            let coordinate = CLLocationCoordinate2D(latitude: locationAnnotationNode.latitude, longitude: locationAnnotationNode.longitude)
//            let location = CLLocation(coordinate: coordinate, altitude: locationAnnotationNode.latitude)
//            let image = UIImage.imageWithText(text: locationAnnotationNode.name)
//            let annotationNode = LocationAnnotationNode(location: location, image: image)
//            annotationNode.scaleRelativeToDistance = true
//            sceneLocationView.addLocationNodeWithConfirmedLocation(locationNode: annotationNode)
//        }

    }
    
    func algoliaResultHandler(results: SearchResults?, error: Error?, userInfo: [String: Any]) {
        guard let results = results else { return }
        
        var locationAnnotationNodes: [LocationAnnotationNodeModel] = []
        
        for hit in results.hits {
            let geoloc = hit["_geoloc"] as! [String: Any]
            let lat = geoloc["lat"] as! Double
            let lon = geoloc["lon"] as! Double
            let name = hit["name"] as! String
            let locationAnnotationNodeModel = LocationAnnotationNodeModel(latitude: lat, longitude: lon, altitude: 0, name: name)
            locationAnnotationNodes.append(locationAnnotationNodeModel)
        }
        
        for locationAnnotationNode in locationAnnotationNodes {
            let coordinate = CLLocationCoordinate2D(latitude: locationAnnotationNode.latitude, longitude: locationAnnotationNode.longitude)
            let location = CLLocation(coordinate: coordinate, altitude: locationAnnotationNode.latitude)
            let image = UIImage.imageWithText(text: locationAnnotationNode.name)
            let annotationNode = LocationAnnotationNode(location: location, image: image)
            annotationNode.scaleRelativeToDistance = true
            sceneLocationView.addLocationNodeWithConfirmedLocation(locationNode: annotationNode)
        }
    }
    
    func configureLocationManager() {
        locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
        locationManager.requestWhenInUseAuthorization()
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        sceneLocationView.frame = view.bounds
    }
    
    func resizeImage(image: UIImage, newWidth: CGFloat) -> UIImage? {
        
        let scale = newWidth / image.size.width
        let newHeight = image.size.height * scale
        UIGraphicsBeginImageContext(CGSize(width: newWidth, height: newHeight))
        image.draw(in: CGRect(x: 0, y: 0, width: newWidth, height: newHeight))
        
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return newImage
    }

}

extension UIImage {
    
    class func imageWithText(text: String) -> UIImage {
        let label = UILabel()
        label.numberOfLines = 0
        label.textAlignment = .center
        label.textColor = UIColor.white
        label.backgroundColor = UIColor.black
        label.font = UIFont(name: "Montserrat", size: 60)
        label.text = text
        label.sizeToFit()
        let image = UIImage.imageWithLabel(label: label)
        return resizeImage(image: image, newWidth: 1000)!
    }
    
    class func resizeImage(image: UIImage, newWidth: CGFloat) -> UIImage? {
        
        let scale = newWidth / image.size.width
        let newHeight = image.size.height * scale
        UIGraphicsBeginImageContext(CGSize(width: newWidth, height: newHeight))
        image.draw(in: CGRect(x: 0, y: 0, width: newWidth, height: newHeight))
        
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return newImage
    }
    
    class func imageWithLabel(label: UILabel) -> UIImage {
        UIGraphicsBeginImageContextWithOptions(label.bounds.size, false, 0.0)
        label.layer.render(in: UIGraphicsGetCurrentContext()!)
        let img = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return img!
    }
}

struct Record: Codable {
    var name: String
    var _geoloc: Location
}

struct Location: Codable {
    var lat: Double
    var lon: Double
}

