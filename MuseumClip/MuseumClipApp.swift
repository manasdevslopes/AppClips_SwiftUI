//
// MuseumClipApp.swift
// MuseumClip
//
// Created by MANAS VIJAYWARGIYA on 17/07/25.
// ------------------------------------------------------------------------
// Copyright © 2025 Blacenova. All rights reserved.
// ------------------------------------------------------------------------
//
import AppClip
import CoreLocation
import SwiftUI

@main
struct MuseumClipApp: App {
  @StateObject private var exhibitViewModel = ExhibitViewModel()
  
    var body: some Scene {
        WindowGroup {
            ContentView()
            .environmentObject(exhibitViewModel)
            .onContinueUserActivity(NSUserActivityTypeBrowsingWeb, perform: handleUserActivity)
        }
    }
  
  func handleUserActivity(_ userActivity: NSUserActivity) {
    guard let url = userActivity.webpageURL, let components = URLComponents(url: url, resolvingAgainstBaseURL: true) else {
      return
    }
    let path = components.path // e.g., "/exhibit/1"
    let segments = path.split(separator: "/") // ["exhibit", "1"]
    if segments.count >= 2, segments[0] == "exhibit" {
      let exhibitID = String(segments[1])
      
      verifyLocation(userActivity: userActivity) { inRegion in
        DispatchQueue.main.async {
          exhibitViewModel.selectExhibit(id: exhibitID)
        }
        if inRegion {
          scheduleWelcomeNotification()
        } else {
          print("Not in museum location, skipping notification.")
        }
      }
    }
  }
  
  // MARK: - Location Verification
  func verifyLocation(userActivity: NSUserActivity, completion: @escaping (Bool) -> Void) {
    guard let payload = userActivity.appClipActivationPayload else {
      print("No App Clip Activation Payload")
      completion(false)
      return
    }
    
    let museumCoordinate = CLLocationCoordinate2D(latitude: 37.7749, longitude: -122.4194) // Replace with actual museum location
    let region = CLCircularRegion(center: museumCoordinate, radius: 100, identifier: "CityMuseumRegion")
    
    payload.confirmAcquired(in: region) { inRegion, error in
      if let error = error {
        print("Location verification error: \(error)")
        completion(false)
      } else {
        completion(inRegion)
      }
    }
  }
  
  // MARK: - Notification
  func scheduleWelcomeNotification() {
    let content = UNMutableNotificationContent()
    content.title = "Welcome to City Museum!"
    content.body = "Enjoy your visit and discover new exhibits."
    content.sound = .default
    
    let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 10, repeats: false)
    let request = UNNotificationRequest(identifier: UUID().uuidString, content: content, trigger: trigger)
    
    UNUserNotificationCenter.current().add(request) { error in
      if let error = error {
        print("Failed to schedule welcome notification: \(error)")
      } else {
        print("✅ Welcome notification scheduled.")
      }
    }
  }
}

