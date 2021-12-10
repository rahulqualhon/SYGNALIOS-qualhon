//
//  Extension.swift
//  Marbella VIP
//
//  Created by Harshit Thakur on 12/05/21.
//
import UIKit
import CoreLocation
import TTGSnackbar
import SystemConfiguration

protocol BackButtonDelegate {
    func click_BackButton()
}

func maskRoundedImage(image: UIImage, radius: CGFloat) -> UIImage {
    let imageView: UIImageView = UIImageView(image: image)
    let layer = imageView.layer
    layer.masksToBounds = true
    layer.cornerRadius = radius
    UIGraphicsBeginImageContext(imageView.bounds.size)
    layer.render(in: UIGraphicsGetCurrentContext()!)
    let roundedImage = UIGraphicsGetImageFromCurrentImageContext()
    UIGraphicsEndImageContext()
    return roundedImage!
}



func makeFontBold (location : Int, length : Int , String :  String, fontSize : CGFloat)-> NSAttributedString{
    
    let myMutableString = NSMutableAttributedString(
        string: String ,
        attributes: [:])
    
    myMutableString.addAttribute(
        NSAttributedString.Key.font,
        value: UIFont.boldSystemFont(ofSize: fontSize),
        range: NSRange(
            location:location,
            length:length))
    
    return myMutableString
}



func alert(message : String, Controller : UIViewController ){
    DispatchQueue.main.async {
        let alertView = UIAlertController(title: NSLocalizedString("Pronta", comment: ""), message: message, preferredStyle: .alert)
        let action = UIAlertAction(title: "OK", style: .default, handler: nil)
        alertView.addAction(action)
        Controller.present(alertView, animated: true, completion: nil)
    }
}



func resizeImage(image: UIImage, targetSize: CGSize) -> UIImage {
    
    let size = image.size
    
    let widthRatio  = targetSize.width  / image.size.width
    let heightRatio = targetSize.height / image.size.height
    
    // Figure out what our orientation is, and use that to form the rectangle
    var newSize: CGSize
    if(widthRatio > heightRatio) {
        newSize = CGSize(width: size.width * heightRatio, height: size.height * heightRatio)
    } else {
        newSize = CGSize(width: size.width * widthRatio,  height: size.height * widthRatio)
    }
    let rect = CGRect(x: 0, y: 0, width: newSize.width, height: newSize.height)
    // Actually do the resizing to the rect using the ImageContext stuff
    UIGraphicsBeginImageContextWithOptions(newSize, false, 1.0)
    image.draw(in: rect)
    let newImage = UIGraphicsGetImageFromCurrentImageContext()
    UIGraphicsEndImageContext()
    return newImage!
}

func stringToDate(date : String , comingPattern : String , OutGoingPattern : String)-> Date {
    
    print("Date Coming \(date)")
    
    let dateFormatter = DateFormatter()
    
    dateFormatter.dateFormat = comingPattern
    
    let date = dateFormatter.date(from: date)
    
    dateFormatter.dateFormat = OutGoingPattern
    
    print("Converted Date: \(date!)")
    
    return date!
    
}

extension UIImage {

func crop(to:CGSize) -> UIImage {

    guard let cgimage = self.cgImage else { return self }

    let contextImage: UIImage = UIImage(cgImage: cgimage)

    guard let newCgImage = contextImage.cgImage else { return self }

    let contextSize: CGSize = contextImage.size

    //Set to square
    var posX: CGFloat = 0.0
    var posY: CGFloat = 0.0
    let cropAspect: CGFloat = to.width / to.height

    var cropWidth: CGFloat = to.width
    var cropHeight: CGFloat = to.height

    if to.width > to.height { //Landscape
        cropWidth = contextSize.width
        cropHeight = contextSize.width / cropAspect
        posY = (contextSize.height - cropHeight) / 2
    } else if to.width < to.height { //Portrait
        cropHeight = contextSize.height
        cropWidth = contextSize.height * cropAspect
        posX = (contextSize.width - cropWidth) / 2
    } else { //Square
        if contextSize.width >= contextSize.height { //Square on landscape (or square)
            cropHeight = contextSize.height
            cropWidth = contextSize.height * cropAspect
            posX = (contextSize.width - cropWidth) / 2
        }else{ //Square on portrait
            cropWidth = contextSize.width
            cropHeight = contextSize.width / cropAspect
            posY = (contextSize.height - cropHeight) / 2
        }
    }

    let rect: CGRect = CGRect(x: posX, y: posY, width: cropWidth, height: cropHeight)

    // Create bitmap image from context using the rect
    guard let imageRef: CGImage = newCgImage.cropping(to: rect) else { return self}

    // Create a new image based on the imageRef and rotate back to the original orientation
    let cropped: UIImage = UIImage(cgImage: imageRef, scale: self.scale, orientation: self.imageOrientation)

    UIGraphicsBeginImageContextWithOptions(to, false, self.scale)
    cropped.draw(in: CGRect(x: 0, y: 0, width: to.width, height: to.height))
    let resized = UIGraphicsGetImageFromCurrentImageContext()
    UIGraphicsEndImageContext()

    return resized ?? self
  }
}

extension UITableView{
    func reloaSpecificIndex(index : Int , section : Int){
        let indexPath = NSIndexPath(row: index, section: section)
        self.reloadRows(at: [indexPath as IndexPath], with: .fade)
    }
    
    func reloadTable(){
        DispatchQueue.main.async {
            self.delegate = self as? UITableViewDelegate
            self.dataSource = self as? UITableViewDataSource
            self.reloadData()
        }
    }
}


extension Date {
    var millisecondsSince1970:Int64 {
        return Int64((self.timeIntervalSince1970).rounded() * 1000)
    }
    
}

//extension String {
//    func aesEncrypt(key:String,iv:String) throws -> String {
//        let encrypted = try AES(key: key, iv: iv, padding: .pkcs7).encrypt([UInt8](self.data(using: .utf8)!))
//        return Data(encrypted).base64EncodedString()
//    }
//
//    func aesDecrypt(key:String,iv:String) throws -> String {
//        guard let data = Data(base64Encoded: self) else { return "" }
//        let decrypted = try AES(key: key, iv: iv, padding: .pkcs7).decrypt([UInt8](data))
//        return String(bytes: decrypted, encoding: .utf8) ?? self
//    }
//
//
//        func matches(_ regex: String) -> Bool {
//            return self.range(of: regex, options: .regularExpression, range: nil, locale: nil) != nil
//        }
//
//    func toLengthOf(length:Int) -> String {
//               if length <= 0 {
//                   return self
//               } else if let to = self.index(self.startIndex, offsetBy: length, limitedBy: self.endIndex) {
//                   return String(self[..<to])
//
//               } else {
//                   return ""
//               }
//           }
//
//}

extension UISwitch {
    
    func set(offTint color: UIColor ) {
        let minSide = min(bounds.size.height, bounds.size.width)
        layer.cornerRadius = minSide / 2
        backgroundColor = color
        tintColor = color
    }
}
extension UIColor {
    
    @nonobjc class var gradientDarkGrey: UIColor {
           return UIColor(red: 239 / 255.0, green: 241 / 255.0, blue: 241 / 255.0, alpha: 1)
       }

    @nonobjc class var gradientLightGrey: UIColor {
           return UIColor(red: 201 / 255.0, green: 201 / 255.0, blue: 201 / 255.0, alpha: 1)
       }
    
