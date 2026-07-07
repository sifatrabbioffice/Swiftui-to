import SwiftUI

@main
struct XogotApp: App {
    var body: some Scene {
        WindowGroup {
            XogotMainContainer()
                .preferredColorScheme(.dark)
        }
    }
}

// MARK: - Root View
struct XogotMainContainer: View {
    @State private var activeTab: EditorTab = .editor
    
    enum EditorTab {
        case editor, code, play
    }
    
    var body: some View {
        ZStack {
            Color(red: 0.05, green: 0.05, blue: 0.05).ignoresSafeArea()
            
            // Tab Content
            Group {
                switch activeTab {
                case .editor: EditorMainView()
                case .code: CodePanelView()
                case .play: PlayPanelView()
                }
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            
            // Bottom Tab Bar (Placed on top with specific Safe Area padding)
            VStack {
                Spacer()
                XogotBottomTabBar(activeTab: $activeTab)
                    .padding(.horizontal, 16)
                    .padding(.bottom, 20) // Fix: Home Indicator এর জন্য জায়গা ছেড়ে দেওয়া
            }
        }
    }
}

// MARK: - 1. Editor Main View (3D Workspace)
struct EditorMainView: View {
    var body: some View {
        ZStack {
            // 3D Grid Background (Full screen but behind everything)
            Canvas { context, size in
                let midX = size.width / 2
                let midY = size.height / 2
                context.stroke(Path { $0.move(to: CGPoint(x: 0, y: midY)); $0.addLine(to: CGPoint(x: size.width, y: midY)) }, with: .color(.blue.opacity(0.4)), lineWidth: 1)
                context.stroke(Path { $0.move(to: CGPoint(x: midX, y: 0)); $0.addLine(to: CGPoint(x: midX, y: size.height)) }, with: .color(.green.opacity(0.4)), lineWidth: 1)
                context.stroke(Path { $0.move(to: CGPoint(x: 0, y: 0)); $0.addLine(to: CGPoint(x: size.width, y: size.height)) }, with: .color(.red.opacity(0.2)), lineWidth: 1)
            }
            .ignoresSafeArea()
            
            VStack(spacing: 0) {
                // ===== TOP UI =====
                VStack(spacing: 0) {
                    // Top Header (Xogot Title & Right Buttons)
                    HStack(spacing: 14) {
                        HStack(spacing: 6) {
                            RoundedRectangle(cornerRadius: 6).fill(Color(white: 0.15)).frame(width: 28, height: 28)
                                .overlay(Image(systemName: "video.fill").font(.system(size: 12)).foregroundColor(.white))
                            Text("Xogot").font(.headline).fontWeight(.bold).foregroundColor(.white)
                            Image(systemName: "chevron.down").font(.system(size: 10)).foregroundColor(.gray)
                        }
                        Spacer()
                        HStack(spacing: 10) {
                            CircularButton(icon: "doc.text")
                            CircularButton(icon: "target")
                            CircularButton(icon: "play.fill", bgColor: .white.opacity(0.15))
                        }
                    }
                    .padding(.horizontal, 16)
                    .padding(.top, 10) // Fix: নচের সাথে লেগে যাওয়া রোধ
                    
                    // 3D Editor Toolbar
                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack(spacing: 14) {
                            ToolIcon(icon: "arrow.up.left.and.arrow.down.right", active: true)
                            ToolIcon(icon: "arrow.up.and.down.and.arrow.left.and.right")
                            ToolIcon(icon: "rotate.3d")
                            ToolIcon(icon: "arrow.up.left.and.arrow.down.right.magnifyingglass")
                            Divider().frame(height: 16).background(Color.gray.opacity(0.4))
                            ToolIcon(icon: "list.bullet")
                            ToolIcon(icon: "lock")
                            ToolIcon(icon: "square.dashed")
                            ToolIcon(icon: "cube")
                            Divider().frame(height: 16).background(Color.gray.opacity(0.4))
                            ToolIcon(icon: "sun.max")
                            ToolIcon(icon: "globe")
                        }
                        .padding(.vertical, 6)
                        .padding(.horizontal, 12)
                    }
                    .padding(.top, 4)
                    
                    // Perspective Dropdown Bar
                    HStack(spacing: 12) {
                        Image(systemName: "rectangle.dashed").font(.system(size: 14)).foregroundColor(.gray)
                        Text("Perspective").font(.system(size: 15, weight: .medium)).foregroundColor(.white)
                        Spacer()
                        Image(systemName: "house.fill").font(.system(size: 14)).foregroundColor(.white)
                        Image(systemName: "square.3.layers.3d").font(.system(size: 14)).foregroundColor(.white)
                    }
                    .padding(.horizontal, 14)
                    .padding(.vertical, 8)
                    .background(Capsule().fill(Color(white: 0.22)))
                    .padding(.top, 10)
                    .padding(.horizontal, 16)
                }
                
                Spacer() // পুরো মাঝখানটা ফাঁকা রাখবে
            }
            
            // ===== FLOATING 3D GIZMO (XYZ) =====
            VStack {
                Spacer().frame(height: 140) // টুলবারের নিচে সঠিক দূরত্বে
                HStack {
                    Spacer()
                    ZStack {
                        VStack {
                            HStack(spacing: 0) {
                                Text("Y").foregroundColor(.green).offset(y: -10)
                                Spacer().frame(width: 30)
                            }
                            HStack(spacing: 14) {
                                Text("Z").foregroundColor(.blue)
                                Circle().fill(Color.white.opacity(0.08)).frame(width: 30, height: 30)
                                Text("X").foregroundColor(.red).offset(y: 10)
                            }
                        }
                    }
                    .padding(.trailing, 16)
                }
                Spacer()
            }
            
            // ===== BOTTOM FLOATING CONTROLS (Undo/Redo & 2D/3D) =====
            VStack {
                Spacer()
                HStack(alignment: .bottom) {
                    // Left Controls
                    VStack(spacing: 12) {
                        FloatingActionButton(icon: "arrow.uturn.left.circle.fill", tint: .blue)
                        FloatingActionButton(icon: "arrow.uturn.right.circle.fill", tint: .gray)
                    }
                    Spacer()
                    // Right Controls
                    VStack(spacing: 12) {
                        FloatingTextButton(text: "3D", tint: .blue)
                        FloatingTextButton(text: "2D", tint: .gray)
                    }
                }
                .padding(.horizontal, 20)
                .padding(.bottom, 130) // Fix: ট্যাব বারের ঠিক উপরে সঠিক দূরত্বে
            }
        }
    }
}

