import Flutter
import UIKit
import AVFoundation
import MobileCoreServices

@UIApplicationMain
@objc class AppDelegate: FlutterAppDelegate {
  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
    GeneratedPluginRegistrant.register(with: self)
    registerPluginss(register: self.registrar(forPlugin: "FlutterAppDelegate")!)
    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }
  
  private func registerPluginss(register: FlutterPluginRegistrar){
    let pluginRegister = register
    BatteryLevelPlugin.register(with:pluginRegister)
    GalleryPlugin.register(with: pluginRegister)
    GoogleMapPlugin.register(with: pluginRegister)
    CPlusPlusPlugin.register(with: pluginRegister)
    NativeMessagePlugin.register(with: pluginRegister)
    pluginRegister.publish(pluginRegister as! NSObject)
  }
}

public protocol FlutterPluginDelegate : FlutterPlugin {
  func handle(_call:FlutterMethodCall,result: @escaping FlutterResult)
}



public class GoogleMapPlugin : NSObject , FlutterPlugin {
  public static func register(with register: FlutterPluginRegistrar) {
    let channel = FlutterMethodChannel(name:"googleMap_Channel",binaryMessenger: register.messenger())
    let instance = GoogleMapPlugin()
    register.addMethodCallDelegate(instance,channel:channel)
  }
  
public func handle(_ call: FlutterMethodCall , result: @escaping FlutterResult) {
    if call.method == "openGoogleMap" {
      openGoogleMap(with: ["hello":"hy"]) { message in
        if let message = message {
          print("\(message)")
           result(message)
        }else{
          print("Failed To Open")
          result(FlutterMethodNotImplemented)
        }
      }
    }
  }
  
  private func openGoogleMap(with data : [String:String], complition : @escaping (String?) -> Void )  {
    let message : String? = "Google Map open Successfully"
    complition(message)
  }
  
}

public class CPlusPlusPlugin : NSObject , FlutterPlugin {
  public static func register(with register: FlutterPluginRegistrar) {
    let channel = FlutterMethodChannel(name:"CPlusPlus_Channel",binaryMessenger: register.messenger())
    let instance = CPlusPlusPlugin()
    register.addMethodCallDelegate(instance,channel:channel)
  }
  
  public func handle(_ call: FlutterMethodCall , result: @escaping FlutterResult) {
    if call.method == "openCplusplus" {
      openCplusPlus(with: ["hello":"hy"]) { message in
        if let message = message {
          print("\(message)")
          result(message)
        }else{
          print("Failed To Open")
          result(FlutterMethodNotImplemented)
        }
      }
    }
  }
  private func openCplusPlus(with data : [String:String], complition : @escaping (String?) -> Void )  {
    let message : String? = String(cString: test())
    complition(message)
  }
}

public class NativeMessagePlugin : NSObject , FlutterPlugin {
  public static func register(with register: FlutterPluginRegistrar) {
    let channel = FlutterMethodChannel(name:"NativeMessage_Channel",binaryMessenger: register.messenger())
    let instance = NativeMessagePlugin()
    register.addMethodCallDelegate(instance,channel:channel)
  }
  
  public func handle(_ call: FlutterMethodCall , result: @escaping FlutterResult) {
    if call.method == "openNativeMessage" {
      openNativeMessage(with: ["hello":"hy"]) { message in
        if let message = message {
          print("\(message)")
          result(message)
        }else{
          print("Failed To Open")
          result(FlutterMethodNotImplemented)
        }
      }
    }
  }
  private func openNativeMessage(with data : [String:String], complition : @escaping (String?) -> Void )  {
    let message : String? = String("Native swift called successfully")
    complition(message)
  }
}

public class BatteryLevelPlugin: NSObject, FlutterPlugin {
  public static func register(with registrar: FlutterPluginRegistrar) {
    let channel = FlutterMethodChannel(name: "battery_channel", binaryMessenger: registrar.messenger())
    let instance = BatteryLevelPlugin()
    registrar.addMethodCallDelegate(instance, channel: channel)
  }
  
  public func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
    if call.method == "getBatteryLevel" {
      let batteryLevel = getBatteryLevel()
      result(batteryLevel)
    } else {
      result(FlutterMethodNotImplemented)
    }
  }
  
  private func getBatteryLevel() -> Int {
    let device = UIDevice.current
    device.isBatteryMonitoringEnabled = true
    if device.batteryState == .unknown {
      return -1
    } else {
      return Int(device.batteryLevel * 100)
    }
  }
}



public class GalleryPlugin: NSObject, FlutterPlugin, UINavigationControllerDelegate, UIImagePickerControllerDelegate {
  private var resultCallback: FlutterResult?
  
  public static func register(with registrar: FlutterPluginRegistrar) {
    let channel = FlutterMethodChannel(name: "gallery_channel", binaryMessenger: registrar.messenger())
    let instance = GalleryPlugin()
    registrar.addMethodCallDelegate(instance, channel: channel)
  }
  
  public func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
    if call.method == "openGallery" {
      resultCallback = result

      openGallery(sourceType: .photoLibrary)
    } else if call.method == "openCamera" {
      resultCallback = result
      openGallery(sourceType: .camera)
    } else if call.method == "recordVideo" {
      resultCallback = result
      recordVideo()
    } else {
      result(FlutterMethodNotImplemented)
    }
  }
  
  private func openGallery(sourceType: UIImagePickerController.SourceType) {
    if UIImagePickerController.isSourceTypeAvailable(sourceType) {
      if let topViewController = UIApplication.shared.keyWindow?.rootViewController {
        let imagePicker = UIImagePickerController()
        imagePicker.sourceType = sourceType
        imagePicker.delegate = self
        topViewController.present(imagePicker, animated: true, completion: nil)
      }
    } else {
      resultCallback?(FlutterError(code: "UNAVAILABLE", message: "Requested source type is unavailable.", details: nil))
    }
  }
  
  private func recordVideo() {
    if UIImagePickerController.isSourceTypeAvailable(.camera) {
      if let topViewController = UIApplication.shared.keyWindow?.rootViewController {
        let imagePicker = UIImagePickerController()
        imagePicker.sourceType = .camera
        imagePicker.mediaTypes = [kUTTypeMovie as String]
        imagePicker.videoQuality = .typeMedium
        imagePicker.delegate = self
        topViewController.present(imagePicker, animated: true, completion: nil)
      }
    } else {
      resultCallback?(FlutterError(code: "UNAVAILABLE", message: "Camera is unavailable.", details: nil))
    }
  }
  
  public func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
    if let mediaType = info[.mediaType] as? String {
      if mediaType == kUTTypeImage as String, let image = info[.originalImage] as? UIImage {
        let imageData = image.jpegData(compressionQuality: 0.8)
        let base64String = imageData?.base64EncodedString()
        resultCallback?(base64String)
      } else if mediaType == kUTTypeMovie as String, let videoURL = info[.mediaURL] as? URL {
        let videoData = try? Data(contentsOf: videoURL)
        let base64String = videoData?.base64EncodedString()
        resultCallback?(base64String)
      } else {
        resultCallback?(nil)
      }
    } else {
      resultCallback?(nil)
    }
    
    picker.dismiss(animated: true, completion: nil)
  }
  
  public func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
    resultCallback?(nil)
    let vc = ViewController()
    vc.callCPlus()
    picker.dismiss(animated: true, completion: nil)
  }
}

import UIKit

public class ViewController: UIViewController {
  public override func viewDidLoad() {
   super.viewDidLoad()

 }

 public func callCPlus(){
   sayHelloFromCpp()
 }
}
