import SwiftUI

@main
struct XogotApp: App {
    var body: some Scene {
        WindowGroup {
            XogotMainContainer()
                .preferredColorScheme(.dark)
                .edgesIgnoringSafeArea(.all)
        }
    }
}

// MARK: - Root View with Bottom Navigation
struct XogotMainContainer: View {
    @State private var activeTab: EditorTab = .editor
    
    enum EditorTab {
        case editor, code, play
    }
    
    var body: some View {
        ZStack(alignment: .bottom) {
            Color(red: 0.05, green: 0.05, blue: 0.05).ignoresSafeArea()
            
            // Main Content Area
            Group {
                switch activeTab {
                case .editor: EditorMainView()
                case .code: CodePanelView()
                case .play: PlayPanelView()
                }
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .ignoresSafeArea(edges: .bottom)
            
            // Custom Floating Bottom Bar
            XogotBottomTabBar(activeTab: $activeTab)
                .padding(.bottom, 20)
        }
    }
}

// MARK: - Editor Main View (3D Workspace)
struct EditorMainView: View {
    var body: some View {
        ZStack {
            // === 3D Grid Simulator ===
            Canvas { context, size in
                let midX = size.width / 2
                let midY = size.height / 2
                // Blue (Z)
                context.stroke(Path { $0.move(to: CGPoint(x: 0, y: midY)); $0.addLine(to: CGPoint(x: size.width, y: midY)) }, with: .color(.blue.opacity(0.5)), lineWidth: 1)
                // Green (Y)
                context.stroke(Path { $0.move(to: CGPoint(x: midX, y: 0)); $0.addLine(to: CGPoint(x: midX, y: size.height)) }, with: .color(.green.opacity(0.5)), lineWidth: 1)
                // Red (X - Diagonal)
                context.stroke(Path { $0.move(to: CGPoint(x: 0, y: 0)); $0.addLine(to: CGPoint(x: size.width, y: size.height)) }, with: .color(.red.opacity(0.3)), lineWidth: 1)
                // Perspective Grid Lines
                for i in stride(from: 0, to: size.width, by: 40) {
                    context.stroke(Path { $0.move(to: CGPoint(x: i, y: 0)); $0.addLine(to: CGPoint(x: i, y: size.height)) }, with: .color(.white.opacity(0.05)), lineWidth: 0.5)
                }
                for i in stride(from: 0, to: size.height, by: 40) {
                    context.stroke(Path { $0.move(to: CGPoint(x: 0, y: i)); $0.addLine(to: CGPoint(x: size.width, y: i)) }, with: .color(.white.opacity(0.05)), lineWidth: 0.5)
                }
            }
            .ignoresSafeArea()
            
            VStack(spacing: 0) {
                // 1. Top Header & Tools
                VStack(spacing: 0) {
                    EditorHeaderView()
                    EditorToolbarView()
                }
                .background(Color(red: 0.08, green: 0.08, blue: 0.08))
                
                // 2. Perspective Bar
                PerspectiveBarView()
                    .padding(.top, 8)
                    .padding(.horizontal, 16)
                
                Spacer()
                
                // 3. Bottom Overlay Controls
                HStack(alignment: .bottom) {
                    // Left: Undo/Redo
                    VStack(spacing: 14) {
                        FloatingActionButton(icon: "arrow.uturn.left.circle.fill", tint: .blue)
                        FloatingActionButton(icon: "arrow.uturn.right.circle.fill", tint: .white.opacity(0.5))
                    }
                    Spacer()
                    // Right: 2D/3D Toggle
                    VStack(spacing: 14) {
                        FloatingTextButton(text: "3D", tint: .blue)
                        FloatingTextButton(text: "2D", tint: .white.opacity(0.5))
                    }
                }
                .padding(20)
                .padding(.bottom, 100) // Give space for tab bar
                
                // 4. Floating Axis Gizmo (XYZ)
                HStack {
                    Spacer()
                    VStack {
                        HStack(spacing: 0) {
                            Text("Y").foregroundColor(.green).offset(y: -10)
                            Spacer().frame(width: 30)
                        }
                        HStack(spacing: 12) {
                            Text("Z").foregroundColor(.blue)
                            Circle().fill(Color.white.opacity(0.05)).frame(width: 30, height: 30)
                            Text("X").foregroundColor(.red).offset(y: 10)
                        }
                    }
                    .padding(.trailing, 12)
                }
                .padding(.bottom, 250)
            }
        }
    }
}

// MARK: - Code Panel (Empty State)
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

// MARK: - Play Panel (Empty State)
struct PlayPanelView: View {
    var body: some View {
        ZStack {
            Color.black.ignoresSafeArea()
            VStack(spacing: 16) {
                Text("Game is not running")
                    .font(.title3)
                    .foregroundColor(.white)
                    .padding(.bottom, 8)
                
                CapsuleMenuButton(icon: "play.fill", title: "Start Game Here")
                CapsuleMenuButton(icon: "play.fill", title: "Start in Full Screen")
                
                Text("Remote Device")
                    .font(.headline)
                    .foregroundColor(.white)
                    .padding(.top, 20)
                
                CapsuleMenuButton(icon: nil, title: "Get Remote Debugging")
                
                Text("Devices with same account or\npaired devices will appear at the top\nof the list")
                    .font(.footnote)
                    .foregroundColor(.gray)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, 40)
            }
        }
    }
}

