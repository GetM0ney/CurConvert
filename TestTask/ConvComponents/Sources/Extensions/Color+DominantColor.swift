import UIKit
import SwiftUI
import SwiftUICore
import CoreImage


public extension CGImage {
    var isDark: Bool {
        guard let imageData = self.dataProvider?.data else { return false }
        guard let ptr = CFDataGetBytePtr(imageData) else { return false }
        let length = CFDataGetLength(imageData)
        let threshold = Int(Double(self.width * self.height) * 0.45)
        var darkPixels = 0
        for i in stride(from: 0, to: length, by: 4) {
            let r = ptr[i]
            let g = ptr[i + 1]
            let b = ptr[i + 2]
            let luminance = (0.299 * Double(r) + 0.587 * Double(g) + 0.114 * Double(b))
            if luminance < 150 {
                darkPixels += 1
                if darkPixels > threshold {
                    return true
                }
            }
        }
        return false
    }
}

public extension UIImage {
    var isDark: Bool {
        self.cgImage?.isDark ?? false
    }
}

extension UIImage {
    func resized(to size: CGSize) -> UIImage? {
        UIGraphicsBeginImageContextWithOptions(size, true, 1)
        defer { UIGraphicsEndImageContext() }
        draw(in: CGRect(origin: .zero, size: size))
        return UIGraphicsGetImageFromCurrentImageContext()
    }

    var fastIsDark: Bool {
        guard let smallImage = self.resized(to: CGSize(width: 50, height: 50)),
              let cgImage = smallImage.cgImage else { return false }
        return cgImage.isDark
    }
}

// RGB color structure for internal calculations
private struct RGBColor: Hashable {
    let r, g, b: CGFloat
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(r)
        hasher.combine(g)
        hasher.combine(b)
    }
    
    static func == (lhs: RGBColor, rhs: RGBColor) -> Bool {
        return lhs.r == rhs.r && lhs.g == rhs.g && lhs.b == rhs.b
    }
}

extension Image {
    /// Asynchronously calculates the dominant color using K-means clustering
    /// - Parameters:
    ///   - clusterCount: Number of color clusters to analyze (default: 10)
    ///   - completion: Closure called with the resulting Color
    func dominantColorKMeans(clusterCount: Int = 10, completion: @escaping (Color?) -> Void) {
        // Convert SwiftUI Image to UIImage for processing
        guard let uiImage = self.asUIImage() else {
            completion(nil)
            return
        }
        
        uiImage.dominantColorKMeans(clusterCount: clusterCount) { uiColor in
            if let uiColor = uiColor {
                completion(Color(uiColor: uiColor))
            } else {
                completion(nil)
            }
        }
    }

    func asUIImage() -> UIImage? {
        let controller = UIHostingController(rootView: 
            self.frame(width: 300, height: 300) // Explicitly set frame
                .background(Color.clear)
        )
        
        // Configure the hosting controller
        let targetSize = CGSize(width: 300, height: 300)
        controller.view.frame = CGRect(origin: .zero, size: targetSize)
        controller.view.backgroundColor = .clear
        
        // Ensure the view is ready for rendering
        controller.view.setNeedsLayout()
        controller.view.layoutIfNeeded()
        
        // Create a new format with specific options
        let format = UIGraphicsImageRendererFormat()
        format.scale = 1.0
        format.opaque = false
        
        let renderer = UIGraphicsImageRenderer(size: targetSize, format: format)
        let image = renderer.image { context in
            // Try both rendering methods
            controller.view.drawHierarchy(in: controller.view.bounds, afterScreenUpdates: true)
            controller.view.layer.render(in: context.cgContext)
        }
        
        // Debug info
        if let cgImage = image.cgImage {
            print("Image size: \(cgImage.width)x\(cgImage.height)")
            if let dataProvider = cgImage.dataProvider,
               let data = dataProvider.data,
               let bytes = CFDataGetBytePtr(data) {
                let pixelInfo = (0..<10).map { i in
                    let offset = i * 4 // RGBA
                    return (r: bytes[offset], g: bytes[offset + 1], b: bytes[offset + 2])
                }
                print("First 10 pixels RGB: \(pixelInfo)")
            }
        }
        
        return image
    }
}

