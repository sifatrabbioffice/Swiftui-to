import SwiftUI

@main
struct XogotApp: App {
    var body: some Scene {
        WindowGroup {
            XogotView()
        }
    }
}

// Your Previous Full UI Code Below
struct XogotView: View {
    var body: some View {
        ZStack {
            Color(white: 0.05).edgesIgnoringSafeArea(.all)
            
            VStack(spacing: 20) {
                // Top Header
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
                .padding(.top, 10)
                
                Spacer()
                
                // Bottom Toolbar
                HStack(spacing: 0) {
                    HStack(spacing: 30) {
                        ZStack {
                            Capsule().fill(Color.white.opacity(0.2))
                                .frame(width: 38, height: 38)
                            Image(systemName: "slider.horizontal.3")
                                .font(.system(size: 16))
                                .foregroundColor(.white)
                        }
                        Image(systemName: "phone")
                            .font(.system(size: 18))
                            .foregroundColor(.white)
                        Image(systemName: "square.on.square")
                            .font(.system(size: 18))
                            .foregroundColor(.white)
                        Image(systemName: "arrow.down.to.line")
                            .font(.system(size: 18))
                            .foregroundColor(.white)
                    }
                    .padding(.horizontal, 25)
                    .padding(.vertical, 12)
                    .background(Capsule().fill(Color(white: 0.2)))
                }
                .padding(.bottom, 30)
            }
        }
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
