import SwiftUI

// MARK: - App Entry
@main
struct XogotApp: App {
    var body: some Scene {
        WindowGroup {
            MainTabView()
                .preferredColorScheme(.dark)
        }
    }
}

// MARK: - Main Tab View (Switching between Editor, Code, Play)
struct MainTabView: View {
    @State private var selectedTab: Tab = .editor
    
    enum Tab: String, CaseIterable {
        case editor = "Editor"
        case code = "Code"
        case play = "Play"
    }
    
    var body: some View {
        ZStack(alignment: .bottom) {
            Color(white: 0.05).edgesIgnoringSafeArea(.all)
            
            // Content Views
            TabView(selection: $selectedTab) {
                EditorView()
                    .tag(Tab.editor)
                CodeView()
                    .tag(Tab.code)
                PlayView()
                    .tag(Tab.play)
            }
            .ignoresSafeArea()
            
            VStack(spacing: 0) {
                Spacer()
                // Custom Bottom Tab Bar
                CustomTabBar(selectedTab: $selectedTab)
                    .padding(.bottom, 15)
            }
        }
    }
}

// MARK: - 1. Editor View (3D Editor Design)
struct EditorView: View {
    var body: some View {
        ZStack {
            // 3D Grid Simulation (Using lines to mimic perspective)
            Canvas { context, size in
                let center = CGPoint(x: size.width / 2, y: size.height / 2)
                // Horizontal blue line
                context.stroke(Path { path in path.move(to: CGPoint(x: 0, y: center.y)); path.addLine(to: CGPoint(x: size.width, y: center.y)) }, with: .color(.blue.opacity(0.5)), lineWidth: 2)
                // Vertical green line
                context.stroke(Path { path in path.move(to: CGPoint(x: center.x, y: 0)); path.addLine(to: CGPoint(x: center.x, y: size.height)) }, with: .color(.green.opacity(0.5)), lineWidth: 2)
                // Diagonal red/axis lines
                context.stroke(Path { path in path.move(to: CGPoint(x: 0, y: 0)); path.addLine(to: CGPoint(x: size.width, y: size.height)) }, with: .color(.red.opacity(0.3)), lineWidth: 1)
            }
            .ignoresSafeArea()
            
            VStack(spacing: 0) {
                // Top Bar
                XogotTopBar()
                
                // Top Toolbar (Left: Select, Move, Rotate, Scale, etc.)
                HStack(spacing: 12) {
                    ToolIcon(icon: "arrow.up.left.and.arrow.down.right", selected: true) // Select
                    ToolIcon(icon: "arrow.up.and.down.and.arrow.left.and.right") // Move
                    ToolIcon(icon: "rotate.3d") // Rotate
                    ToolIcon(icon: "arrow.up.left.and.arrow.down.right.magnifyingglass") // Scale
                    Divider().frame(height: 20).background(Color.gray)
                    ToolIcon(icon: "list.bullet") // List
                    ToolIcon(icon: "lock") // Lock
                    ToolIcon(icon: "square.dashed") // Box
                    ToolIcon(icon: "cube") // Cube
                    Spacer()
                    ToolIcon(icon: "sun.max") // Light
                    ToolIcon(icon: "globe") // World
                }
                .padding(.horizontal)
                .padding(.vertical, 8)
                .background(Color.white.opacity(0.05))
                
                Spacer()
                
                // Bottom Floating Buttons
                HStack {
                    VStack(spacing: 10) {
                        FloatingButton(icon: "arrow.uturn.left.circle.fill", color: .blue) // Undo
                        FloatingButton(icon: "arrow.uturn.right.circle.fill", color: .gray) // Redo
                    }
                    Spacer()
                    VStack(spacing: 10) {
                        FloatingTextButton(text: "3D", color: .blue)
                        FloatingTextButton(text: "2D", color: .gray)
                    }
                }
                .padding(20)
                .padding(.bottom, 60)
            }
            
            // 3D Gizmo (Top Right)
            VStack {
                Spacer().frame(height: 130)
                HStack {
                    Spacer()
                    AxisGizmo()
                        .padding(.trailing, 20)
                }
                Spacer()
            }
        }
    }
}

// MARK: - 2. Code View
struct CodeView: View {
    var body: some View {
        ZStack {
            Color.black.ignoresSafeArea()
            VStack(spacing: 25) {
                CapsuleButton(icon: "doc.text", title: "New Script", active: true)
                CapsuleButton(icon: nil, title: "Open", active: true)
            }
        }
    }
}