extension UIImage {
    /// Asynchronously calculates the dominant color using K-means clustering
    /// - Parameters:
    ///   - clusterCount: Number of color clusters to analyze (default: 10)
    ///   - completion: Closure called with the resulting dominant UIColor
    ///
    
    public func dominantColorKMeans(clusterCount: Int = 10, completion: @escaping (UIColor?) -> Void) {
        // Capture self strongly before the async block
        let image = self
        
        DispatchQueue.global(qos: .userInitiated).async {
            guard let dominantColor = image.calculateDominantColorV2() else {
                DispatchQueue.main.async {
                    completion(nil)
                }
                return
            }
            
            DispatchQueue.main.async {
                completion(dominantColor)
            }
        }
    }
}

// MARK: - Private Helper Functions


private func kMeans(_ points: [RGBColor], k: Int, iterations: Int = 10) -> [RGBColor: [RGBColor]] {
    guard !points.isEmpty else { return [:] }
    
    var centroids = Array(points.shuffled().prefix(k))
    var clusters: [RGBColor: [RGBColor]] = [:]
    
    for _ in 0..<iterations {
        clusters = [:]
        
        // Assign points to nearest centroid
        for point in points {
            let nearestCentroid = centroids.min(by: { distance($0, point) < distance($1, point) })!
            clusters[nearestCentroid, default: []].append(point)
        }
        
        // Update centroids
        let newCentroids = clusters.compactMap { (_, points) -> RGBColor? in
            guard !points.isEmpty else { return nil }
            let count = CGFloat(points.count)
            let avgR = points.reduce(0) { $0 + $1.r } / count
            let avgG = points.reduce(0) { $0 + $1.g } / count
            let avgB = points.reduce(0) { $0 + $1.b } / count
            return RGBColor(r: avgR, g: avgG, b: avgB)
        }
        
        if newCentroids.isEmpty { break }
        centroids = newCentroids
    }
    
    return clusters
}

private func distance(_ a: RGBColor, _ b: RGBColor) -> CGFloat {
    return sqrt(pow(a.r - b.r, 2) + pow(a.g - b.g, 2) + pow(a.b - b.b, 2))
}

struct LabColor: Hashable {
    let l: CGFloat
    let a: CGFloat
    let b: CGFloat
}

extension UIImage {

    private func resizeImage(to size: CGSize) -> UIImage? {
        UIGraphicsBeginImageContextWithOptions(size, false, 0.0)
        self.draw(in: CGRect(origin: .zero, size: size))
        let resizedImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return resizedImage
    }

    func calculateDominantColorV2(clusterCount: Int = 3) -> UIColor? {
        guard let resized = self.resizeImage(to: CGSize(width: 50, height: 50)),
              let cgImage = resized.cgImage else {
            return nil
        }

        let width = cgImage.width
        let height = cgImage.height
        let bytesPerPixel = 4
        let bytesPerRow = bytesPerPixel * width
        let totalBytes = height * bytesPerRow

        var rawData = [UInt8](repeating: 0, count: totalBytes)
        let colorSpace = CGColorSpaceCreateDeviceRGB()

        guard let context = CGContext(data: &rawData,
                                      width: width,
                                      height: height,
                                      bitsPerComponent: 8,
                                      bytesPerRow: bytesPerRow,
                                      space: colorSpace,
                                      bitmapInfo: CGImageAlphaInfo.premultipliedLast.rawValue) else {
            return nil
        }

        context.draw(cgImage, in: CGRect(x: 0, y: 0, width: width, height: height))

        var labColors: [LabColor] = []

        for y in 0..<height {
            for x in 0..<width {
                let index = (y * bytesPerRow) + (x * bytesPerPixel)
                let r = CGFloat(rawData[index]) / 255.0
                let g = CGFloat(rawData[index + 1]) / 255.0
                let b = CGFloat(rawData[index + 2]) / 255.0
                let a = CGFloat(rawData[index + 3]) / 255.0

                let brightness = (r + g + b) / 3.0
                if a > 0.1 && brightness > 0.1 && brightness < 0.95 {
                    let lab = rgbToLab(RGBColor(r: r, g: g, b: b))
                    labColors.append(lab)
                }
            }
        }

        guard !labColors.isEmpty else { return nil }

        let clusters = kMeansLab(colors: labColors, k: clusterCount)
        guard let dominant = clusters.max(by: { $0.value.count < $1.value.count })?.key else {
            return nil
        }

        let rgb = labToRgb(dominant)
        return UIColor(red: rgb.r, green: rgb.g, blue: rgb.b, alpha: 1.0)
    }

