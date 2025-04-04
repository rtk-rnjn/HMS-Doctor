//
//  AvailabilityView.swift
//  HMS-Doctor
//
//  Created by Shivam Kumar on 27/03/25.
//

import SwiftUI

struct AvailabilityView: View {
    // MARK: - Properties
    var appointments: [Appointment] = []

    @State private var selectedDates: Set<Date> = []
    @State private var isOnLeave: Bool = false
    @State private var leaveReason: String = ""
    @State private var showingConfirmation = false
    @State private var isRangeMode = false
    @State private var rangeStart: Date?
    @State private var showTooltip = false
    @State private var showReasonAlert = false
    
    private let calendar = Calendar.current
    private let today = Date()
    private let daysLimit = 14
    private let haptics = UINotificationFeedbackGenerator()
    private let selectionHaptics = UISelectionFeedbackGenerator()
    private let impactHaptics = UIImpactFeedbackGenerator(style: .medium)
    
    private let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "MMM d, yyyy"
        return formatter
    }()
    

    var next14Days: [Date] {
        (1..<daysLimit+1).compactMap { calendar.date(byAdding: .day, value: $0, to: today) }
    }
    
    var body: some View {
        ZStack(alignment: .bottomTrailing) {
            mainContent
            selectionModeButton
        }
        .background(Color(.systemGroupedBackground).ignoresSafeArea())
        .onAppear {
            selectionHaptics.prepare()
            haptics.prepare()
            impactHaptics.prepare()
        }
        .alert("Write the reason for leave", isPresented: $showReasonAlert) {
            Button("OK", role: .cancel) { }
        }
        .alert("Confirm Application", isPresented: $showingConfirmation) {
            Button("Cancel", role: .cancel) {
                haptics.notificationOccurred(.warning)
            }
            Button("Confirm") {
                applyForLeave()
            }
        } message: {
            if isOnLeave {
                Text("Are you sure you want to apply for leave?")
            } else {
                Text("Are you sure you want to mark your availability for \(selectedDates.count) date\(selectedDates.count > 1 ? "s" : "")?")
            }
        }
    }
    
    // MARK: - View Components
    private var mainContent: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 24) {
                headerSection
                calendarSection
                leaveSection
                applyButton
            }
        }
    }
    
    private var headerSection: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("Schedule for Multiple Days")
                .font(.title2.bold())
                .foregroundColor(.primary)
            Text("Select dates to mark your availability")
                .font(.subheadline)
                .foregroundColor(.secondary)
        }
        .padding(.horizontal)
        .padding(.top, 8)
    }
    
    private var calendarSection: some View {
        VStack(spacing: 20) {
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 12) {
                    ForEach(Array(zip(next14Days.indices, next14Days)), id: \.1) { index, date in
                        DateCircle(
                            date: date,
                            isSelected: selectedDates.contains(date),
                            isInRange: isDateInRange(date),
                            isRangeStart: isRangeMode && date == rangeStart,
                            isRangeEnd: isRangeMode && rangeStart != nil && date > rangeStart!,
                            showTrailingLine: isRangeMode && shouldShowTrailingLine(for: date),
                            showLeadingLine: isRangeMode && shouldShowLeadingLine(for: date),
                            onTap: { handleDateSelection(date) }
                        )
                        .transition(.scale.combined(with: .opacity))
                    }
                }
                .padding(.horizontal)
            }
            
            if !selectedDates.isEmpty {
                selectedDatesSummary
            }
        }
        .padding(.vertical, 8)
    }
    
    private var selectedDatesSummary: some View {
        VStack(spacing: 12) {
            HStack {
                Image(systemName: "calendar.badge.checkmark")
                    .foregroundColor(.blue)
                Text("\(selectedDates.count) date\(selectedDates.count > 1 ? "s" : "") selected")
                    .fontWeight(.medium)
                    .foregroundColor(.primary)
                Spacer()
                
                Button(action: {
                    withAnimation {
                        selectedDates.removeAll()
                        rangeStart = nil
                        selectionHaptics.selectionChanged()
                    }
                }) {
                    Text("Clear")
                        .font(.footnote)
                        .foregroundColor(.red)
                }
            }
            
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 8) {
                    ForEach(Array(selectedDates).sorted(by: { $0 < $1 }), id: \.self) { date in
                        Text(dateFormatter.string(from: date))
                            .font(.footnote)
                            .padding(.horizontal, 12)
                            .padding(.vertical, 6)
                            .background(
                                Capsule()
                                    .fill(Color.blue.opacity(0.1))
                            )
                            .foregroundColor(.blue)
                    }
                }
            }
        }
        .padding(.horizontal)
        .transition(.move(edge: .bottom).combined(with: .opacity))
    }
    
    private var leaveSection: some View {
        VStack(spacing: 16) {
            HStack {
                VStack(alignment: .leading, spacing: 4) {
                    Text("Leave Application")
                        .font(.headline)
                    Text("Toggle to apply for leave")
                        .font(.footnote)
                        .foregroundColor(.secondary)
                }
                
                Spacer()
                
                Toggle("", isOn: Binding(
                    get: { isOnLeave },
                    set: { newValue in
                        withAnimation {
                            isOnLeave = newValue
                            impactHaptics.impactOccurred()
                        }
                    }
                ))
                .tint(.blue)
            }
            .padding()
            .background(Color(.secondarySystemGroupedBackground))
            .cornerRadius(12)
            
            if isOnLeave {
                leaveReasonInput
            }
        }
        .padding(.horizontal)
        .animation(.spring(response: 0.3), value: isOnLeave)
    }
    
    private var leaveReasonInput: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("Reason for Leave")
                .font(.subheadline)
                .foregroundColor(.secondary)
            
            TextEditor(text: $leaveReason)
                .frame(height: 120)
                .padding(8)
                .background(Color(.systemBackground))
                .clipShape(RoundedRectangle(cornerRadius: 10))
                .overlay(
                    RoundedRectangle(cornerRadius: 10)
                        .stroke(Color(.systemGray4), lineWidth: 1)
                )
                .onChange(of: leaveReason) { newValue in
                    leaveReason = filterAlphabeticInput(newValue)
                }
        }
        .padding()
        .background(Color(.secondarySystemGroupedBackground))
        .cornerRadius(12)
        .transition(.move(edge: .top).combined(with: .opacity))
    }
    
    private var applyButton: some View {
        Button(action: {
            if leaveReason.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty && isOnLeave {
                showReasonAlert = true
            } else {
                haptics.prepare()
                showingConfirmation = true
            }
        }) {
            HStack {
                Image(systemName: "checkmark.circle.fill")
                Text("Apply")
                    .fontWeight(.semibold)
            }
            .frame(maxWidth: .infinity)
            .padding()
            .background(
                RoundedRectangle(cornerRadius: 12)
                    .fill((isOnLeave && !selectedDates.isEmpty && isValidReason) ? Color.blue : Color.blue.opacity(0.6))
            )
            .foregroundColor(.white)
            .padding(.horizontal)
        }
        .disabled(!(isOnLeave && !selectedDates.isEmpty && isValidReason))
    }
    
    private var selectionModeButton: some View {
        VStack(alignment: .trailing, spacing: 8) {
            if showTooltip {
                Text(isRangeMode ? "Tap two dates to select a range" : "Tap dates to select individually")
                    .font(.caption)
                    .padding(.horizontal, 12)
                    .padding(.vertical, 8)
                    .background(
                        RoundedRectangle(cornerRadius: 8)
                            .fill(Color(.secondarySystemBackground))
                            .shadow(color: Color.black.opacity(0.1), radius: 4, x: 0, y: 2)
                    )
                    .transition(.scale.combined(with: .opacity))
            }
            
            Button(action: {
                withAnimation(.spring(response: 0.3)) {
                    isRangeMode.toggle()
                    selectedDates.removeAll()
                    rangeStart = nil
                    selectionHaptics.selectionChanged()
                    impactHaptics.impactOccurred()
                    
                    showTooltip = true
                    DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                        withAnimation {
                            showTooltip = false
                        }
                    }
                }
            }) {
                HStack(spacing: 8) {
                    Image(systemName: isRangeMode ? "arrow.left.arrow.right" : "hand.tap")
                        .font(.system(size: 16, weight: .medium))
                        .foregroundColor(.white)
                        .frame(width: 24, height: 24)
                }
                .padding(16)
                .background(
                    Circle()
                        .fill(Color.blue)
                        .shadow(color: Color.black.opacity(0.15), radius: 8, x: 0, y: 4)
                )
            }
        }
        .padding(.trailing, 20)
        .padding(.bottom, 20)
    }
    
    private func handleDateSelection(_ date: Date) {
        withAnimation(.spring(response: 0.3)) {
            selectionHaptics.selectionChanged()
            
            if isRangeMode {
                if rangeStart == nil {
                    // Start new range
                    rangeStart = date
                    selectedDates = [date]
                } else {
                    // Complete the range
                    let start = min(rangeStart!, date)
                    let end = max(rangeStart!, date)
                    var current = start
                    
                    selectedDates.removeAll()
                    while current <= end {
                        selectedDates.insert(current)
                        current = calendar.date(byAdding: .day, value: 1, to: current)!
                    }
                    rangeStart = nil
                }
            } else {
                // Individual selection mode
                if selectedDates.contains(date) {
                    selectedDates.remove(date)
                } else {
                    selectedDates.insert(date)
                }
            }
        }
    }
    
    private func isDateInRange(_ date: Date) -> Bool {
        guard isRangeMode, let start = rangeStart else { return false }
        return date >= start && date <= calendar.date(byAdding: .day, value: 14, to: start)!
    }
    
    private func applyForLeave() {
        if !selectedDates.isEmpty || isOnLeave {
            haptics.notificationOccurred(.success)
            // Handle leave application
        } else {
            haptics.notificationOccurred(.error)
        }
    }
    
    private func shortDay(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "EEE"
        return formatter.string(from: date)
    }
    
    private func dayNumber(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "d"
        return formatter.string(from: date)
    }
}