    @nonobjc class var black: UIColor {
        return UIColor(white: 46.0 / 255.0, alpha: 1.0)
    }
    //rgb(255, 243, 219)
    @nonobjc class var lightPurple: UIColor {
        return UIColor(red: 4 / 255.0, green: 70 / 255.0, blue: 95 / 255.0, alpha: 1.0)
    }
    
    @nonobjc class var customBlue: UIColor {
        return UIColor(red: 3 / 255.0, green: 56 / 255.0, blue: 75 / 255.0, alpha: 1.0)
    }
    
    @nonobjc class var customYellow: UIColor {
        return UIColor(red: 255 / 255.0, green: 243 / 255.0, blue: 219 / 255.0, alpha: 1.0)
    }
    // (240, 244, 255)
    @nonobjc class var customLavender: UIColor {
        return UIColor(red: 240 / 255.0, green: 244 / 255.0, blue: 255 / 255.0, alpha: 1.0)
    }
   // (255, 237, 233)
    @nonobjc class var customBeige: UIColor {
        return UIColor(red: 255 / 255.0, green: 237 / 255.0, blue: 233 / 255.0, alpha: 1.0)
    }
    // (248, 241, 255)
     @nonobjc class var customLilac: UIColor {
         return UIColor(red: 248 / 255.0, green: 241 / 255.0, blue: 255 / 255.0, alpha: 1.0)
     }
    // (233, 255, 237)
    @nonobjc class var customGreen: UIColor {
        return UIColor(red: 233 / 255.0, green: 255 / 255.0, blue: 237 / 255.0, alpha: 1.0)
    }
    // (255, 240, 246)
    @nonobjc class var customPink: UIColor {
        return UIColor(red: 255 / 255.0, green: 240 / 255.0, blue: 246 / 255.0, alpha: 1.0)
    }
    
    @nonobjc class var customTextColor: UIColor {
        return UIColor(red: 43 / 255.0, green: 95 / 255.0, blue: 116 / 255.0, alpha: 1.0)
    }
    
}

extension String {
    func toUInt() -> UInt? {
        let scanner = Scanner(string: self)
        var u: UInt64 = 0
        if scanner.scanUnsignedLongLong(&u)  && scanner.isAtEnd {
            return UInt(u)
        }
        return nil
    }
}

extension Double {
    func round(to places: Int) -> Double {
        let divisor = pow(10.0, Double(places))
        return (self * divisor).rounded() / divisor
    }
}

extension UIImage {
    enum JPEGQuality: CGFloat {
        case lowest  = 0
        case low     = 0.25
        case medium  = 0.5
        case high    = 0.75
        case highest = 1
    }

    /// Returns the data for the specified image in JPEG format.
    /// If the image object’s underlying image data has been purged, calling this function forces that data to be reloaded into memory.
    /// - returns: A data object containing the JPEG data, or nil if there was a problem generating the data. This function may return nil if the image has no data or if the underlying CGImageRef contains data in an unsupported bitmap format.
    func jpeg(_ quality: JPEGQuality) -> Data? {
        return self.jpegData(compressionQuality: quality.rawValue)
    }
}

//extension UIImageView {
//    func setImage(with urlString: String, placeholder: UIImage){
//        guard let url = URL.init(string: urlString) else {
//            return
//        }
//        let resource = ImageResource(downloadURL: url, cacheKey: urlString )
//        var kf = self.kf
//        kf.indicatorType = .activity
//
//        self.kf.setImage(with: resource, placeholder: placeholder)
//    }
//
//}

extension Array where Element: Equatable {
    
    // Remove first collection element that is equal to the given `object`:
    mutating func removeItemAt(object: Element) {
        guard let index = firstIndex(of: object) else {return}
        remove(at: index)
    }
    
}

extension Double {
    func getDateStringFromUTC(format:String) -> String {
        let date = Date(timeIntervalSince1970: self)
        let dateFormatter = DateFormatter()
        dateFormatter.timeZone = .current
        dateFormatter.dateFormat = format
        return dateFormatter.string(from: date)
    }
}

extension Date {
    func currentTimeMillis() -> Int64 {
        return Int64(self.timeIntervalSince1970 * 1000)
    }
}

extension String {
    func maxLength(length: Int) -> String {
        var str = self
        let nsString = str as NSString
        if nsString.length >= length {
            str = nsString.substring(with:
                                        NSRange(
                                            location: 0,
                                            length: nsString.length > length ? length : nsString.length)
            )
        }
        return  str
    }
}


extension UIButton {
    func underline() {
        guard let text = self.titleLabel?.text else { return }
        let attributedString = NSMutableAttributedString(string: text)
        //NSAttributedStringKey.foregroundColor : UIColor.blue
        attributedString.addAttribute(NSAttributedString.Key.underlineColor, value: self.titleColor(for: .normal)!, range: NSRange(location: 0, length: text.count))
        attributedString.addAttribute(NSAttributedString.Key.foregroundColor, value: self.titleColor(for: .normal)!, range: NSRange(location: 0, length: text.count))
        attributedString.addAttribute(NSAttributedString.Key.underlineStyle, value: NSUnderlineStyle.single.rawValue, range: NSRange(location: 0, length: text.count))
        self.setAttributedTitle(attributedString, for: .normal)
    }
}



extension UINavigationBar {
    func setGradientBackground(colors: [UIColor]) {
        var updatedFrame = bounds
        updatedFrame.size.height += self.frame.origin.y
        let gradientLayer = CAGradientLayer(frame: updatedFrame, colors: colors)
        setBackgroundImage(gradientLayer.createGradientImage(), for: UIBarMetrics.default)
    }
}

extension CAGradientLayer {
    
    convenience init(frame: CGRect, colors: [UIColor]) {
        self.init()
        self.frame = frame
        self.colors = []
        for color in colors {
            self.colors?.append(color.cgColor)
        }
        startPoint = CGPoint(x: 0, y: 1)
        endPoint = CGPoint(x: 0.8, y: 1)
    }
    
