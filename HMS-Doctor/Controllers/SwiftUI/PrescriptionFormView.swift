//
//  PrescriptionFormView.swift
//  HMS-Doctor
//
//  Created by RITIK RANJAN on 31/03/25.
//

import SwiftUI

struct PrescriptionFormView: View {

    // MARK: Internal

    weak var delegate: PrescriptionHostingController?

    var body: some View {
        Form {
            Section(header: Text("Patient Diagnosis")) {
                TextField("Enter diagnosis", text: $diagnosis)
            }

            Section(header: Text("Medicines")) {
                if (delegate?.medicines.isEmpty) != nil {
                    Text("No medicines added")
                        .foregroundColor(.gray)
                } else {
//                        ForEach(medicines, id: \.self) { medicine in
//                            VStack(alignment: .leading) {
//                                Text(medicine.name).font(.headline)
//                                Text("Dosage: \(medicine.dosage)")
//                                Text("Frequency: \(medicine.frequency.description)")
//                                    .foregroundColor(.secondary)
//                            }
//                        }
//                        .onDelete { indexSet in
//                            medicines.remove(atOffsets: indexSet)
//                        }
                }

                Button("Add Medicine") {
                    showingMedicineForm.toggle()
                }
            }
        }
        .navigationTitle("New Prescription")
        .toolbar {
            Button("Save") {
                savePrescription()
            }
        }
        .sheet(isPresented: $showingMedicineForm) {
            AddMedicineView { newMedicine in
                delegate?.medicines.append(newMedicine)
            }
        }

    }

    // MARK: Private

    @State private var diagnosis: String = ""
    @State private var showingMedicineForm = false

    private func savePrescription() {
        let newPrescription = Prescription(diagnosis: diagnosis, medicines: delegate!.medicines)

        Task {
            let created = await DataController.shared.addPrescription(newPrescription, to: delegate?.patient)
            if created {
                print("Prescription created successfully")
            }
        }
    }
}

struct AddMedicineView: View {
    @Environment(\.presentationMode) var presentationMode
    @State private var name: String = ""
    @State private var dosage: String = ""
    @State private var selectedFrequency: Frequency = .interval(hours: 6)
    @State private var showingTimePicker = false

    var onSave: (Medicine) -> Void

    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Medicine Details")) {
                    TextField("Name", text: $name)
                    TextField("Dosage", text: $dosage)
                }

                Section(header: Text("Frequency")) {
                    Menu {
                        Button("Khane se pehle, khane ke baad") {
                            selectedFrequency = .interval(hours: 6)
                        }
                        Button("Daily (8 AM, 8 PM)") {
                            selectedFrequency = .daily(times: [
                                DateComponents(hour: 8, minute: 0),
                                DateComponents(hour: 20, minute: 0)
                            ])
                        }
                        Button("Custom Time") {
                            showingTimePicker = true
                        }
                    } label: {
                        HStack {
                            Text("Selected: \(selectedFrequency.description)")
                            Spacer()
                            Image(systemName: "chevron.down")
                        }
                    }
                }
            }
            .navigationTitle("Add Medicine")
            .toolbar {
                Button("Save") {
                    let newMedicine = Medicine(name: name, dosage: dosage, frequency: selectedFrequency)
                    onSave(newMedicine)
                    presentationMode.wrappedValue.dismiss()
                }
            }
            .sheet(isPresented: $showingTimePicker) {
                CustomTimePicker(selectedFrequency: $selectedFrequency)
            }
        }
    }
}

struct CustomTimePicker: View {

    // MARK: Internal

    @Environment(\.presentationMode) var presentationMode
    @Binding var selectedFrequency: Frequency

    var body: some View {
        NavigationView {
            Form {
                DatePicker("Select Time", selection: Binding(
                    get: {
                        let calendar = Calendar.current
                        return calendar.date(from: customTime) ?? Date()
                    },
                    set: { newDate in
                        let calendar = Calendar.current
                        let components = calendar.dateComponents([.hour, .minute], from: newDate)
                        customTime = components
                    }
                ), displayedComponents: .hourAndMinute)
            }
            .navigationTitle("Custom Frequency")
            .toolbar {
                Button("Set") {
                    selectedFrequency = .custom(customTime)
                    presentationMode.wrappedValue.dismiss()
                }
            }
        }
    }

    // MARK: Private

    @State private var customTime: DateComponents = .init(hour: 9, minute: 0)

}
