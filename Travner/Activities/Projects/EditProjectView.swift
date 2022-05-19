//
//  EditGuideView.swift
//  Travner
//
//  Created by Lorenzo Lins Mazzarotto on 28/04/22.
//

import CloudKit
import CoreHaptics
import SwiftUI

struct EditGuideView: View {
    enum CloudStatus {
        case checking, exists, absent
    }

    @ObservedObject var guide: Guide

    @EnvironmentObject var dataController: DataController
    @Environment(\.presentationMode) var presentationMode

    @State private var title: String
    @State private var detail: String
    @State private var color: String

    @State private var showingDeleteConfirm = false
    @State private var showingNotificationsError = false

    @State private var remindMe: Bool
    @State private var reminderTime: Date

    @State private var engine = try? CHHapticEngine()

    @AppStorage("username") var username: String?
    @State private var showingSignIn = false

    @State private var cloudStatus = CloudStatus.checking
    @State private var cloudError: CloudError?

    let colorColumns = [
        GridItem(.adaptive(minimum: 44))
    ]

    init(guide: Guide) {
        self.guide = guide

        _title = State(wrappedValue: guide.guideTitle)
        _detail = State(wrappedValue: guide.guideDetail)
        _color = State(wrappedValue: guide.guideColor)

        if let guideReminderTime = guide.reminderTime {
            _reminderTime = State(wrappedValue: guideReminderTime)
            _remindMe = State(wrappedValue: true)
        } else {
            _reminderTime = State(wrappedValue: Date())
            _remindMe = State(wrappedValue: false)
        }
    }

    var body: some View {
        Form {
            Section(header: Text("Basic settings")) {
                TextField("Guide name", text: $title.onChange(update))
                TextField("Description of this guide", text: $detail.onChange(update))
            }

            Section(header: Text("Custom guide color")) {
                LazyVGrid(columns: colorColumns) {
                    ForEach(Guide.colors, id: \.self, content: colorButton)
                }
                .padding(.vertical)
            }

            Section(header: Text("Guide reminders")) {
                Toggle("Show reminders", isOn: $remindMe.animation().onChange(update))
                    .alert(isPresented: $showingNotificationsError) {
                        Alert(
                            title: Text("Oops!"),
                            message: Text("There was a problem. Please check you have notifications enabled."),
                            primaryButton: .default(Text("Check Settings"), action: showAppSettings),
                            secondaryButton: .cancel()
                        )
                    }

                if remindMe {
                    DatePicker(
                        "Reminder time",
                        selection: $reminderTime.onChange(update),
                        displayedComponents: .hourAndMinute
                    )
                }
            }

            // swiftlint:disable:next line_length
            Section(footer: Text("Closing a guide moves it from the Open to Closed tab; deleting it removes the guide completely.")) {
                Button(guide.closed ? "Reopen this guide" : "Close this guide", action: toggleClosed)

                Button("Delete this guide") {
                    showingDeleteConfirm.toggle()
                }
                .accentColor(.red)
                .alert(isPresented: $showingDeleteConfirm) {
                    Alert(
                        title: Text("Delete guide?"),
                        message: Text("Are you sure you want to delete this guide? You will also delete all the items it contains."), // swiftlint:disable:this line_length
                        primaryButton: .default(Text("Delete"), action: delete),
                        secondaryButton: .cancel()
                    )
                }
            }
        }
        .navigationTitle("Edit Guide")
        .toolbar {
            switch cloudStatus {
            case .checking:
                ProgressView()
            case .exists:
                Button {
                    removeFromCloud(deleteLocal: false)
                } label: {
                    Label("Remove from iCloud", systemImage: "icloud.slash")
                }
            case .absent:
                Button(action: uploadToCloud) {
                    Label("Upload to iCloud", systemImage: "icloud.and.arrow.up")
                }
            }
        }
        .onAppear(perform: updateCloudStatus)
        .onDisappear(perform: dataController.save)
        .alert(item: $cloudError) { error in
            Alert(
                title: Text("There was an error"),
                message: Text(error.localizedMessage)
            )
        }
        .sheet(isPresented: $showingSignIn, content: SignInView.init)
    }