    func createGradientImage() -> UIImage? {
        
        var image: UIImage? = nil
        UIGraphicsBeginImageContext(bounds.size)
        if let context = UIGraphicsGetCurrentContext() {
            render(in: context)
            image = UIGraphicsGetImageFromCurrentImageContext()
        }
        UIGraphicsEndImageContext()
        return image
    }
    
}


 extension UIDevice {
    static let modelName: String = {
        var systemInfo = utsname()
        uname(&systemInfo)
        let machineMirror = Mirror(reflecting: systemInfo.machine)
        let identifier = machineMirror.children.reduce("") { identifier, element in
            guard let value = element.value as? Int8, value != 0 else { return identifier }
            return identifier + String(UnicodeScalar(UInt8(value)))
        }
        
        let deviceMapping = ["i386": "iPhone Simulator",
         "x86_64": "iPhone Simulator",
         "arm64": "iPhone Simulator",
         "iPhone1,1": "iPhone",
         "iPhone1,2": "iPhone 3G",
         "iPhone2,1": "iPhone 3GS",
         "iPhone3,1": "iPhone 4",
         "iPhone3,2": "iPhone 4 GSM Rev A",
         "iPhone3,3": "iPhone 4 CDMA",
         "iPhone4,1": "iPhone 4S",
         "iPhone5,1": "iPhone 5 (GSM)",
         "iPhone5,2": "iPhone 5 (GSM+CDMA)",
         "iPhone5,3": "iPhone 5C (GSM)",
         "iPhone5,4": "iPhone 5C (Global)",
         "iPhone6,1": "iPhone 5S (GSM)",
         "iPhone6,2": "iPhone 5S (Global)",
         "iPhone7,1": "iPhone 6 Plus",
         "iPhone7,2": "iPhone 6",
         "iPhone8,1": "iPhone 6s",
         "iPhone8,2": "iPhone 6s Plus",
         "iPhone8,4": "iPhone SE (GSM)",
         "iPhone9,1": "iPhone 7",
         "iPhone9,2": "iPhone 7 Plus",
         "iPhone9,3": "iPhone 7",
         "iPhone9,4": "iPhone 7 Plus",
         "iPhone10,1": "iPhone 8",
         "iPhone10,2": "iPhone 8 Plus",
         "iPhone10,3": "iPhone X Global",
         "iPhone10,4": "iPhone 8",
         "iPhone10,5": "iPhone 8 Plus",
         "iPhone10,6": "iPhone X GSM",
         "iPhone11,2": "iPhone XS",
         "iPhone11,4": "iPhone XS Max",
         "iPhone11,6": "iPhone XS Max Global",
         "iPhone11,8": "iPhone XR",
         "iPhone12,1": "iPhone 11",
         "iPhone12,3": "iPhone 11 Pro",
         "iPhone12,5": "iPhone 11 Pro Max",
         "iPhone12,8": "iPhone SE 2nd Gen",
         "iPhone13,1": "iPhone 12 Mini",
         "iPhone13,2": "iPhone 12",
         "iPhone13,3": "iPhone 12 Pro",
         "iPhone13,4": "iPhone 12 Pro Max",
         "iPod1,1": "1st Gen iPod",
         "iPod2,1": "2nd Gen iPod",
         "iPod3,1": "3rd Gen iPod",
         "iPod4,1": "4th Gen iPod",
         "iPod5,1": "5th Gen iPod",
         "iPod7,1": "6th Gen iPod",
         "iPod9,1": "7th Gen iPod",
         "iPad1,1": "iPad",
         "iPad1,2": "iPad 3G",
         "iPad2,1": "2nd Gen iPad",
         "iPad2,2": "2nd Gen iPad GSM",
         "iPad2,3": "2nd Gen iPad CDMA",
         "iPad2,4": "2nd Gen iPad New Revision",
         "iPad3,1": "3rd Gen iPad",
         "iPad3,2": "3rd Gen iPad CDMA",
         "iPad3,3": "3rd Gen iPad GSM",
         "iPad2,5": "iPad mini",
         "iPad2,6": "iPad mini GSM+LTE",
         "iPad2,7": "iPad mini CDMA+LTE",
         "iPad3,4": "4th Gen iPad",
         "iPad3,5": "4th Gen iPad GSM+LTE",
         "iPad3,6": "4th Gen iPad CDMA+LTE",
         "iPad4,1": "iPad Air (WiFi)",
         "iPad4,2": "iPad Air (GSM+CDMA)",
         "iPad4,3": "1st Gen iPad Air (China)",
         "iPad4,4": "iPad mini Retina (WiFi)",
         "iPad4,5": "iPad mini Retina (GSM+CDMA)",
         "iPad4,6": "iPad mini Retina (China)",
         "iPad4,7": "iPad mini 3 (WiFi)",
         "iPad4,8": "iPad mini 3 (GSM+CDMA)",
         "iPad4,9": "iPad Mini 3 (China)",
         "iPad5,1": "iPad mini 4 (WiFi)",
         "iPad5,2": "4th Gen iPad mini (WiFi+Cellular)",
         "iPad5,3": "iPad Air 2 (WiFi)",
         "iPad5,4": "iPad Air 2 (Cellular)",
         "iPad6,3": "iPad Pro (9.7 inch, WiFi)",
         "iPad6,4": "iPad Pro (9.7 inch, WiFi+LTE)",
         "iPad6,7": "iPad Pro (12.9 inch, WiFi)",
         "iPad6,8": "iPad Pro (12.9 inch, WiFi+LTE)",
         "iPad6,11": "iPad (2017)",
         "iPad6,12": "iPad (2017)",
         "iPad7,1": "iPad Pro 2nd Gen (WiFi)",
         "iPad7,2": "iPad Pro 2nd Gen (WiFi+Cellular)",
         "iPad7,3": "iPad Pro 10.5-inch",
         "iPad7,4": "iPad Pro 10.5-inch",
         "iPad7,5": "iPad 6th Gen (WiFi)",
         "iPad7,6": "iPad 6th Gen (WiFi+Cellular)",
         "iPad7,11": "iPad 7th Gen 10.2-inch (WiFi)",
         "iPad7,12": "iPad 7th Gen 10.2-inch (WiFi+Cellular)",
         "iPad8,1": "iPad Pro 11 inch 3rd Gen (WiFi)",
         "iPad8,2": "iPad Pro 11 inch 3rd Gen (1TB, WiFi)",
         "iPad8,3": "iPad Pro 11 inch 3rd Gen (WiFi+Cellular)",
         "iPad8,4": "iPad Pro 11 inch 3rd Gen (1TB, WiFi+Cellular)",
         "iPad8,5": "iPad Pro 12.9 inch 3rd Gen (WiFi)",
         "iPad8,6": "iPad Pro 12.9 inch 3rd Gen (1TB, WiFi)",
         "iPad8,7": "iPad Pro 12.9 inch 3rd Gen (WiFi+Cellular)",
         "iPad8,8": "iPad Pro 12.9 inch 3rd Gen (1TB, WiFi+Cellular)",
         "iPad8,9": "iPad Pro 11 inch 4th Gen (WiFi)",
         "iPad8,10": "iPad Pro 11 inch 4th Gen (WiFi+Cellular)",
         "iPad8,11": "iPad Pro 12.9 inch 4th Gen (WiFi)",
         "iPad8,12": "iPad Pro 12.9 inch 4th Gen (WiFi+Cellular)",
         "iPad11,1": "iPad mini 5th Gen (WiFi)",
         "iPad11,2": "iPad mini 5th Gen",
         "iPad11,3": "iPad Air 3rd Gen (WiFi)",
         "iPad11,4": "iPad Air 3rd Gen",
         "iPad11,6": "iPad 8th Gen (WiFi)",
         "iPad11,7": "iPad 8th Gen (WiFi+Cellular)",
         "iPad13,1": "iPad air 4th Gen (WiFi)",
         "iPad13,2": "iPad air 4th Gen (WiFi+Cellular)",
         "iPad13,4": "iPad Pro 11 inch 3rd Gen",
         "iPad13,5": "iPad Pro 11 inch 3rd Gen",
         "iPad13,6": "iPad Pro 11 inch 3rd Gen",
         "iPad13,7": "iPad Pro 11 inch 3rd Gen",
         "iPad13,8": "iPad Pro 12.9 inch 5th Gen",
         "iPad13,9": "iPad Pro 12.9 inch 5th Gen",
         "iPad13,10": "iPad Pro 12.9 inch 5th Gen",
         "iPad13,11": "iPad Pro 12.9 inch 5th Gen"]
        return deviceMapping[identifier] ?? identifier
    }()
}

extension UILabel
{
    
    var optimalWidth : CGFloat
    {
        get
        {
            let label = UILabel(frame: CGRect(x: 0, y: 0, width:  CGFloat.greatestFiniteMagnitude, height:  self.frame.height))
            label.numberOfLines = 0
            label.lineBreakMode = self.lineBreakMode
            label.font = self.font
            label.text = self.text
            label.sizeToFit()
            
            return label.frame.width
        }
    }
    
