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

class ViewController: UIViewController {

    var sceneLocationView = SceneLocationView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        sceneLocationView.run()
        view.addSubview(sceneLocationView)
        
        let pontNotreDame = LocationAnnotationNodeModel(latitude: 48.856132, longitude: 2.348648, altitude: 50, name: "Pont Notre Dame")
        let glaceBashir = LocationAnnotationNodeModel(latitude: 48.861800, longitude: 2.351491, altitude: 50, name: "Glace Bashir")
        let perchoirMarais = LocationAnnotationNodeModel(latitude: 48.857523, longitude: 2.353840, altitude: 50, name: "PerchoirMarais")
        let forever21 = LocationAnnotationNodeModel(latitude: 48.860438, longitude: 2.342654, altitude: 50, name: "Forever 21")
        let sacreCoeur = LocationAnnotationNodeModel(latitude: 48.887784, longitude: 2.340796, altitude: 50, name: "Sacre Coeur")
        
        let locationAnnotationNodes: [LocationAnnotationNodeModel] = [pontNotreDame, glaceBashir, perchoirMarais, forever21, sacreCoeur]
        
        for locationAnnotationNode in locationAnnotationNodes {
            let coordinate = CLLocationCoordinate2D(latitude: locationAnnotationNode.latitude, longitude: locationAnnotationNode.longitude)
            let location = CLLocation(coordinate: coordinate, altitude: locationAnnotationNode.latitude)
            let image = UIImage.imageWithText(text: locationAnnotationNode.name)
            let annotationNode = LocationAnnotationNode(location: location, image: image)
            annotationNode.scaleRelativeToDistance = true
            sceneLocationView.addLocationNodeWithConfirmedLocation(locationNode: annotationNode)
        }

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
        return resizeImage(image: image, newWidth: 4000)!
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