// ==========================================
// MARK: - UI Helper Components
// ==========================================

// 1. Editor Top Header (Xogot + Right Controls)
struct EditorHeaderView: View {
    var body: some View {
        HStack(spacing: 14) {
            // Project Selector
            HStack(spacing: 6) {
                ZStack {
                    RoundedRectangle(cornerRadius: 6)
                        .fill(Color(white: 0.15))
                        .frame(width: 24, height: 24)
                    Image(systemName: "video.fill")
                        .font(.system(size: 12))
                        .foregroundColor(.white)
                }
                Text("Xogot")
                    .font(.headline)
                    .fontWeight(.bold)
                    .foregroundColor(.white)
                Image(systemName: "chevron.down")
                    .font(.system(size: 10))
                    .foregroundColor(.gray)
            }
            Spacer()
            // Right Icons
            HStack(spacing: 10) {
                CircularButton(icon: "doc.text")
                CircularButton(icon: "target")
                CircularButton(icon: "play.fill", bgColor: .white.opacity(0.15))
            }
        }
        .padding(.horizontal)
        .padding(.vertical, 8)
    }
}

// 2. Editor Toolbar (Select, Move, Rotate, Scale, etc.)
struct EditorToolbarView: View {
    var body: some View {
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
            .padding(.horizontal, 12)
            .padding(.vertical, 4)
        }
        .padding(.bottom, 4)
    }
}

// 3. Perspective Bar (with Home, Camera)
struct PerspectiveBarView: View {
    var body: some View {
        HStack(spacing: 12) {
            Image(systemName: "rectangle.dashed")
                .font(.system(size: 14))
                .foregroundColor(.gray)
            Text("Perspective")
                .font(.system(size: 15, weight: .medium))
                .foregroundColor(.white)
            Spacer()
            Image(systemName: "house.fill")
                .font(.system(size: 14))
                .foregroundColor(.white)
            Image(systemName: "camera")
                .font(.system(size: 14))
                .foregroundColor(.white)
        }
        .padding(.horizontal, 14)
        .padding(.vertical, 8)
        .background(Capsule().fill(Color(white: 0.25)))
    }
}

// 4. Custom Floating Bottom Tab Bar
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
            
            // Search Button
            Button(action: {}) {
                Image(systemName: "magnifyingglass")
                    .font(.system(size: 18, weight: .medium))
                    .foregroundColor(.white)
                    .frame(width: 44, height: 44)
                    .background(Circle().fill(Color(white: 0.15)))
            }
        }
        .padding(.horizontal, 16)
    }
    
    @ViewBuilder
    func TabButton(tab: XogotMainContainer.EditorTab, icon: String, label: String) -> some View {
        let isActive = activeTab == tab
        Button(action: { activeTab = tab }) {
            VStack(spacing: 2) {
                Image(systemName: icon)
                    .font(.system(size: 18, weight: .medium))
                Text(label)
                    .font(.caption2)
                    .fontWeight(.medium)
            }
            .frame(width: 70, height: 42)
            .foregroundColor(isActive ? .blue : .white)
            .background(isActive ? Capsule().fill(Color.white.opacity(0.1)) : nil)
        }
    }
}

// === Helper Views ===
struct CircularButton: View {
    let icon: String
    var bgColor: Color = Color(white: 0.12)
    var body: some View {
        Image(systemName: icon)
            .font(.system(size: 16))
            .foregroundColor(.white)
            .frame(width: 34, height: 34)
            .background(Circle().fill(bgColor))
    }
}

struct ToolIcon: View {
    let icon: String
    var active: Bool = false
    var body: some View {
        Image(systemName: icon)
            .font(.system(size: 15))
            .foregroundColor(active ? .blue : .white)
            .padding(6)
            .background(active ? Color.blue.opacity(0.15) : Color.clear)
            .cornerRadius(4)
    }
}

struct FloatingActionButton: View {
    let icon: String
    let tint: Color
    var body: some View {
        Image(systemName: icon)
            .font(.system(size: 24))
            .foregroundColor(tint)
            .frame(width: 44, height: 44)
            .background(Color(white: 0.12))
            .clipShape(Circle())
    }
}

struct FloatingTextButton: View {
    let text: String
    let tint: Color
    var body: some View {
        Text(text)
            .font(.system(size: 18, weight: .semibold))
            .foregroundColor(tint)
            .frame(width: 44, height: 44)
            .background(Color(white: 0.12))
            .clipShape(Circle())
    }
}

struct CapsuleMenuButton: View {
    let icon: String?
    let title: String
    var body: some View {
        HStack(spacing: 8) {
            if let icon = icon {
                Image(systemName: icon)
                    .font(.system(size: 16))
                    .foregroundColor(.blue)
            }
            Text(title)
                .font(.headline)
                .foregroundColor(.blue)
        }
        .padding(.horizontal, 20)
        .padding(.vertical, 12)
        .background(Capsule().fill(Color(white: 0.12)))
    }
}