    var optimalHieght : CGFloat
    {
        get
        {
            let label = UILabel(frame: CGRect(x: 0, y: 0, width: self.frame.width , height: CGFloat.greatestFiniteMagnitude))
            label.numberOfLines = 0
            label.lineBreakMode = self.lineBreakMode
            label.font = self.font
            label.text = self.text
            
            label.sizeToFit()
            
            return label.frame.height
        }
    }
    
    func addTrailing(with trailingText: String, moreText: String, moreTextFont: UIFont, moreTextColor: UIColor) {
        let readMoreText: String = trailingText + moreText
        
        let lengthForVisibleString: Int = self.vissibleTextLength
        let mutableString: String = self.text!
        let trimmedString: String? = (mutableString as NSString).replacingCharacters(in: NSRange(location: lengthForVisibleString, length: ((self.text?.count)! - lengthForVisibleString)), with: "")
        let readMoreLength: Int = (readMoreText.count)
        let trimmedForReadMore: String = (trimmedString! as NSString).replacingCharacters(in: NSRange(location: ((trimmedString?.count ?? 0) - readMoreLength), length: readMoreLength), with: "") + trailingText
        let answerAttributed = NSMutableAttributedString(string: trimmedForReadMore, attributes: [NSAttributedString.Key.font: self.font!])
        let readMoreAttributed = NSMutableAttributedString(string: moreText, attributes: [NSAttributedString.Key.font: moreTextFont, NSAttributedString.Key.foregroundColor: moreTextColor])
        answerAttributed.append(readMoreAttributed)
        self.attributedText = answerAttributed
    }
    
    var vissibleTextLength: Int {
        let font: UIFont = self.font
        let mode: NSLineBreakMode = self.lineBreakMode
        let labelWidth: CGFloat = self.frame.size.width
        let labelHeight: CGFloat = self.frame.size.height
        let sizeConstraint = CGSize(width: labelWidth, height: CGFloat.greatestFiniteMagnitude)
        
        let attributes: [AnyHashable: Any] = [NSAttributedString.Key.font: font]
        let attributedText = NSAttributedString(string: self.text!, attributes: attributes as? [NSAttributedString.Key : Any])
        let boundingRect: CGRect = attributedText.boundingRect(with: sizeConstraint, options: .usesLineFragmentOrigin, context: nil)
        
        if boundingRect.size.height > labelHeight {
            var index: Int = 0
            var prev: Int = 0
            let characterSet = CharacterSet.whitespacesAndNewlines
            repeat {
                prev = index
                if mode == NSLineBreakMode.byCharWrapping {
                    index += 1
                } else {
                    index = (self.text! as NSString).rangeOfCharacter(from: characterSet, options: [], range: NSRange(location: index + 1, length: self.text!.count - index - 1)).location
                }
            } while index != NSNotFound && index < self.text!.count && (self.text! as NSString).substring(to: index).boundingRect(with: sizeConstraint, options: .usesLineFragmentOrigin, attributes: attributes as? [NSAttributedString.Key : Any], context: nil).size.height <= labelHeight
            return prev
        }
        return self.text!.count
    }
    
}

extension UIView {
    func cardView(cornerRadius: CGFloat = 20, shadowOffsetWidth: Int = 1, shadowOffsetHeight: Int = 3,shadowOpacity:Float = 0.8){
        
       
        let shadowColor: UIColor? = UIColor.gray
    
        self.layer.cornerRadius = cornerRadius
        let shadowPath = UIBezierPath(roundedRect: bounds, cornerRadius: cornerRadius)
        self.layer.masksToBounds = true
        self.layer.shadowColor = shadowColor?.cgColor
        self.layer.shadowOffset = CGSize(width: shadowOffsetWidth, height: shadowOffsetHeight);
        self.layer.shadowOpacity = shadowOpacity
        self.layer.shadowPath = shadowPath.cgPath
        
    }
    
    func roundCorners(corners: UIRectCorner, radius: CGFloat) {
            let path = UIBezierPath(roundedRect: bounds, byRoundingCorners: corners, cornerRadii: CGSize(width: radius, height: radius))
            let mask = CAShapeLayer()
            mask.path = path.cgPath
            layer.mask = mask
        }
    
}

class CustomSlide: UISlider {
    
    @IBInspectable var trackHeight: CGFloat = 8
    
    override func trackRect(forBounds bounds: CGRect) -> CGRect {
        //set your bounds here
        return CGRect(origin: bounds.origin, size: CGSize(width: bounds.width, height: trackHeight))
    }
    
//    override func awakeFromNib() {
//        self.setThumbImage(#imageLiteral(resourceName: "location"), for: .normal)
////        self.thumbTintColor = .clear
//        self.setThumbImage(#imageLiteral(resourceName: "location"), for: .focused)
//        super.awakeFromNib()
//    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        self.layer.cornerRadius = 4
        
    }
    
}

extension UIView{
    
    func popUpAnimated(){
        self.transform = CGAffineTransform(translationX: +self.frame.size.width, y: 0)
        
        UIView.animate(withDuration: 1.5, delay: 0.05 , usingSpringWithDamping: 0.8, initialSpringVelocity: 0, options: .curveEaseInOut, animations: {
            self.transform = CGAffineTransform(translationX: 0, y: 0)
            
        }, completion: nil)
    }
    
    func popDownAnimated(){
        self.transform = CGAffineTransform(translationX: 0 , y: 0)
        UIView.animate(withDuration: 1.5, delay: 0.05 , usingSpringWithDamping: 0.8, initialSpringVelocity: 0, options: .curveEaseOut, animations: {
            self.transform = CGAffineTransform(translationX: -600, y: 0)
            
        }, completion: { (finished: Bool) in
            self.isHidden = true
        })
    }
    
    func setRightCornerRadius(view : UIView, radius : CGFloat, color: UIColor = .white){
        DispatchQueue.main.asyncAfter(deadline: .now() + .milliseconds(10)) {
            self.layer.sublayers?.forEach{
                if $0.name == "rightcorner" {$0.removeFromSuperlayer() }
            }
            let path = UIBezierPath(roundedRect: view.bounds, byRoundingCorners: [.topRight, .bottomRight], cornerRadii: CGSize(width: radius, height: radius))
            let maskLayer = CAShapeLayer()
            maskLayer.frame = view.bounds
            maskLayer.path = path.cgPath
            maskLayer.name = "rightcorner"
            maskLayer.fillColor = color.cgColor
            self.backgroundColor = .clear
            self.layer.insertSublayer(maskLayer, at: 0)
            self.layoutIfNeeded()
        }
   
    }
    
    func setTopRightCornerRadius(view : UIView, radius : CGFloat, color: UIColor = .white){
        DispatchQueue.main.asyncAfter(deadline: .now() + .milliseconds(10)) {
            self.layer.sublayers?.forEach{
                if $0.name == "toprightcorner" {$0.removeFromSuperlayer() }
            }
            let path = UIBezierPath(roundedRect: view.bounds, byRoundingCorners: [.topRight], cornerRadii: CGSize(width: radius, height: radius))
            let maskLayer = CAShapeLayer()
            maskLayer.frame = view.bounds
            maskLayer.path = path.cgPath
            maskLayer.name = "toprightcorner"
            self.layer.insertSublayer(maskLayer, at: 0)
            self.layoutIfNeeded()
        }
        
    }
    
