//
// ExhibitViewModel.swift  (shared)
// CityMuseumAppClipApp
//
// Created by MANAS VIJAYWARGIYA on 17/07/25.
// ------------------------------------------------------------------------
// Copyright © 2025 Blacenova. All rights reserved.
// ------------------------------------------------------------------------
//


import SwiftUI

class ExhibitViewModel: ObservableObject {
  @Published var exhibits: [Exhibit] = [
    Exhibit(id: "1", name: "Ancient Vase", description: "A 5th-century BCE ceramic vase from Greece.", imageName: "vase"),
    Exhibit(id: "2", name: "Renaissance Painting", description: "A masterpiece from the 15th century.", imageName: "painting"),
    // Add more exhibits as needed
    ]
  
  @Published var selectedExhibit: Exhibit?
  
  func selectExhibit(id: String) {
    print("selectExhibit \(id)")
    if let exhibit = exhibits.first(where: { $0.id == id }) {
      selectedExhibit = exhibit
    }
  }
}
