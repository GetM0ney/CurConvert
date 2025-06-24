import Foundation

struct MultipartFile {
    let data: Data
    let serverName: String // The form field name (e.g., "video")
    let filename: String // The filename to report to the server
    let mimeType: String // e.g., "video/mp4"
}