    func setBottomRightCornerRadius(view : UIView, radius : CGFloat, color: UIColor = .clear){
        DispatchQueue.main.asyncAfter(deadline: .now() + .milliseconds(10)) {
            self.layer.sublayers?.forEach{
                if $0.name == "bottomrightcorner" {$0.removeFromSuperlayer() }
            }
            let path = UIBezierPath(roundedRect: view.bounds, byRoundingCorners: [.topRight,.bottomRight], cornerRadii: CGSize(width: radius, height: radius))
            let maskLayer = CAShapeLayer()
            maskLayer.frame = view.bounds
            maskLayer.path = path.cgPath
            maskLayer.name = "bottomrightcorner"
            maskLayer.fillColor = color.cgColor
            self.backgroundColor = .clear
            self.layer.insertSublayer(maskLayer, at: 0)
            self.layoutIfNeeded()
        }
        
    }
    
    func showAnimate()
    {
        self.transform = CGAffineTransform(scaleX: 1.3, y: 1.3)
        self.alpha = 0.0;
        UIView.animate(withDuration: 0.25, animations: {
            self.alpha = 1.0
            self.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
        });
    }
    
    func removeAnimate()
    {
        UIView.animate(withDuration: 0.25, animations: {
            self.transform = CGAffineTransform(scaleX: 1.3, y: 1.3)
            self.alpha = 0.0;
        }, completion:{(finished : Bool)  in
            if (finished)
            {
                self.removeFromSuperview()
            }
        });
    }
    
    func PopUpAnimatedView() {
        
        self.transform = CGAffineTransform(translationX: 0, y: +self.frame.size.height)
        
        UIView.animate(withDuration: 1.5, delay: 0.05 , usingSpringWithDamping: 0.8, initialSpringVelocity: 0, options: .curveEaseInOut, animations: {
            self.transform = CGAffineTransform(translationX: 0, y: 0)
            
        }, completion: nil)
        
    }
    
    func PopDownAnimatedView(){
        
        self.transform = CGAffineTransform(translationX: 0, y: 0)
        UIView.animate(withDuration: 1.5, delay: 0.05 , usingSpringWithDamping: 0.8, initialSpringVelocity: 0, options: .curveEaseOut, animations: {
            self.transform = CGAffineTransform(translationX: 0, y: +(self.frame.size.height + 50))
        }, completion: {_ in
            self.isHidden = true
        })
    }
    
    func validateCardType(cardNo: String) -> String {

        let testCard = cardNo.replacingOccurrences(of: " ", with: "")
        
        let regVisa = "^4[0-9]{6,}$"
        let regMaster = "^5[1-5][0-9]{5,}$"
        let regExpress = "^3[47][0-9]{5,}$"
        let regDiners = "^3(?:0[0-5]|[68][0-9])[0-9]{4,}$"
        let regDiscover = "^6(?:011|5[0-9]{2})[0-9]{3,}$"
        let regJCB = "^(?:2131|1800|35[0-9]{3})[0-9]{3,}$"


        let regVisaTest = NSPredicate(format: "SELF MATCHES %@", regVisa)
        let regMasterTest = NSPredicate(format: "SELF MATCHES %@", regMaster)
        let regExpressTest = NSPredicate(format: "SELF MATCHES %@", regExpress)
        let regDinersTest = NSPredicate(format: "SELF MATCHES %@", regDiners)
        let regDiscoverTest = NSPredicate(format: "SELF MATCHES %@", regDiscover)
        let regJCBTest = NSPredicate(format: "SELF MATCHES %@", regJCB)


        if regVisaTest.evaluate(with: testCard){
            return "visa"
        }
        else if regMasterTest.evaluate(with: testCard){
            return "mastercard"
        }

        else if regExpressTest.evaluate(with: testCard){
            return "american_express"
        }

        else if regDinersTest.evaluate(with: testCard){
            return "diners_club"
        }

        else if regDiscoverTest.evaluate(with: testCard){
            return "discover"
        }

        else if regJCBTest.evaluate(with: testCard){
            return "jcb"
        }

        return ""

    }
    
    
    var width: CGFloat {
        get{
            return self.frame.size.width
        }
        set{
            self.frame.size.width = newValue
        }
    }
    
    var height: CGFloat {
        get{
            return self.frame.size.height
        }
        set{
            self.frame.size.height = newValue
        }
    }
    
    var size: CGSize  {
        get{
            return self.frame.size
        }
        set{
            self.frame.size = newValue
        }
    }
    
    var origin:CGPoint {
        get{
            return self.frame.origin
        }
        set{
            self.frame.origin = newValue
        }
    }
    
    var x:          CGFloat {
        get{
            return self.frame.origin.x
        }
        set{
            
            self.frame.origin = CGPoint(x: newValue, y: self.frame.origin.y)
            
        }
    }
    
    var y:   CGFloat {
        get{
            return self.frame.origin.y
        }
        set{
            self.frame.origin = CGPoint(x: self.frame.origin.x, y: newValue)
        }
    }
    
    var centerX:    CGFloat {
        get{
            return self.center.x
        }
        set{
            self.center = CGPoint(x: newValue, y: self.center.y)
        }
    }
    
    var centerY:    CGFloat {
        get{
            return self.center.y
        }
        set{
            self.center = CGPoint(x: self.center.x, y: newValue)
        }
    }
    
    var minX:       CGFloat {
        get{
            return self.frame.origin.x
        }
        set{
            self.frame.origin.x = newValue
        }
    }
    
    var maxX:      CGFloat {
        get{
            return self.frame.origin.x + self.frame.size.width
        }
        set{
            self.frame.origin.x = newValue - self.frame.size.width
        }
    }
    
    var minY:        CGFloat {
        get{
            return self.frame.origin.y
        }
        set{
            self.frame.origin.y = newValue
        }
    }
    
    var maxY:     CGFloat {
        get{
            return self.frame.origin.y + self.frame.size.height
        }
        set{
            self.frame.origin.y = newValue - self.frame.size.height
        }
    }
    
    convenience init(
        frame_:CGRect = CGRect.zero,
        backgroundColor:UIColor = UIColor.clear
    ){
        self.init(frame:frame_)
        self.backgroundColor=backgroundColor
    }
    
    @IBInspectable var cornerRadius: Double {
        get {
            return Double(self.layer.cornerRadius)
        }
        set {
            self.layer.cornerRadius = CGFloat(newValue)
        }
    }
    
    /// The width of the layer's border, inset from the layer bounds. The border is composited above the layer's content and sublayers and includes the effects of the `cornerRadius' property. Defaults to zero. Animatable.
    
    
    
    @IBInspectable var borderWidth: Double {
        get {
            return Double(self.layer.borderWidth)
        }
        set {
            self.layer.borderWidth = CGFloat(newValue)
        }
    }
    
    /// The color of the layer's border. Defaults to opaque black. Colors created from tiled patterns are supported. Animatable.
    @IBInspectable var borderColor: UIColor? {
        get {
            return UIColor(cgColor: self.layer.borderColor!)
        }
        set {
            self.layer.borderColor = newValue?.cgColor
        }
    }
    
    /// The color of the shadow. Defaults to opaque black. Colors created from patterns are currently NOT supported. Animatable.
    @IBInspectable var shadowColor: UIColor?{
        get {
            return UIColor(cgColor: self.layer.shadowColor!)
        }
        set {
            self.layer.shadowColor = newValue?.cgColor
        }
    }
    