    func update() {
        guide.title = title
        guide.detail = detail
        guide.color = color

        if remindMe {
            guide.reminderTime = reminderTime

            dataController.addReminders(for: guide) { success in
                if success == false {
                    guide.reminderTime = nil
                    remindMe = false

                    showingNotificationsError = true
                }
            }
        } else {
            guide.reminderTime = nil
            dataController.removeReminders(for: guide)
        }
    }

    func delete() {
        if cloudStatus == .exists {
            removeFromCloud(deleteLocal: true)
        } else {
            dataController.delete(guide)
            presentationMode.wrappedValue.dismiss()
        }
    }

    func toggleClosed() {
        guide.closed.toggle()

        if guide.closed {
            do {
                try engine?.start()

                let sharpness = CHHapticEventParameter(parameterID: .hapticSharpness, value: 0)
                let intensity = CHHapticEventParameter(parameterID: .hapticIntensity, value: 1)

                let start = CHHapticParameterCurve.ControlPoint(relativeTime: 0, value: 1)
                let end = CHHapticParameterCurve.ControlPoint(relativeTime: 1, value: 0)

                // use that curve to control the haptic strength
                let parameter = CHHapticParameterCurve(
                    parameterID: .hapticIntensityControl,
                    controlPoints: [start, end],
                    relativeTime: 0
                )

                let event1 = CHHapticEvent(
                    eventType: .hapticTransient,
                    parameters: [intensity, sharpness],
                    relativeTime: 0
                )

                // create a continuous haptic event starting immediately and lasting one second
                let event2 = CHHapticEvent(
                    eventType: .hapticContinuous,
                    parameters: [sharpness, intensity],
                    relativeTime: 0.125,
                    duration: 1
                )

                let pattern = try CHHapticPattern(events: [event1, event2], parameterCurves: [parameter])

                let player = try engine?.makePlayer(with: pattern)
                try player?.start(atTime: 0)
            } catch {
                // playing haptics didn't work, but that's okay
            }
        }
    }

    func colorButton(for item: String) -> some View {
        ZStack {
            Color(item)
                .aspectRatio(1, contentMode: .fit)
                .cornerRadius(6)

            if item == color {
                Image(systemName: "checkmark.circle")
                    .foregroundColor(.white)
                    .font(.largeTitle)
            }
        }
        .onTapGesture {
            color = item
            update()
        }
        .accessibilityElement(children: .ignore)
        .accessibilityAddTraits(
            item == color
            ? [.isButton, .isSelected]
            : .isButton
        )
        .accessibilityLabel(LocalizedStringKey(item))
    }

    func showAppSettings() {
        guard let settingsUrl = URL(string: UIApplication.openSettingsURLString) else {
            return
        }

        if UIApplication.shared.canOpenURL(settingsUrl) {
            UIApplication.shared.open(settingsUrl)
        }
    }

    func uploadToCloud() {
        if let username = username {
            let records = guide.prepareCloudRecords(owner: username)
            let operation = CKModifyRecordsOperation(recordsToSave: records, recordIDsToDelete: nil)
            operation.savePolicy = .allKeys

            operation.modifyRecordsCompletionBlock = { _, _, error in
                if let error = error {
                    cloudError = error.getCloudKitError()
                }

                updateCloudStatus()
            }

            cloudStatus = .checking

            CKContainer.default().publicCloudDatabase.add(operation)
        } else {
            showingSignIn = true
        }
    }

    func updateCloudStatus() {
        guide.checkCloudStatus { exists in
            if exists {
                cloudStatus = .exists
            } else {
                cloudStatus = .absent
            }
        }
    }

    func removeFromCloud(deleteLocal: Bool) {
        let name = guide.objectID.uriRepresentation().absoluteString
        let id = CKRecord.ID(recordName: name)

        let operation = CKModifyRecordsOperation(recordsToSave: nil, recordIDsToDelete: [id])

        operation.modifyRecordsCompletionBlock = { _, _, error in
            if let error = error {
                cloudError = error.getCloudKitError()
            } else {
                if deleteLocal {
                    dataController.delete(guide)
                }
            }

            updateCloudStatus()
        }

        cloudStatus = .checking
        CKContainer.default().publicCloudDatabase.add(operation)
    }
}

struct EditGuideView_Previews: PreviewProvider {
    static var previews: some View {
        EditGuideView(guide: Guide.example)
    }
}