// MARK: - 2. Code Panel
struct CodePanelView: View {
    var body: some View {
        ZStack {
            Color.black.ignoresSafeArea()
            VStack(spacing: 20) {
                CapsuleMenuButton(icon: "doc.text", title: "New Script")
                CapsuleMenuButton(icon: nil, title: "Open")
            }
        }
    }
}

// MARK: - 3. Play Panel
struct PlayPanelView: View {
    var body: some View {
        ZStack {
            Color.black.ignoresSafeArea()
            VStack(spacing: 16) {
                Text("Game is not running").font(.title3).foregroundColor(.white).padding(.bottom, 8)
                CapsuleMenuButton(icon: "play.fill", title: "Start Game Here")
                CapsuleMenuButton(icon: "play.fill", title: "Start in Full Screen")
                Text("Remote Device").font(.headline).foregroundColor(.white).padding(.top, 20)
                CapsuleMenuButton(icon: nil, title: "Get Remote Debugging")
                Text("Devices with same account or\npaired devices will appear at the top\nof the list")
                    .font(.footnote).foregroundColor(.gray).multilineTextAlignment(.center).padding(.horizontal, 40)
            }
        }
    }
}

// ==========================================
// MARK: - UI COMPONENTS (Exact Locations)
// ==========================================

// Bottom Custom Tab Bar
struct XogotBottomTabBar: View {
    @Binding var activeTab: XogotMainContainer.EditorTab
    
    var body: some View {
        HStack(spacing: 0) {
            // Main Tab Pill
            HStack(spacing: 0) {
                TabButton(tab: .editor, icon: "wrench.fill", label: "Editor")
                TabButton(tab: .code, icon: "doc.text.fill", label: "Code")
                TabButton(tab: .play, icon: "gamecontroller.fill", label: "Play")
            }
            .padding(4)
            .background(Capsule().fill(Color(white: 0.15)))
            
            Spacer().frame(width: 14)
            
            // Separate Search Button
            Button(action: {}) {
                Image(systemName: "magnifyingglass")
                    .font(.system(size: 18, weight: .medium))
                    .foregroundColor(.white)
                    .frame(width: 44, height: 44)
                    .background(Circle().fill(Color(white: 0.15)))
            }
        }
    }
    
    @ViewBuilder
    func TabButton(tab: XogotMainContainer.EditorTab, icon: String, label: String) -> some View {
        let isActive = activeTab == tab
        Button(action: { activeTab = tab }) {
            VStack(spacing: 2) {
                Image(systemName: icon).font(.system(size: 18, weight: .medium))
                Text(label).font(.caption2).fontWeight(.medium)
            }
            .frame(width: 70, height: 42)
            .foregroundColor(isActive ? .blue : .white)
            .background(isActive ? Capsule().fill(Color.white.opacity(0.1)) : nil)
        }
    }
}

// Top Circular Button
struct CircularButton: View {
    let icon: String
    var bgColor: Color = Color(white: 0.12)
    var body: some View {
        Image(systemName: icon).font(.system(size: 16)).foregroundColor(.white)
            .frame(width: 34, height: 34).background(Circle().fill(bgColor))
    }
}

// Toolbar Icons
struct ToolIcon: View {
    let icon: String
    var active: Bool = false
    var body: some View {
        Image(systemName: icon).font(.system(size: 15))
            .foregroundColor(active ? .blue : .white)
            .padding(6).background(active ? Color.blue.opacity(0.15) : Color.clear).cornerRadius(4)
    }
}

// Floating Buttons
struct FloatingActionButton: View {
    let icon: String
    let tint: Color
    var body: some View {
        Image(systemName: icon).font(.system(size: 24)).foregroundColor(tint)
            .frame(width: 44, height: 44).background(Color(white: 0.12)).clipShape(Circle())
    }
}

struct FloatingTextButton: View {
    let text: String
    let tint: Color
    var body: some View {
        Text(text).font(.system(size: 18, weight: .semibold)).foregroundColor(tint)
            .frame(width: 44, height: 44).background(Color(white: 0.12)).clipShape(Circle())
    }
}

// Capsule Buttons for Code/Play
struct CapsuleMenuButton: View {
    let icon: String?
    let title: String
    var body: some View {
        HStack(spacing: 8) {
            if let icon = icon { Image(systemName: icon).font(.system(size: 16)).foregroundColor(.blue) }
            Text(title).font(.headline).foregroundColor(.blue)
        }
        .padding(.horizontal, 20).padding(.vertical, 12)
        .background(Capsule().fill(Color(white: 0.12)))
    }
}
