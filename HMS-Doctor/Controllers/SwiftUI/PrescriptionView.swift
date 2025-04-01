import SwiftUI

struct PrescriptionCardView: View {
    let prescription: Prescription

    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            Text("Diagnosis: \(prescription.diagnosis)")
                .font(.headline)
                .bold()
                .padding(.bottom, 5)

            if prescription.medicines.isEmpty {
                Text("No medicines prescribed.")
                    .foregroundColor(.gray)
            } else {
                ForEach(prescription.medicines, id: \.id) { medicine in
                    MedicineCard(medicine: medicine)
                }
            }
        }
        .padding()
        .background(RoundedRectangle(cornerRadius: 12).fill(Color(.systemBackground)).shadow(radius: 1))
    }
}

struct MedicineCard: View {
    let medicine: Medicine

    var body: some View {
        VStack(alignment: .leading, spacing: 5) {
            Text(medicine.name)
                .font(.headline)
            Text("Dosage: \(medicine.dosage)")
                .font(.subheadline)
            Text("Frequency: \(medicine.frequency.description)")
                .font(.subheadline)
                .foregroundColor(.gray)
        }
        .padding()
        .background(RoundedRectangle(cornerRadius: 8).fill(Color(.secondarySystemBackground)))

    }
}

#Preview {
    let sampleMedicine = Medicine(name: "Paracetamol", dosage: "500mg", frequency: .interval(hours: 8))
    let samplePrescription = Prescription(diagnosis: "Flu", medicines: [sampleMedicine])

    return PrescriptionCardView(prescription: samplePrescription)
}