    // MARK: - Color Space Conversion

    private func rgbToLab(_ rgb: RGBColor) -> LabColor {
        // RGB to XYZ
        func pivotRGB(_ value: CGFloat) -> CGFloat {
            return value > 0.04045 ? pow((value + 0.055) / 1.055, 2.4) : (value / 12.92)
        }

        let r = pivotRGB(rgb.r)
        let g = pivotRGB(rgb.g)
        let b = pivotRGB(rgb.b)

        // sRGB D65 reference white
        let x = (r * 0.4124 + g * 0.3576 + b * 0.1805) / 0.95047
        let y = (r * 0.2126 + g * 0.7152 + b * 0.0722) / 1.00000
        let z = (r * 0.0193 + g * 0.1192 + b * 0.9505) / 1.08883

        // XYZ to Lab
        func pivotXYZ(_ value: CGFloat) -> CGFloat {
            return value > 0.008856 ? pow(value, 1.0 / 3.0) : (7.787 * value + 16.0 / 116.0)
        }

        let fx = pivotXYZ(x)
        let fy = pivotXYZ(y)
        let fz = pivotXYZ(z)

        let l = 116.0 * fy - 16.0
        let a = 500.0 * (fx - fy)
        let bb = 200.0 * (fy - fz)

        return LabColor(l: l, a: a, b: bb)
    }

    private func labToRgb(_ lab: LabColor) -> RGBColor {
        // Lab to XYZ
        let fy = (lab.l + 16.0) / 116.0
        let fx = lab.a / 500.0 + fy
        let fz = fy - lab.b / 200.0

        let x = pow(fx, 3.0) > 0.008856 ? pow(fx, 3.0) : (fx - 16.0 / 116.0) / 7.787
        let y = lab.l > (0.008856 * 903.3) ? pow((lab.l + 16.0) / 116.0, 3.0) : lab.l / 903.3
        let z = pow(fz, 3.0) > 0.008856 ? pow(fz, 3.0) : (fz - 16.0 / 116.0) / 7.787

        // XYZ to RGB
        let xRef = x * 0.95047
        let yRef = y * 1.00000
        let zRef = z * 1.08883

        var r = xRef * 3.2406 + yRef * (-1.5372) + zRef * (-0.4986)
        var g = xRef * (-0.9689) + yRef * 1.8758 + zRef * 0.0415
        var b = xRef * 0.0557 + yRef * (-0.2040) + zRef * 1.0570

        func pivotRGB(_ value: CGFloat) -> CGFloat {
            return value > 0.0031308 ? (1.055 * pow(value, 1.0 / 2.4) - 0.055) : (12.92 * value)
        }

        r = pivotRGB(r)
        g = pivotRGB(g)
        b = pivotRGB(b)

        return RGBColor(
            r: min(max(0, r), 1),
            g: min(max(0, g), 1),
            b: min(max(0, b), 1)
        )
    }

    // MARK: - kMeans for Lab

    private func kMeansLab(colors: [LabColor], k: Int, maxIterations: Int = 10) -> [LabColor: [LabColor]] {
        var centroids = Array(colors.shuffled().prefix(k))
        var clusters: [LabColor: [LabColor]] = [:]

        for _ in 0..<maxIterations {
            clusters = [:]

            for color in colors {
                let nearest = centroids.min(by: {
                    deltaE($0, color) < deltaE($1, color)
                })!
                clusters[nearest, default: []].append(color)
            }

            centroids = clusters.map { averageLabColor($0.value) }
        }

        return clusters
    }

    private func averageLabColor(_ colors: [LabColor]) -> LabColor {
        let count = CGFloat(colors.count)
        let sum = colors.reduce(LabColor(l: 0, a: 0, b: 0)) { acc, color in
            LabColor(l: acc.l + color.l, a: acc.a + color.a, b: acc.b + color.b)
        }
        return LabColor(l: sum.l / count, a: sum.a / count, b: sum.b / count)
    }

    private func deltaE(_ c1: LabColor, _ c2: LabColor) -> CGFloat {
        let dl = c1.l - c2.l
        let da = c1.a - c2.a
        let db = c1.b - c2.b
        return sqrt(dl * dl + da * da + db * db)
    }
}
