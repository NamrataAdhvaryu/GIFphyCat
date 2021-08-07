

import Foundation
import ImageIO


public extension UIImage
{
    
    public class func gif(from data: Data) -> UIImage?
    {
        
        
        guard let durations = self.animationDurations(from: data) else
        {
            print("Failed to read the frame durations out from the data.")
            return nil
        }
        
        guard let rawFrames = self.frames(from: data) else
        {
            print("Failed to read the images out from the data.")
            return nil
        }
        
        let duration = self.animationDuration(with: durations)
        
        let frames = self.framesAccountingForPerFrameDuration(with: rawFrames, and: durations)
        
        let gif:UIImage? = UIImage.animatedImage(with: frames, duration: duration)
        
        return gif
    }
    
    // MARK: - Reading Raw GIF Data from the Data Object
    
   
    private class func frames(from data:Data) -> [UIImage]?
    {
        var frames: [UIImage] = []
        
        let imageData = data as CFData
        let imageSourceOption: NSDictionary =  [kCGImageSourceCreateThumbnailFromImageIfAbsent: true]
        
        guard let source = CGImageSourceCreateWithData(imageData, (imageSourceOption as CFDictionary)) else
        {
            print("Failed to load frames from data. Could not create image source.")
            return nil
        }
        
        let frameCount = CGImageSourceGetCount(source)
        
        for frameIndex in 0..<frameCount
        {
            guard let coreGraphicsImage = CGImageSourceCreateImageAtIndex(source, frameIndex, nil) else
            {
                print("Failed to load frame at index \(frameIndex)")
                continue
            }
            
            let frame = UIImage(cgImage: coreGraphicsImage)
            frames.append(frame)
        }
        
        return frames
    }
    
    
    private class func animationDurations(from data: Data) -> [Int]?
    {
        var intervals: [Int] = []
        
        let imageData = data as CFData
        let imageSourceOption: NSDictionary =  [kCGImageSourceCreateThumbnailFromImageIfAbsent: true]
        
        guard let source = CGImageSourceCreateWithData(imageData, (imageSourceOption as CFDictionary)) else
        {
            print("Failed to load frames from data. Could not create image source.")
            return nil
        }
        
        let frameCount = CGImageSourceGetCount(source)
        
        for frameIndex in 0..<frameCount
        {
            if let properties: NSDictionary = CGImageSourceCopyPropertiesAtIndex(source, frameIndex, nil)
            {
                let key = String(kCGImagePropertyGIFDictionary)
                if let GIFProperties: NSDictionary = (properties as? Dictionary<String, AnyObject>)?[key] as? NSDictionary
                {
                    var seconds: NSNumber? = nil
                    
                    if let duration = GIFProperties[kCGImagePropertyGIFUnclampedDelayTime] as? NSNumber
                    {
                        seconds = duration
                    }
                    else if let clampedDuration = GIFProperties[kCGImagePropertyGIFDelayTime] as? NSNumber
                    {
                        seconds = clampedDuration
                    }
                    
                    if let seconds = seconds, seconds.doubleValue > 0.0
                    {
                        let centiseconds = seconds.doubleValue * 100.0
                        intervals.append(Int(centiseconds))
                    }
                }
            }
        }
        
        return intervals
    }
    
  
    private class func vectorGCD(of durations: [Int]) -> Int
    {
        guard let first = durations.first else
        {
            return 0
        }
        
        var vector: Int = Int(first)
        
        for index in 0..<durations.count
        {
            let duration = durations[index]
            vector = gcd(a: Int(duration), b: Int(vector))
        }
        
        return vector
    }
    
    
    private class func animationDuration(with durations: [Int]) -> TimeInterval
    {
        let totalSeconds = durations.reduce(0) { (partial: Int, input:Int) -> Int in
            return partial + input
        }
        
        return TimeInterval(totalSeconds) / 100.0
    }
    
    // MARK: - Repeating Frames to Simulate Per-Frame Duration With UIImage's Single Animation Duration
    
    private class func framesAccountingForPerFrameDuration(with frames: [UIImage], and durations:[Int]) -> [UIImage]
    {
        var output: [UIImage] = []
        
        let gcd = self.vectorGCD(of: durations)
        
        for index in 0..<min(frames.count, durations.count)
        {
            let image = frames[index]
            let duration = durations[index]
            if gcd == 0
            {
                continue
            }
            
            let repeatCount = duration / gcd
            
            let images = Array<UIImage>(repeatElement(image, count: repeatCount))
            output.append(contentsOf: images)
        }
        
        return output
    }
}