// MARK: - Supporting Views
struct DateCircle: View {
    let date: Date
    let isSelected: Bool
    let isInRange: Bool
    let isRangeStart: Bool
    let isRangeEnd: Bool
    let showTrailingLine: Bool
    let showLeadingLine: Bool
    let onTap: () -> Void
    
    @Environment(\.colorScheme) private var colorScheme
    
    var body: some View {
        VStack(spacing: 4) {
            Text(shortDay(date))
                .font(.caption.weight(.medium))
                .foregroundColor(.secondary)
            
            ZStack {
                // Connecting lines
                if showLeadingLine {
                    Rectangle()
                        .fill(Color.blue.opacity(0.3))
                        .frame(width: 12, height: 2)
                        .offset(x: -26)
                }
                
                if showTrailingLine {
                    Rectangle()
                        .fill(Color.blue.opacity(0.3))
                        .frame(width: 12, height: 2)
                        .offset(x: 26)
                }
                
                Text(dayNumber(date))
                    .font(.headline)
                    .frame(width: 40, height: 40)
                    .background(
                        Circle()
                            .fill(backgroundColor)
                            .shadow(color: Color.black.opacity(isSelected ? 0.1 : 0.05),
                                   radius: isSelected ? 4 : 2,
                                   x: 0, y: isSelected ? 2 : 1)
                    )
                    .overlay(
                        Circle()
                            .strokeBorder(strokeColor, lineWidth: isSelected || isRangeStart ? 2 : 1)
                    )
                    .foregroundColor(textColor)
                    .scaleEffect(isSelected ? 1.1 : 1.0)
            }
        }
        .onTapGesture(perform: onTap)
    }
    
