//
//  ContentView.swift
//  Ip-Zukan
//
//  Created by 大場史温 on 2025/06/28.
//

import SwiftUI
import MapKit

struct ContentView: View {
    @State private var demoData = DemoData()
    @State private var selectedItem: MKMapItem? = nil
    
    var body: some View {
        Map {
            ForEach(demoData.data, id: \.id) { animal in
                Annotation(animal.name, coordinate: CLLocationCoordinate2D(latitude: animal.lat, longitude: animal.lon)) {
                    VStack {
                        Image(systemName: "pawprint.fill")
                            .foregroundColor(.red)
                            .background(
                                Circle()
                                    .fill(.white)
                                    .frame(width: 30, height: 30)
                            )
                        Text(animal.name)
                            .font(.caption)
                            .padding(4)
                            .background(.black)
                            .cornerRadius(4)
                    }
                    .onTapGesture {
                        let placemark = MKPlacemark(coordinate: CLLocationCoordinate2D(latitude: animal.lat, longitude: animal.lon))
                        let item = MKMapItem(placemark: placemark)
                        item.name = animal.name
                        selectedItem = item
                    }
                }
            }
        }
        .mapStyle(.standard)
        .mapItemDetailSheet(item: $selectedItem)
    }
}

#Preview {
    ContentView()
}
