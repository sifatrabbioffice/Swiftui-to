import SwiftUI

// MARK: - App Entry
@main
struct XogotApp: App {
    var body: some Scene {
        WindowGroup {
            MainTabBarContainer()
                .preferredColorScheme(.dark)
        }
    }
}

// MARK: - Main Container (Custom Floating Tab Bar)
struct MainTabBarContainer: View {
    @State private var selectedTab: Tab = .editor
    
    enum Tab: String, CaseIterable {
        case editor = "Editor"
        case code = "Code"
        case play = "Play"
    }
    
    var body: some View {
        ZStack(alignment: .bottom) {
            Color(white: 0.05).ignoresSafeArea()
            
            // Views based on selected tab
            Group {
                switch selectedTab {
                case .editor: EditorView()
                case .code: CodeView()
                case .play: PlayView()
                }
            }
            .ignoresSafeArea(edges: .bottom)
            
            // Floating Bottom Tab Bar
            HStack(spacing: 0) {
                // Left Pill
                HStack(spacing: 0) {
                    ForEach(Tab.allCases, id: \.self) { tab in
                        Button(action: { selectedTab = tab }) {
                            VStack(spacing: 4) {
                                Image(systemName: tabIcon(for: tab))
                                    .font(.system(size: 18, weight: .medium))
                                Text(tab.rawValue)
                                    .font(.caption2)
                                    .fontWeight(.medium)
                            }
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 10)
                            .foregroundColor(selectedTab == tab ? .blue : .white)
                            .background(
                                selectedTab == tab ? Capsule().fill(Color.white.opacity(0.1)) : nil
                            )
                        }
                    }
                }
                .padding(4)
                .background(Capsule().fill(Color(white: 0.15)))
                
                Spacer().frame(width: 16)
                
                // Right Search Button
                Button(action: {}) {
                    Image(systemName: "magnifyingglass")
                        .font(.system(size: 18, weight: .medium))
                        .foregroundColor(.white)
                        .frame(width: 50, height: 50)
                        .background(Circle().fill(Color(white: 0.15)))
                }
            }
            .padding(.horizontal, 20)
            .padding(.bottom, 25)
        }
    }
    
    func tabIcon(for tab: Tab) -> String {
        switch tab {
        case .editor: return "wrench.fill"
        case .code: return "doc.text.fill"
        case .play: return "gamecontroller.fill"
        }
    }
}

// MARK: - 1. 3D Editor View
struct EditorView: View {
    var body: some View {
        ZStack {
            // 3D Grid Background (Perspective Lines)
            Canvas { context, size in
                let w = size.width
                let h = size.height
                let midX = w / 2
                let midY = h / 2
                
                // Z axis (Blue)
                context.stroke(Path { $0.move(to: CGPoint(x: 0, y: midY)); $0.addLine(to: CGPoint(x: w, y: midY)) }, with: .color(.blue.opacity(0.6)), lineWidth: 1.5)
                // Y axis (Green)
                context.stroke(Path { $0.move(to: CGPoint(x: midX, y: 0)); $0.addLine(to: CGPoint(x: midX, y: h)) }, with: .color(.green.opacity(0.6)), lineWidth: 1.5)
                // X axis (Red)
                context.stroke(Path { $0.move(to: CGPoint(x: 0, y: 0)); $0.addLine(to: CGPoint(x: w, y: h)) }, with: .color(.red.opacity(0.4)), lineWidth: 1.0)
            }
            .ignoresSafeArea()
            
            VStack(spacing: 0) {
                // Top Bar (Title + Right Buttons)
                HStack(spacing: 15) {
                    HStack(spacing: 8) {
                        RoundedRectangle(cornerRadius: 6).fill(Color(white: 0.15)).frame(width: 28, height: 28)
                            .overlay(Image(systemName: "video.fill").font(.system(size: 14)).foregroundColor(.white))
                        Text("Xogot").font(.headline).fontWeight(.bold).foregroundColor(.white)
                        Image(systemName: "chevron.down").font(.system(size: 10)).foregroundColor(.gray)
                    }
                    Spacer()
                    HStack(spacing: 10) {
                        TopIconButton(icon: "doc.text")
                        TopIconButton(icon: "target")
                        TopIconButton(icon: "play.fill", bgColor: .white.opacity(0.2))
                    }
                }
                .padding(.horizontal)
                .padding(.top, 10)
                
                Spacer().frame(height: 8)
                
                // 3D Editor Toolbar
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 12) {
                        ToolButton(icon: "arrow.up.left.and.arrow.down.right", active: true) // Select
                        ToolButton(icon: "arrow.up.and.down.and.arrow.left.and.right") // Move
                        ToolButton(icon: "rotate.3d") // Rotate
                        ToolButton(icon: "arrow.up.left.and.arrow.down.right.magnifyingglass") // Scale
                        Divider().frame(height: 16).background(Color.gray.opacity(0.5))
                        ToolButton(icon: "list.bullet")
                        ToolButton(icon: "lock")
                        ToolButton(icon: "square.dashed")
                        ToolButton(icon: "cube")
                        Divider().frame(height: 16).background(Color.gray.opacity(0.5))
                        ToolButton(icon: "sun.max")
                        ToolButton(icon: "globe")
                    }
                    .padding(.horizontal, 10)
                    .padding(.vertical, 6)
                }
                .background(Color(white: 0.08).opacity(0.9))
                .padding(.horizontal, 6)
                
                // Perspective Dropdown
                HStack(spacing: 8) {
                    Image(systemName: "rectangle.dashed")
                        .foregroundColor(.gray)
                    Text("Perspective")
                        .foregroundColor(.white)
                    Spacer()
                    Image(systemName: "house.fill")
                        .foregroundColor(.white)
                    Image(systemName: "square.3.layers.3d")
                        .foregroundColor(.white)
                }
                .padding(.horizontal, 12)
                .padding(.vertical, 10)
                .background(Capsule().fill(Color(white: 0.25)))
                .padding(.top, 8)
                .padding(.horizontal, 16)
                
                Spacer()
                
                // 3D Axis Gizmo (Top Right)
                HStack {
                    Spacer()
                    VStack {
                        HStack(spacing: 0) {
                            Text("Y").foregroundColor(.green).offset(y: -12)
                            Spacer().frame(width: 30)
                        }
                        HStack(spacing: 16) {
                            Text("Z").foregroundColor(.blue)
                            Circle().fill(Color.white.opacity(0.05)).frame(width: 40, height: 40)
                            Text("X").foregroundColor(.red).offset(y: 12)
                        }
                    }
                    .padding(.trailing, 16)
                }
                .padding(.bottom, 160)
                
                // Bottom Left & Right Controls
                HStack {
                    VStack(spacing: 12) {
                        FloatingCircleButton(icon: "arrow.uturn.left.circle.fill", color: .blue)
                        FloatingCircleButton(icon: "arrow.uturn.right.circle.fill", color: .gray)
                    }
                    Spacer()
                    VStack(spacing: 12) {
                        FloatingTextButton(text: "3D", color: .blue)
                        FloatingTextButton(text: "2D", color: .gray)
                    }
                }
                .padding(.horizontal, 20)
                .padding(.bottom, 120)
            }
        }
    }
}

