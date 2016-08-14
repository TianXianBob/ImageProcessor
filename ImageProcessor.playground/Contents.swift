//: Playground - noun: a place where people can play

import UIKit

let image = UIImage(named: "sample")
//Make a remove red filter
func removeRed(var pixel: Pixel) ->Pixel{
    pixel.red = 0
    return pixel
}
//Test filter
func testRemoveRedFilter(image: UIImage) -> UIImage {
    var thisImage = RGBAImage(image: image)!
    for y in 0..<thisImage.height {
        for x in 0..<thisImage.width {
            let sub = y * thisImage.width + x
            let pixel = thisImage.pixels[sub]
            thisImage.pixels[sub] = removeRed(pixel)
        }
    }
    return thisImage.toUIImage()!
}
testRemoveRedFilter(image!)
//Mack a filter that can remove red(conf=0) or green(conf=1) or blue(conf=2)
func removeColor(var pixel:Pixel,conf:Int) -> Pixel{
    if(conf == 0){
        pixel.red = 0
    }else if(conf == 1){
        pixel.green = 0
    }else if(conf == 2){
        pixel.blue = 0
    }
    return pixel
}
//Make Filter Class
class Filter {
    var conf: Int = 0//set option of filter
    var filter: ((Pixel, Int) -> (Pixel))//pixel filter
    init(filter: ((Pixel, Int) -> (Pixel)), conf: Int) {
        self.conf = conf
        self.filter = filter
    }
}

//Make the remove color filter
let removeColorFilter = Filter(filter: removeColor,conf: 0)

//Make a filter that can make grayscale image
func grayScale(var pixel:Pixel,conf:Int)->Pixel{
    let gray = UInt8((Int(pixel.red)+Int(pixel.green)+Int(pixel.blue))/conf)
    pixel.red = gray
    pixel.green = gray
    pixel.blue = gray
    return pixel
}

let grayscaleFilter = Filter(filter: grayScale,conf:3)


//Make a transparent filter
func transparentFilter(var pixel:Pixel,opacity:Int)->Pixel{
    pixel.alpha = UInt8(opacity)
    return pixel
}

let transparentOpacityFilter = Filter(filter: transparentFilter,conf: 90)

//Make a black-and-white filter
func blackAndWhite(var pixel:Pixel,conf:Int)->Pixel{
    if(conf==1){
        let avg = UInt8((Int(pixel.red)+Int(pixel.green)+Int(pixel.blue))/3)
        if(avg>100){
            pixel.red = 255
            pixel.green = 255
            pixel.blue = 255
        }else{
            pixel.red = 0
            pixel.green = 0
            pixel.blue = 0
        }
    }else{
        let avg = UInt8((Int(pixel.red)+Int(pixel.green)+Int(pixel.blue))/3)
        if(avg<100){
            pixel.red = 255
            pixel.green = 255
            pixel.blue = 255
        }else{
            pixel.red = 0
            pixel.green = 0
            pixel.blue = 0
        }

    }
    return pixel
}

let blackAndWhiteFilter = Filter(filter: blackAndWhite,conf:1)

//Make a inverse-color filter
func inverseColor(var pixel:Pixel,conf:Int)->Pixel{
    pixel.red = min(max(UInt8(conf) - pixel.red,0),255)
    pixel.green = min(max(UInt8(conf) - pixel.green,0),255)
    pixel.blue = min(max(UInt8(conf) - pixel.blue,0),255)
    return pixel
}

let inverseColorFilter = Filter(filter: inverseColor,conf:255)

//Make subtraction
class ImageProcessor {
    var filters: [Filter] = []
    func insertFilter(filter: String){
        filters.append(existFilters[filter]!)
    }
    func cleanFilter(){
        filters = []
    }
    var existFilters: [String: Filter] = [
        "removeColorFilter":removeColorFilter,
        "grayscaleFilter":grayscaleFilter,
        "transparentOpacityFilter":transparentOpacityFilter,
        "blackAndWhiteFilter":blackAndWhiteFilter,
        "inverseColorFilter":inverseColorFilter
    ]
    func processImage(image: UIImage) -> UIImage {
        var thisImage = RGBAImage(image: image)!
        for y in 0..<thisImage.height {
            for x in 0..<thisImage.width {
                let sub = y * thisImage.width + x
                for filter in filters {
                    let pixel = thisImage.pixels[sub]
                    thisImage.pixels[sub] = filter.filter(pixel, filter.conf)
                }
                
            }
        }
        return thisImage.toUIImage()!
    }
}


// Process the image!
var imageProcessor: ImageProcessor = ImageProcessor()
imageProcessor.insertFilter("removeColorFilter")
imageProcessor.processImage(image!)
imageProcessor.cleanFilter()
imageProcessor.insertFilter("grayscaleFilter")
imageProcessor.processImage(image!)
imageProcessor.cleanFilter()
imageProcessor.insertFilter("transparentOpacityFilter")
imageProcessor.processImage(image!)

imageProcessor.cleanFilter()
imageProcessor.insertFilter("blackAndWhiteFilter")
imageProcessor.processImage(image!)

imageProcessor.cleanFilter()
imageProcessor.insertFilter("inverseColorFilter")
imageProcessor.processImage(image!)
imageProcessor.cleanFilter()
imageProcessor.insertFilter("removeColorFilter")
imageProcessor.insertFilter("grayscaleFilter")
imageProcessor.insertFilter("transparentOpacityFilter")
imageProcessor.insertFilter("blackAndWhiteFilter")
imageProcessor.insertFilter("inverseColorFilter")
imageProcessor.processImage(image!)