    private var backgroundColor: Color {
        if isSelected {
            return .blue
        } else if isInRange {
            return .blue.opacity(0.1)
        } else {
            return Color(.systemBackground)
        }
    }
    
    private var strokeColor: Color {
        if isSelected {
            return .blue
        } else if isRangeStart {
            return .blue
        } else if isInRange {
            return .blue.opacity(0.3)
        } else {
            return Color(.systemGray4)
        }
    }
    
    private var textColor: Color {
        if isSelected {
            return .white
        } else if isInRange {
            return .blue
        } else {
            return .primary
        }
    }
    
    private func shortDay(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "EEE"
        return formatter.string(from: date)
    }
    
    private func dayNumber(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "d"
        return formatter.string(from: date)
    }
}

extension AvailabilityView {
    private func shouldShowTrailingLine(for date: Date) -> Bool {
        guard let start = rangeStart else { return false }
        return date >= start && date < calendar.date(byAdding: .day, value: 14, to: start)!
    }
    
    private func shouldShowLeadingLine(for date: Date) -> Bool {
        guard let start = rangeStart else { return false }
        return date > start && date <= calendar.date(byAdding: .day, value: 14, to: start)!
    }
    private func filterAlphabeticInput(_ input: String) -> String {
        return input.filter { $0.isLetter || $0.isWhitespace }
    }
 
    private var isValidReason: Bool {
        let trimmed = leaveReason.trimmingCharacters(in: .whitespacesAndNewlines)
        return !trimmed.isEmpty && trimmed.range(of: "^[a-zA-Z ]*$", options: .regularExpression) != nil
    }

    
}