    /// The opacity of the shadow. Defaults to 0. Specifying a value outside the [0,1] range will give undefined results. Animatable.
    @IBInspectable var shadowOpacity: Float {
        get {
            return self.layer.shadowOpacity
        }
        set {
            self.layer.shadowOpacity = newValue
        }
    }
    
    /// The shadow offset. Defaults to (0, -3). Animatable.
    @IBInspectable var shadowOffset: CGSize {
        get {
            return self.layer.shadowOffset
        }
        set {
            self.layer.shadowOffset = newValue
        }
    }
    
    /// The blur radius used to create the shadow. Defaults to 3. Animatable.
    @IBInspectable var shadowRadius: Double {
        get {
            return Double(self.layer.shadowRadius)
        }
        set {
            self.layer.shadowRadius = CGFloat(newValue)
        }
    }
    
    
}
extension UILabel {
    func underlineMyText(range1:String) {
        if let textString = self.text {
            
            let str = NSString(string: textString)
            let firstRange = str.range(of: range1)
            let attributedString = NSMutableAttributedString(string: textString)
            attributedString.addAttribute(NSAttributedString.Key.underlineStyle, value: NSUnderlineStyle.single.rawValue, range: firstRange)
            attributedText = attributedString
        }
    }
}

func listCountriesAndCurrencies(countryCode : String) -> String {
    var currencyCode = "$"
    let localeIds = Locale.availableIdentifiers
    var countryCurrency = [String: String]()
    for localeId in localeIds {
        let locale = Locale(identifier: localeId)
        
        if let country = locale.regionCode, country.count == 2 {
            if let currency = locale.currencySymbol {
                countryCurrency[country] = currency
            }
        }
    }
    
    let sorted = countryCurrency.keys.sorted()
    for country in sorted {
        let currency = countryCurrency[country]!
        
        print("country: \(country), currency: \(currency)")
        if country == countryCode {
            currencyCode = currency
            print("selected Country : \(currencyCode)")
        }
    }
    return currencyCode
}


extension UIImageView
{
    
    
    func dropShadow() {
        self.layer.masksToBounds = false
        self.layer.shadowColor = UIColor.black.cgColor
        self.layer.shadowOpacity = 0.5
        self.layer.shadowOffset = CGSize(width: -1, height: 1)
        self.layer.shadowRadius = 1
        self.layer.shadowPath = UIBezierPath(rect: self.bounds).cgPath
        self.layer.shouldRasterize = true
        self.layer.rasterizationScale = UIScreen.main.scale
    }
    
}

extension String {
    func withBoldText(text: String, font: UIFont? = nil) -> NSAttributedString {
        let _font = font ?? UIFont.systemFont(ofSize: 14, weight: .regular)
        let fullString = NSMutableAttributedString(string: self, attributes: [NSAttributedString.Key.font: _font])
        let boldFontAttribute: [NSAttributedString.Key: Any] = [NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: _font.pointSize)]
        let range = (self as NSString).range(of: text)
        fullString.addAttributes(boldFontAttribute, range: range)
        return fullString
    }}

extension UIViewController {
    
    func getMilisecondsFromDate(date : Date) -> Int64 {
        let inMillis = date.timeIntervalSince1970
        return Int64(round(inMillis))
    }
    
    func presentfromBottomToTop(vc : UIViewController){
        vc.modalPresentationStyle = .overCurrentContext
        vc.modalTransitionStyle = .crossDissolve
        let transition = CATransition()
        transition.duration = 0.7
        transition.type = CATransitionType.push
        transition.subtype = CATransitionSubtype.fromLeft
        vc.view.layer.add(transition, forKey: kCATransition)
        self.present(vc, animated: false, completion: nil)
    }
    
    func dismisFromTopToBottom(){
        let transition = CATransition()
        transition.duration = 0.4
        transition.type = CATransitionType.push
        transition.subtype = CATransitionSubtype.fromRight
        view.layer.add(transition, forKey: kCATransition)
        self.dismiss(animated: true, completion: nil)
    }
    func transparrentNavigation(){
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        self.navigationController?.navigationBar.isTranslucent = true
        self.navigationController?.view.backgroundColor = .clear
    }
    
    func setBackButtonWithTitle(title : String){
        
        let backBtn = UIButton()
        backBtn.frame = CGRect(x: 0, y: 0, width: 18, height: 18)
        backBtn.setImage(UIImage(named:"back"), for: .normal)
        backBtn.setTitleColor(UIColor.black, for: .normal)
        backBtn.addTarget(self, action: #selector(self.click_BackButton), for: .touchUpInside)
        backBtn.isUserInteractionEnabled = true
        backBtn.isEnabled = true
        let backNavBtn = UIBarButtonItem.init(customView: backBtn)
        backNavBtn.customView = backBtn
        // Title Code
        let titleLbl = UIButton()
        titleLbl.setTitle(title, for: .normal)
        //        titleLbl.titleLabel?.font = UIFont(name: Constants.fonts.ProximaNova_Regular, size: 20)!
        //titleLbl.titleLabel?.font = UIFont.boldSystemFont(ofSize: 18)
        titleLbl.titleLabel?.font = UIFont.init(name: "Roboto-Medium", size: 19.0)
        titleLbl.frame = CGRect(x: 0, y: 0, width: (titleLbl.titleLabel?.optimalWidth)!, height: 40)
        titleLbl.addTarget(self, action: #selector(self.click_BackButton), for: .touchUpInside)
        titleLbl.setTitleColor(.black, for: .normal)
        
        let leftItem = UIBarButtonItem.init(customView: titleLbl)
        leftItem.customView?.frame = CGRect(x: 0, y: 0, width: (titleLbl.titleLabel?.optimalWidth)!, height: 40)
        leftItem.customView = titleLbl
        let _ = navigationItem.backBarButtonItem
        self.navigationItem.leftBarButtonItems = [backNavBtn, leftItem]
        
        if #available(iOS 13.0, *) {
            let app = UIApplication.shared
            let statusBarHeight: CGFloat = app.statusBarFrame.size.height
            
            let statusbarView = UIView()
            //  statusbarView.backgroundColor = UIColor.init(hex: Constants.Colors.statusColor, alpha: 1.0)
            view.addSubview(statusbarView)
            
            statusbarView.translatesAutoresizingMaskIntoConstraints = false
            statusbarView.heightAnchor
                .constraint(equalToConstant: statusBarHeight).isActive = true
            statusbarView.widthAnchor
                .constraint(equalTo: view.widthAnchor, multiplier: 1.0).isActive = true
            statusbarView.topAnchor
                .constraint(equalTo: view.topAnchor).isActive = true
            statusbarView.centerXAnchor
                .constraint(equalTo: view.centerXAnchor).isActive = true
            
        } else {
            let statusBar = UIApplication.shared.value(forKeyPath: "statusBarWindow.statusBar") as? UIView
            // statusBar?.backgroundColor = UIColor.init(hex: Constants.Colors.statusColor, alpha: 1.0)
        }
    }
        
    @objc func click_BackButton(){
       
        DispatchQueue.main.async {
            self.navigationController?.popViewController(animated: true)
           
        }
    }
    
    
    
    
    func setTrackiImageButton_onRight(){
        
        //Notification button
        let notificationBtn = UIButton()
        notificationBtn.frame = CGRect(x: 0, y: 0, width: 120, height: 42)
        notificationBtn.setBackgroundImage(UIImage(named: "email"), for: .normal)
        notificationBtn.setTitleColor(UIColor.white, for: .normal)
        notificationBtn.contentMode = UIView.ContentMode.scaleToFill
        notificationBtn.isEnabled = false
        notificationBtn.isUserInteractionEnabled = false
        let notificationNavBtn = UIBarButtonItem.init(customView: notificationBtn)
        notificationNavBtn.customView = notificationBtn
        self.navigationItem.rightBarButtonItems = [notificationNavBtn]
    }
    
    func setLeftButnEmpty(){
        let backBtn = UIButton()
        backBtn.frame = CGRect(x: 0, y: 0, width: 25, height: 25)
        backBtn.setTitleColor(UIColor.black, for: .normal)
        let backNavBtn = UIBarButtonItem.init(customView: backBtn)
        backNavBtn.customView = backBtn
        let _ = navigationItem.backBarButtonItem
        self.navigationItem.leftBarButtonItems = [backNavBtn]
    }
    
}

extension UITextField{
   
}

extension String {
    func isEmptyOrWhitespace() -> Bool {
        
        // Check empty string
        if self.isEmpty {
            return true
        }
        // Trim and check empty string
        return (self.trimmingCharacters(in: .whitespaces) == "")
    }
}


// MARK: - TEXTFIELD EXTENSION

private var __maxLengths = [UITextField: Int]()
extension UITextField {
    
