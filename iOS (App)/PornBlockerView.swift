//
//  PornBlockerView.swift
//  ProcrastinationBlocker
//
//  Created by Daniel McKenzie on 12/28/24.
//

import SwiftUI

struct PornBlockerView: View {
    @State private var isBlockerOn = false
    @State private var timerEnabled = false
    @State private var timerDuration: Double = 60

    var body: some View {
        VStack(spacing: 20) {
            Text("Porn Blocker")
                .font(.largeTitle)
                .bold()

            Toggle("Blocker Status", isOn: $isBlockerOn)
                .toggleStyle(SwitchToggleStyle(tint: .blue))
                .padding()

            Toggle("Enable Timer", isOn: $timerEnabled)
                .toggleStyle(SwitchToggleStyle(tint: .blue))
                .padding()

            if timerEnabled {
                HStack {
                    Text("Timer Duration:")
                    Slider(value: $timerDuration, in: 1...120, step: 1) {
                        Text("Timer")
                    }
                    Text("\(Int(timerDuration)) min")
                }
                .padding()
            }

            Spacer()
        }
        .padding()
    }
}
