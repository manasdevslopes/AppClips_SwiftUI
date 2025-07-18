//
// ContentView.swift
// MuseumClip
//
// Created by MANAS VIJAYWARGIYA on 17/07/25.
// ------------------------------------------------------------------------
// Copyright © 2025 Blacenova. All rights reserved.
// ------------------------------------------------------------------------
//
import UserNotifications
import StoreKit
import SwiftUI

struct ContentView: View {
  @EnvironmentObject var exhibitViewModel: ExhibitViewModel
  @State private var isPresentingAppStoreOverlay: Bool = false
  
  var body: some View {
    if let exhibit = exhibitViewModel.selectedExhibit {
      VStack {
        Image(exhibit.imageName).resizable().scaledToFit().frame(maxHeight: 200)
        Text(exhibit.name).font(.title).padding(.top)
        Text(exhibit.description).font(.body).multilineTextAlignment(.center).padding()
        Button {
          // Implement SKOverlay to prompt full app download
          isPresentingAppStoreOverlay.toggle()
          requestAndScheduleEphemeralNotification(for: exhibit)
        } label: {
          Text("Explore More")
            .font(.headline).padding().frame(maxWidth: .infinity)
            .background(Color.blue).foregroundColor(.white).cornerRadius(10)
        }
        .padding(.horizontal)
      }
      .padding()
      .appStoreOverlay(isPresented: $isPresentingAppStoreOverlay) {
        SKOverlay.AppClipConfiguration(position: .bottom)
      }
    } else {
      Text("No exhibit selected").font(.title2).foregroundColor(.gray)
    }
  }
}

extension ContentView {
  func requestAndScheduleEphemeralNotification(for exhibit: Exhibit) {
    let center = UNUserNotificationCenter.current()
    
    center.getNotificationSettings { settings in
      if settings.authorizationStatus == .ephemeral {
        scheduleCustomNotification1(for: exhibit)
      } else {
        center.requestAuthorization(options: [.alert, .sound]) { granted, error in
          if granted {
            scheduleCustomNotification1(for: exhibit)
          }
        }
      }
    }
  }
  
  func scheduleCustomNotification1(for exhibit: Exhibit) {
    let content = UNMutableNotificationContent()
    content.title = exhibit.name
    content.body = "Learn more about \"\(exhibit.name)\" in the full City Museum app."
    content.sound = UNNotificationSound(named: UNNotificationSoundName("NotificaitonSound.aiff")) // .default
    
    let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 10, repeats: false)
    let request = UNNotificationRequest(identifier: UUID().uuidString, content: content, trigger: trigger)
    
    UNUserNotificationCenter.current().add(request) { error in
      if let error = error {
        print("Failed to schedule: \(error)")
      } else {
        print("Custom notification scheduled.")
      }
    }
  }
}

#Preview {
  ContentView().environmentObject(ExhibitViewModel())
}