    @IBInspectable var placeHolderColor: UIColor? {
        get {
            return self.placeHolderColor
        }
        set {
            self.attributedPlaceholder = NSAttributedString(string:self.placeholder != nil ? self.placeholder! : "", attributes:[NSAttributedString.Key.foregroundColor: newValue!])
        }
    }
    
    func setTheImageWithText(imageName : String){
        self.rightView?.frame = CGRect(x: 200 , y: 0, width: 20 , height:20)
        self.rightViewMode = .always
        self.rightView = UIImageView(image: UIImage(named: "\(imageName)"))
    }
    
    @IBInspectable var maxLength: Int {
        get {
            guard let l = __maxLengths[self] else {
                return 150 // (global default-limit. or just, Int.max)
            }
            return l
        }
        set {
            __maxLengths[self] = newValue
            addTarget(self, action: #selector(fix), for: .editingChanged)
        }
    }
    @objc func fix(textField: UITextField) {
        if let t = textField.text {
            textField.text = String(t.prefix(maxLength))
        }
    }
}

// MARK: - HEX TO RGB

extension UIColor {
    convenience init(hex: UInt32, alpha: CGFloat) {
        let red = CGFloat((hex & 0xFF0000) >> 16)/256.0
        let green = CGFloat((hex & 0xFF00) >> 8)/256.0
        let blue = CGFloat(hex & 0xFF)/256.0
        self.init(red: red, green: green, blue: blue, alpha: alpha)
    }
}

// MARK: - STATUSBARVIEW

extension UIApplication {
    var statusBarView: UIView? {
        if responds(to: Selector(("statusBar"))) {
            return value(forKey: "statusBar") as? UIView
        }
        return nil
    }
}

// MARK: - NULLKEY REMOVER

extension Dictionary {
    func nullKeyRemoval() -> Dictionary {
        var dict = self
        
        let keysToRemove = Array(dict.keys).filter { dict[$0] is NSNull }
        for key in keysToRemove {
            //            dict.removeValue(forKey: key)
            dict[key] = "" as? Value
        }
        
        return dict
    }
}
// MARK: -  SNACK BAR
func showSnackbar(message:String, isErrorMessage : Bool) {
    
    let snackbar = TTGSnackbar(message: message, duration: .middle,actionText: "", actionBlock: { (snackbar) in
        print("Click action!")
        snackbar.dismiss()
    })
    
    snackbar.messageLabel.font = UIFont.systemFont(ofSize: 14)
    snackbar.actionButton.setImage(#imageLiteral(resourceName: "snackbar_close"), for: .normal)
    snackbar.animationType = .slideFromTopBackToTop
    if isErrorMessage {
        snackbar.icon = #imageLiteral(resourceName: "error")
    }else{
        snackbar.icon = #imageLiteral(resourceName: "check_icon")
    }
    snackbar.show()
    
}
// MARK: - TAP GESTURE
extension UITapGestureRecognizer {

    func didTapAttributedTextInLabel(label: UILabel, inRange targetRange: NSRange) -> Bool {
        // Create instances of NSLayoutManager, NSTextContainer and NSTextStorage
        let layoutManager = NSLayoutManager()
        let textContainer = NSTextContainer(size: CGSize.zero)
        let textStorage = NSTextStorage(attributedString: label.attributedText!)

        // Configure layoutManager and textStorage
        layoutManager.addTextContainer(textContainer)
        textStorage.addLayoutManager(layoutManager)

        // Configure textContainer
        textContainer.lineFragmentPadding = 0.0
        textContainer.lineBreakMode = label.lineBreakMode
        textContainer.maximumNumberOfLines = label.numberOfLines
        let labelSize = label.bounds.size
        textContainer.size = labelSize

        // Find the tapped character location and compare it to the specified range
        let locationOfTouchInLabel = self.location(in: label)
        let textBoundingBox = layoutManager.usedRect(for: textContainer)
        //let textContainerOffset = CGPointMake((labelSize.width - textBoundingBox.size.width) * 0.5 - textBoundingBox.origin.x,
                                              //(labelSize.height - textBoundingBox.size.height) * 0.5 - textBoundingBox.origin.y);
        let textContainerOffset = CGPoint(x: (labelSize.width - textBoundingBox.size.width) * 0.5 - textBoundingBox.origin.x, y: (labelSize.height - textBoundingBox.size.height) * 0.5 - textBoundingBox.origin.y)

        //let locationOfTouchInTextContainer = CGPointMake(locationOfTouchInLabel.x - textContainerOffset.x,
                                                        // locationOfTouchInLabel.y - textContainerOffset.y);
        let locationOfTouchInTextContainer = CGPoint(x: locationOfTouchInLabel.x - textContainerOffset.x, y: locationOfTouchInLabel.y - textContainerOffset.y)
        let indexOfCharacter = layoutManager.characterIndex(for: locationOfTouchInTextContainer, in: textContainer, fractionOfDistanceBetweenInsertionPoints: nil)
        return NSLocationInRange(indexOfCharacter, targetRange)
    }

}
// MARK: - ROTATE IMAGES
extension UIImage{
    func rotate(radians: Double) -> UIImage? {
        var newSize = CGRect(origin: CGPoint.zero, size: self.size).applying(CGAffineTransform(rotationAngle: CGFloat(radians))).size
        // Trim off the extremely small float value to prevent core graphics from rounding it up
        newSize.width = floor(newSize.width)
        newSize.height = floor(newSize.height)
        
        UIGraphicsBeginImageContextWithOptions(newSize, false, self.scale)
        let context = UIGraphicsGetCurrentContext()!
        
        // Move origin to middle
        context.translateBy(x: newSize.width/2, y: newSize.height/2)
        // Rotate around middle
        context.rotate(by: CGFloat(radians))
        // Draw the image at its center
        self.draw(in: CGRect(x: -self.size.width/2, y: -self.size.height/2, width: self.size.width, height: self.size.height))
        
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return newImage
    }
}

// MARK: - DATE FUNCTIONS

extension Date {
    init(milliseconds:Int64) {
        self = Date(timeIntervalSince1970: TimeInterval(milliseconds) / 1000)
    }
    
    /// Returns the amount of years from another date
    func years(from date: Date) -> Int {
        return Calendar.current.dateComponents([.year], from: date, to: self).year ?? 0
    }
    /// Returns the amount of months from another date
    func months(from date: Date) -> Int {
        return Calendar.current.dateComponents([.month], from: date, to: self).month ?? 0
    }
    /// Returns the amount of weeks from another date
    func weeks(from date: Date) -> Int {
        return Calendar.current.dateComponents([.weekOfMonth], from: date, to: self).weekOfMonth ?? 0
    }
    /// Returns the amount of days from another date
    func days(from date: Date) -> Int {
        return Calendar.current.dateComponents([.day], from: date, to: self).day ?? 0
    }
    /// Returns the amount of hours from another date
    func hours(from date: Date) -> Int {
        return Calendar.current.dateComponents([.hour], from: date, to: self).hour ?? 0
    }
    /// Returns the amount of minutes from another date
    func minutes(from date: Date) -> Int {
        return Calendar.current.dateComponents([.minute], from: date, to: self).minute ?? 0
    }
    /// Returns the amount of seconds from another date
    func seconds(from date: Date) -> Int {
        return Calendar.current.dateComponents([.second], from: date, to: self).second ?? 0
    }
    /// Returns the a custom time interval description from another date
    func offset(from date: Date) -> String {
        if years(from: date)   > 0 { return "\(years(from: date))y"   }
        if months(from: date)  > 0 { return "\(months(from: date))M"  }
        if weeks(from: date)   > 0 { return "\(weeks(from: date))w"   }
        if days(from: date)    > 0 { return "\(days(from: date))d"    }
        if hours(from: date)   > 0 { return "\(hours(from: date))h"   }
        if minutes(from: date) > 0 { return "\(minutes(from: date))m" }
        if seconds(from: date) > 0 { return "\(seconds(from: date))s" }
        return ""
    }
    
    func getOldDateFromCurrenDate(value: Int, format: Calendar.Component) -> Date{
        let earlyDate = Calendar.current.date(
            byAdding: format,
            value: value,
            to: Date())
        return earlyDate!
    }
    
    func getCurrentTimeZoneDate(format : String) -> Date{
        let dateFormatter = DateFormatter()
        dateFormatter.timeStyle = DateFormatter.Style.medium //Set time style
        dateFormatter.dateStyle = DateFormatter.Style.medium //Set date style
        let localDate = dateFormatter.string(from: Date())
        let date = serverToLocal(date: localDate)!
        return date
    }
    
    func serverToLocal(date:String) -> Date? {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MM/dd/yy hh:mm a"
        dateFormatter.timeStyle = DateFormatter.Style.medium //Set time style
        dateFormatter.dateStyle = DateFormatter.Style.medium //Set date style
        dateFormatter.timeZone = .current
        dateFormatter.locale = Locale.current
        let localDate = dateFormatter.date(from: date)
        return localDate
    }
    
    func add(years: Int = 0, months: Int = 0, days: Int = 0, hours: Int = 0, minutes: Int = 0, seconds: Int = 0) -> Date? {
        let components = DateComponents(year: years, month: months, day: days, hour: hours, minute: minutes, second: seconds)
        return Calendar.current.date(byAdding: components, to: self)
    }
    
}

// MARK: - ROUND DOUBLE

extension Double {
    /// Rounds the double to decimal places value
    func rounded(toPlaces places:Int) -> Double {
        let divisor = pow(10.0, Double(places))
        return (self * divisor).rounded() / divisor
    }
}

extension UIView {
func addDashedLine(strokeColor: UIColor, lineWidth: CGFloat) {

    backgroundColor = .clear

    let shapeLayer = CAShapeLayer()
    shapeLayer.name = "DashedBottomLine"
    shapeLayer.bounds = bounds
    shapeLayer.position = CGPoint(x: frame.width / 2, y: frame.height * 1.5)
    shapeLayer.fillColor = UIColor.clear.cgColor
    shapeLayer.strokeColor = strokeColor.cgColor
    shapeLayer.lineWidth = lineWidth
    shapeLayer.lineJoin = CAShapeLayerLineJoin.round
    shapeLayer.lineDashPattern = [6, 4]

    let path = CGMutablePath()
    path.move(to: CGPoint.zero)
    path.addLine(to: CGPoint(x: frame.width, y: 0))
    shapeLayer.path = path

    layer.addSublayer(shapeLayer)
}
}

// MARK: - LOADING BUTTON

extension UIButton {
    func loadingIndicator(_ show: Bool) {
        let tag = 808404
        let text = self.currentTitle ?? ""
        if show {
            self.setTitle("", for: .normal)
            self.isEnabled = false
//            self.alpha = 0
            let indicator = UIActivityIndicatorView()
            let buttonHeight = self.bounds.size.height
            let buttonWidth = self.bounds.size.width
            indicator.center = CGPoint(x: buttonWidth/2, y: buttonHeight/2)
            indicator.tag = tag
            indicator.backgroundColor = .black
            indicator.hidesWhenStopped = true
            indicator.color = self.titleColor(for: .normal)
//            indicator.color = .white
            self.addSubview(indicator)
            self.isUserInteractionEnabled = false
            indicator.startAnimating()
        } else {
            self.setTitle(text, for: .normal)
            self.isEnabled = true
            self.isUserInteractionEnabled = true
//            self.alpha = 1.0
            if let indicator = self.viewWithTag(tag) as? UIActivityIndicatorView {
                indicator.stopAnimating()
                indicator.removeFromSuperview()
            }
        }
    }
}




extension UIViewController{
    
    // MARK: - MAIN STORYBOARD CONTROLLERS
    
   
    
    func moveToHome() {
        
        if let viewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "HomeViewController") as? HomeViewController {
            if let navigator = navigationController {
                navigator.pushViewController(viewController, animated: true)
            }
        }
        
    }
    
    func moveToTrackerList() {
        
        if let viewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "TrackersListViewController") as? TrackersListViewController {
            if let navigator = navigationController {
                navigator.pushViewController(viewController, animated: true)
            }
        }
        
    }
    