// MARK: - 2. Code View
struct CodeView: View {
    var body: some View {
        ZStack {
            Color.black.ignoresSafeArea()
            VStack(spacing: 20) {
                CapsuleButton(icon: "doc.text", title: "New Script")
                CapsuleButton(icon: nil, title: "Open")
            }
        }
    }
}

// MARK: - 3. Play View
struct PlayView: View {
    var body: some View {
        ZStack {
            Color.black.ignoresSafeArea()
            VStack(spacing: 18) {
                Text("Game is not running")
                    .font(.title3)
                    .foregroundColor(.white)
                    .padding(.bottom, 8)
                
                CapsuleButton(icon: "play.fill", title: "Start Game Here")
                CapsuleButton(icon: "play.fill", title: "Start in Full Screen")
                
                Text("Remote Device")
                    .font(.headline)
                    .foregroundColor(.white)
                    .padding(.top, 20)
                
                CapsuleButton(icon: nil, title: "Get Remote Debugging")
                
                Text("Devices with same account or\npaired devices will appear at the top\nof the list")
                    .font(.footnote)
                    .foregroundColor(.gray)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, 30)
            }
        }
    }
}

// MARK: - UI Helper Components
struct TopIconButton: View {
    let icon: String
    var bgColor: Color = Color(white: 0.15)
    
    var body: some View {
        Image(systemName: icon)
            .font(.system(size: 16))
            .foregroundColor(.white)
            .frame(width: 34, height: 34)
            .background(Circle().fill(bgColor))
    }
}

struct ToolButton: View {
    let icon: String
    var active: Bool = false
    
    var body: some View {
        Image(systemName: icon)
            .font(.system(size: 14))
            .foregroundColor(active ? .blue : .white)
            .padding(6)
            .background(active ? Color.blue.opacity(0.2) : Color.clear)
            .cornerRadius(4)
    }
}

struct FloatingCircleButton: View {
    let icon: String
    let color: Color
    
    var body: some View {
        Image(systemName: icon)
            .font(.system(size: 22))
            .foregroundColor(color)
            .frame(width: 44, height: 44)
            .background(Color(white: 0.15))
            .clipShape(Circle())
    }
}

struct FloatingTextButton: View {
    let text: String
    let color: Color
    
    var body: some View {
        Text(text)
            .font(.system(size: 18, weight: .semibold))
            .foregroundColor(color)
            .frame(width: 44, height: 44)
            .background(Color(white: 0.15))
            .clipShape(Circle())
    }
}

struct CapsuleButton: View {
    let icon: String?
    let title: String
    
    var body: some View {
        HStack(spacing: 8) {
            if let icon = icon {
                Image(systemName: icon)
                    .foregroundColor(.blue)
                    .font(.system(size: 16))
            }
            Text(title)
                .font(.headline)
                .foregroundColor(.blue)
        }
        .padding(.horizontal, 24)
        .padding(.vertical, 14)
        .background(Color(white: 0.12))
        .clipShape(Capsule())
    }
}
