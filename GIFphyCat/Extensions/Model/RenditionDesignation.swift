

import Foundation



public enum RenditionDesignation: String {
    case fixedHeight = "fixed_height"
    case fixedHeightStill = "fixed_height_still"
    case fixedHeightDownsampled = "fixed_height_downsampled"
    case fixedWidth = "fixed_width"
    case fixedWidthStill = "fixed_width_still"
    case fixedWidthDownsampled = "fixed_width_downsampled"
    case fixedHeightSmall = "fixed_height_small"
    case fixedHeightSmallStill = "fixed_height_small_still"
    case fixedWidthSmall = "fixed_width_small"
    case fixedWidthSmallStill = "fixed_width_small_still"
    case preview = "preview"
    case previewGIF = "preview_gif"
    case previewWebP = "preview_webp"
    case downsizedSmall = "downsized_small"
    case downsizedMedium = "downsized_medium"
    case downsizedLarge = "downsized_large"
    case downsizedStill = "downsized_still"
    case original = "original"
    case originalStill = "original_still"
    case originalMP4 = "original_mp4"
    case looping = "looping"
    
}