    func moveToTrackerList(deviceModel : DevicesModel, isGasSaved : Bool) {
        
        if let viewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "TrackersListViewController") as? TrackersListViewController {
            if let navigator = navigationController {
                viewController.deviceList = deviceModel
                viewController.isGasSaved = isGasSaved
                navigator.pushViewController(viewController, animated: true)
            }
        }
        
    }
    
    func moveToAddGas() {
        
        if let viewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "AddGasViewController") as? AddGasViewController {
            if let navigator = navigationController {
                navigator.pushViewController(viewController, animated: true)
            }
        }
        
    }
    
    // MARK: - DATE - STRING
    func stringFromDate(date : Date, format : String) -> String {
        let dateformatter = DateFormatter()
        dateformatter.dateFormat = format
        let now = dateformatter.string(from: date)
        return now
    }
    
    func dateFromString(string : String, format : String) -> Date{
        let dateformatter = DateFormatter()
        dateformatter.dateFormat = format
        let now = dateformatter.date(from: string) ?? Date()
        return now
    }
}
// MARK: - TEXTFIELD PADDING
extension UITextField {
    @IBInspectable var padding_left: CGFloat {
        get {
            
            return 0
        }
        set (f) {
            layer.sublayerTransform = CATransform3DMakeTranslation(f, 0, 0)
        }
    }
}
