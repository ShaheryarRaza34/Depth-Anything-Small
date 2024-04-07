import Foundation
import CoreML

func main(){
// Function to resize image while preserving aspect ratio
func resizeImage(image: CGImage, maxSize: CGFloat) -> CGImage? {
    let width = CGFloat(image.width)
    let height = CGFloat(image.height)
    let ratio = min(maxSize / width, maxSize / height)
    let newSize = CGSize(width: width * ratio, height: height * ratio)
    
    let colorSpace = CGColorSpaceCreateDeviceRGB()
    let bitmapInfo = CGBitmapInfo(rawValue: CGImageAlphaInfo.premultipliedLast.rawValue)
    let context = CGContext(data: nil, width: Int(newSize.width), height: Int(newSize.height), bitsPerComponent: 8, bytesPerRow: Int(newSize.width * 4), space: colorSpace, bitmapInfo: bitmapInfo.rawValue)
    
    context?.interpolationQuality = .high
    context?.draw(image, in: CGRect(origin: .zero, size: newSize))
    
    return context?.makeImage()
}

// Function to load image from file path
func loadImage(from path: String) -> CGImage? {
    guard let url = URL(string: path),
          let source = CGImageSourceCreateWithURL(url as CFURL, nil),
          let image = CGImageSourceCreateImageAtIndex(source, 0, nil)
    else {
        print("Failed to load image from path: \(path)")
        return nil
    }
    return image
}

//// Function to save image to file path
//func saveImage(_ image: CGImage, to path: String) {
//    guard let destination = CGImageDestinationCreateWithURL(URL(fileURLWithPath: path) as CFURL, kUTTypePNG, 1, nil) else {
//        print("Failed to create destination for image at path: \(path)")
//        return
//    }
//    CGImageDestinationAddImage(destination, image, nil)
//    CGImageDestinationFinalize(destination)
//}

// Load the Core ML model
//guard let model = try? DepthModel(configuration: MLModelConfiguration()),
//      let modelURL = Bundle.main.url(forResource: "DepthModel", withExtension: "mlmodel"),
//      let compiledModel = try? MLModel(contentsOf: modelURL)
//else {
//    fatalError("Failed to load Core ML model")
//}
//
// Function to compute depth from input image
//func computeDepth(inputImagePath: String, outputImagePath: String, maxDimension: CGFloat) {
//    guard let inputImage = loadImage(from: inputImagePath) else {
//        print("Failed to load input image")
//        return
//    }
//    
//    // Resize image if needed
//    //let resizedImage = resizeImage(image: inputImage, maxSize: maxDimension) ?? inputImage
//
//    // Prepare Core ML request
//    //let request = DepthModelInput(input: resizedImage)
//    
//    // Perform inference
//    //    do {
//    //        let prediction = try model.prediction(input: request)
//    //
//    //        // Get depth output
//    //        let depthImage = prediction.output
//    //
//    //        // Upsample depth image to original size
//    //        let originalDepthImage = resizeImage(image: depthImage, maxSize: CGFloat(inputImage.width)) ?? depthImage
//    //
//    //        // Save depth image
//    //        saveImage(originalDepthImage, to: outputImagePath)
//    //        print("Depth computed and saved at: \(outputImagePath)")
//    //    } catch {
//    //        print("Error occurred during inference: \(error)")
//    //    }
//    //}
//    
    // Check for command line arguments
    let arguments = CommandLine.arguments
    let inputImagePath = arguments[1]
    print(inputImagePath)
    let outputImagePath = arguments[2]
    print(outputImagePath)
//            if let maxDimension = Double(arguments[3]) {
//                computeDepth(inputImagePath: inputImagePath, outputImagePath: outputImagePath, maxDimension: CGFloat(maxDimension))
//            } else {
//                print("Invalid value for max_dimension: \(arguments[3])")
//            }

}





// Call the main function
main()

