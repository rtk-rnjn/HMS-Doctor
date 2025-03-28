//
//  AvailabilityView.swift
//  HMS-Doctor
//
//  Created by Shivam Kumar on 27/03/25.
//

import SwiftUI

struct AvailabilityView: View {
    @State private var selectedDates: [Date] = []
    @State private var isOnLeave: Bool = false
    @State private var leaveReason: String = ""

    private let daysLimit = 14
    private let calendar = Calendar.current
    private let today = Date()

    var next14Days: [Date] {
        (1..<daysLimit+1).compactMap { calendar.date(byAdding: .day, value: $0, to: today) }
    }

    var body: some View {
        
            ScrollView {
                VStack(alignment: .leading, spacing: 16) {
                    
                    // Schedule for Multiple Days
                    Text("Schedule for Multiple Days")
                        .font(.headline)
                        .padding(.horizontal)
                    
                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack(spacing: 10) {
                            ForEach(next14Days, id: \.self) { date in
                                VStack {
                                    Text(shortDay(date))
                                        .font(.caption)
                                    
                                    Text(dayNumber(date))
                                        .font(.headline)
                                        .frame(width: 40, height: 40)
                                        .background(selectedDates.contains(date) ? Color.blue : Color.gray.opacity(0.2))
                                        .clipShape(Circle())
                                        .foregroundColor(selectedDates.contains(date) ? .white : .black)
                                        .onTapGesture {
                                            toggleSelection(for: date)
                                        }
                                }
                            }
                        }
                        .padding(.horizontal)
                    }
                    
                    Divider()
                    
                    // Toggle for On Leave
                    Toggle("On Leave", isOn: $isOnLeave)
                        .padding()
                        .background(Color.white)
                        .cornerRadius(10)
                        .padding(.horizontal)

                    // Reason TextField (Only shown when On Leave is enabled)
                    if isOnLeave {
                        VStack(alignment: .leading, spacing: 5) {
                            Text("Reason for Leave")
                                .font(.headline)
                                .padding(.horizontal)
                               
                            
                            TextEditor(text: $leaveReason)
                                .frame(height: 120) // Bigger TextField
                                .padding(8) // Add padding inside the TextEditor
                                .background(Color.white) // Set background to white
                                .clipShape(RoundedRectangle(cornerRadius: 10)) // Apply rounded corners
                                .overlay(
                                    RoundedRectangle(cornerRadius: 10)
                                        .stroke(Color.gray, lineWidth: 1) // Optional: Add a border
                                )
                        }
                        .padding(.horizontal)
                    }
                    
                    Spacer()
                    
                    // Apply Button
                    Button(action: {
                        // Apply leave logic
                    }) {
                        Text("Apply to Selected Days")
                            .font(.headline)
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(selectedDates.isEmpty ? Color.gray.opacity(0.5) : Color.blue)
                            .foregroundColor(.white)
                            .cornerRadius(10)
                    }
                    .padding()
                    .disabled(selectedDates.isEmpty)
                    
                }
            }
            .background(Color(uiColor: .systemGray6))
        
    }
    
    // MARK: - Helpers
    private func shortDay(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "E"
        return formatter.string(from: date)
    }
    
    private func dayNumber(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "d"
        return formatter.string(from: date)
    }
    
    private func formattedDate(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "EEEE, MMM d"
        return formatter.string(from: date)
    }
    
    private func toggleSelection(for date: Date) {
        if let index = selectedDates.firstIndex(of: date) {
            selectedDates.remove(at: index)
        } else if selectedDates.count < daysLimit {
            selectedDates.append(date)
            print("Selected date: \(formattedDate(date))") // Print selected date
        }
    }
}

// MARK: - Preview
struct AvailabilityView_Previews: PreviewProvider {
    static var previews: some View {
        AvailabilityView()
    }
}
