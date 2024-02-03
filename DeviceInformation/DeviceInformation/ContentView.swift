import SwiftUI
import WebKit

struct WebView: UIViewRepresentable {
    @Binding var userAgent: String

    func makeUIView(context: Context) -> WKWebView {
        return WKWebView()
    }

    func updateUIView(_ webView: WKWebView, context: Context) {
        webView.evaluateJavaScript("navigator.userAgent") { result, error in
            if let userAgent = result as? String {
                DispatchQueue.main.async {
                    self.userAgent = userAgent
                }
            }
        }
    }
}

struct ContentView: View {
    @State private var userAgent = "Unknown"
    @State private var isDataSaved = false

    var body: some View {
        GeometryReader { geometry in
            VStack {
                WebView(userAgent: $userAgent)
                    .frame(width: 0, height: 0) // Invisible WebView

                Image(systemName: "globe")
                    .imageScale(.large)
                    .foregroundStyle(.tint)
                Text(isDataSaved ? "Data Saved!" : "Capturing Data...")
                    .onAppear {
                        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                            saveDeviceData(geometry: geometry, userAgent: userAgent)
                            isDataSaved = true
                        }
                    }
            }
            .padding()
        }
    }

    func saveDeviceData(geometry: GeometryProxy, userAgent: String) {
        let dimensions = UIScreen.main.bounds
        let safeAreaInsets = geometry.safeAreaInsets
        let orientation = UIDevice.current.orientation.isLandscape ? "Landscape" : "Portrait"
        let deviceName = UIDevice.current.name
        let deviceScaleFactor = UIScreen.main.scale
        let isMobile = true
        let hasTouch = true

        let data: [String: Any] = [
            "dimensions": ["width": dimensions.width, "height": dimensions.height],
            "safeAreaInsets": ["top": safeAreaInsets.top, "bottom": safeAreaInsets.bottom, "leading": safeAreaInsets.leading, "trailing": safeAreaInsets.trailing],
            "userAgent": userAgent,
            "deviceScaleFactor": deviceScaleFactor,
            "isMobile": isMobile,
            "hasTouch": hasTouch
        ]

        if let jsonData = try? JSONSerialization.data(withJSONObject: data, options: .prettyPrinted) {
               let baseFolderPath = "/Users/Shared/"
               let devicesFolderPath = baseFolderPath + "devices/"
               let fileManager = FileManager.default

               // Check if 'devices' directory exists, if not, create it
               if !fileManager.fileExists(atPath: devicesFolderPath) {
                   do {
                       try fileManager.createDirectory(atPath: devicesFolderPath, withIntermediateDirectories: true, attributes: nil)
                   } catch {
                       print("Error creating directory: \(error)")
                       return
                   }
               }

               let fileName = "\(UIDevice.current.name)_\(UIDevice.current.orientation.isLandscape ? "Landscape" : "Portrait").json"
               let fileURL = URL(fileURLWithPath: devicesFolderPath).appendingPathComponent(fileName)

               // Writing to the file
               do {
                   try jsonData.write(to: fileURL)
               } catch {
                   print("Error writing to file: \(error)")
               }
           }
    }
}

// Preview
struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
