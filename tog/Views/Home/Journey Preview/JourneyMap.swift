//
//  JourneyMap.swift
//  tog
//
//  Created by Artem Zhukov on 03.10.21.
//

import SwiftUI
import MapKit

// MARK: - SwiftUI View

struct JourneyMap: View {

  let journey: Journey

  @Environment(\.presentationMode) private var presentationMode

  var body: some View {
    ZStack(alignment: .topTrailing) {
      UIJourneyMap(journey: journey)
      Button(action: {
        presentationMode.wrappedValue.dismiss()
      }, label: {
        ZStack {
          Circle()
            .foregroundColor(.primary)
            .frame(width: 30, height: 30)
            .opacity(0.3)
          Globals.Icons.cross
            .foregroundColor(.white)
        }
      })
        .padding()
    }
  }

}

// MARK: - UIKit View

struct UIJourneyMap: UIViewRepresentable {

  let journey: Journey

  private var coordinates: [CLLocationCoordinate2D] {
    var array = [CLLocationCoordinate2D]()
    for leg in journey.legs {
      for halt in leg.halts {
        let coordinate = CLLocationCoordinate2D(latitude: halt.stop.latitude, longitude: halt.stop.longitude)
        array.append(coordinate)
      }
    }
    return array
  }
  private var annotations: [MKAnnotation] {
    var array = [MKAnnotation]()
    for leg in journey.legs {
      let stop = leg.halts.first!.stop
      let annotation = MKPointAnnotation()
      annotation.title = stop.name
      annotation.coordinate = CLLocationCoordinate2D(latitude: stop.latitude, longitude: stop.longitude)
      array.append(annotation)
    }
    // Include destination too:
    let lastStop = journey.lastHalt.stop
    let lastAnnotation = MKPointAnnotation()
    lastAnnotation.title = lastStop.name
    lastAnnotation.coordinate = CLLocationCoordinate2D(latitude: lastStop.latitude, longitude: lastStop.longitude)
    array.append(lastAnnotation)
    return array
  }

  init(journey: Journey) {
    self.journey = journey
  }

  func makeUIView(context: Context) -> MKMapView {
    let mapView = MKMapView()
    mapView.showsUserLocation = true
    mapView.delegate = context.coordinator
    mapView.addAnnotations(annotations)
    return mapView
  }

  func updateUIView(_ uiView: MKMapView, context: Context) {
    let mapView = uiView
    mapView.removeOverlays(mapView.overlays)
    let polyline = MKPolyline(coordinates: coordinates, count: coordinates.count)
    mapView.addOverlay(polyline)
    mapView.showAnnotations(mapView.annotations, animated: true)
  }

  func makeCoordinator() -> MapViewCoordinator {
    MapViewCoordinator(self)
  }

}

// MARK: - UIKit Coordinator
final class MapViewCoordinator: NSObject, MKMapViewDelegate {

  private let map: UIJourneyMap

  init(_ control: UIJourneyMap) {
    self.map = control
  }

  func mapView(_ mapView: MKMapView, didAdd views: [MKAnnotationView]) {
    if let annotationView = views.first, let annotation = annotationView.annotation {
      if annotation is MKUserLocation {
        let region = MKCoordinateRegion(center: annotation.coordinate, latitudinalMeters: 1000, longitudinalMeters: 1000)
        mapView.setRegion(region, animated: true)
      }
    }
  }

  func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
    let renderer = MKPolylineRenderer(overlay: overlay)
    renderer.strokeColor = UIColor(Globals.Colors.mapPolyline)
    renderer.lineWidth = 3.0
    return renderer
  }

}

// MARK: - Previews
struct JourneyMap_Previews: PreviewProvider {
  static var previews: some View {
    JourneyMap(journey: .example)
  }
}