// MARK: - 3. Play View
struct PlayView: View {
    var body: some View {
        ZStack {
            Color.black.ignoresSafeArea()
            VStack(spacing: 20) {
                Text("Game is not running")
                    .font(.title2)
                    .foregroundColor(.white)
                    .padding(.bottom, 5)
                
                CapsuleButton(icon: "play.fill", title: "Start Game Here", active: true)
                CapsuleButton(icon: "play.fill", title: "Start in Full Screen", active: true)
                
                Text("Remote Device")
                    .font(.headline)
                    .foregroundColor(.white)
                    .padding(.top, 20)
                
                CapsuleButton(icon: nil, title: "Get Remote Debugging", active: true)
                
                Text("Devices with same account or\npaired devices will appear at the top\nof the list")
                    .font(.footnote)
                    .foregroundColor(.gray)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, 30)
            }
        }
    }
}

// MARK: - UI COMPONENTS (Header, Tabs, Buttons)

struct XogotTopBar: View {
    var body: some View {
        HStack(spacing: 15) {
            HStack(spacing: 10) {
                ZStack {
                    RoundedRectangle(cornerRadius: 8)
                        .fill(Color(white: 0.15))
                        .frame(width: 32, height: 32)
                    Image(systemName: "video.fill")
                        .font(.system(size: 14))
                        .foregroundColor(.white)
                }
                Text("Xogot")
                    .font(.headline)
                    .fontWeight(.bold)
                    .foregroundColor(.white)
                Image(systemName: "chevron.down")
                    .font(.system(size: 12))
                    .foregroundColor(.gray)
            }
            Spacer()
            HStack(spacing: 12) {
                HeaderCircleButton(icon: "doc.text")
                HeaderCircleButton(icon: "target")
                HeaderCircleButton(icon: "play.fill")
            }
        }
        .padding(.horizontal)
        .padding(.top, 10) // Safe area included later
    }
}

struct CustomTabBar: View {
    @Binding var selectedTab: MainTabView.Tab
    
    var body: some View {
        HStack(spacing: 0) {
            // Main Tab Pill
            HStack(spacing: 0) {
                ForEach(MainTabView.Tab.allCases, id: \.self) { tab in
                    Button(action: { selectedTab = tab }) {
                        VStack(spacing: 4) {
                            Image(systemName: iconName(for: tab))
                                .font(.system(size: 20))
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
            
            Spacer().frame(width: 15)
            
            // Search Button
            Button(action: {}) {
                Image(systemName: "magnifyingglass")
                    .font(.system(size: 20))
                    .foregroundColor(.white)
                    .frame(width: 50, height: 50)
                    .background(Circle().fill(Color(white: 0.15)))
            }
        }
        .padding(.horizontal, 15)
    }
    
    func iconName(for tab: MainTabView.Tab) -> String {
        switch tab {
        case .editor: return "wrench.fill"
        case .code: return "doc.text.fill"
        case .play: return "gamecontroller.fill"
        }
    }
}

// Helper for Tool Icons (3D Editor)
struct ToolIcon: View {
    let icon: String
    var selected: Bool = false
    var body: some View {
        Image(systemName: icon)
            .font(.system(size: 16))
            .foregroundColor(selected ? .blue : .white)
            .padding(8)
            .background(selected ? Color.blue.opacity(0.2) : Color.clear)
            .cornerRadius(6)
    }
}

struct FloatingButton: View {
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

struct AxisGizmo: View {
    var body: some View {
        ZStack {
            Circle().stroke(Color.white.opacity(0.1), lineWidth: 1)
            Circle().fill(Color.white.opacity(0.05)).frame(width: 40, height: 40)
            // X axis
            Text("X").foregroundColor(.red).offset(x: 20, y: 10)
            // Y axis
            Text("Y").foregroundColor(.green).offset(x: 0, y: -20)
            // Z axis
            Text("Z").foregroundColor(.blue).offset(x: -20, y: 10)
        }
        .frame(width: 50, height: 50)
    }
}

struct CapsuleButton: View {
    let icon: String?
    let title: String
    let active: Bool
    
    var body: some View {
        HStack(spacing: 10) {
            if let icon = icon {
                Image(systemName: icon)
                    .foregroundColor(.blue)
            }
            Text(title)
                .font(.headline)
                .foregroundColor(.blue)
        }
        .padding(.horizontal, 20)
        .padding(.vertical, 12)
        .background(Capsule().fill(Color(white: 0.15)))
    }
}

struct HeaderCircleButton: View {
    let icon: String
    var body: some View {
        Image(systemName: icon)
            .font(.system(size: 16))
            .foregroundColor(.white)
            .frame(width: 40, height: 40)
            .background(Circle().fill(Color(white: 0.15)))
    }
}
