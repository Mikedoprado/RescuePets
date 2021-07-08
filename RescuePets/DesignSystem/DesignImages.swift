//
//  DesignImages.swift
//  RescuePets
//
//  Created by Michael do Prado on 6/16/21.
//

import SwiftUI

enum DesignImage {
    
    case close
    case closeBlack
    case closeWhite
    case accept
    case message
    case location
    case send
    case trash
    case camera
    case cameraShot
    case notification
    case profileImageBlack
    case profileImageBlue
    case profileImageRed
    case profileImageYellow
    case pinDogActive
    case pinDogInactive
    case pinCatActive
    case pinCatInactive
    case pinBirdActive
    case pinBirdInactive
    case pinOtherActive
    case pinOtherInactive
    case pinLocationWhite
    case alertAcept
    case alertAdd
    case dropDown
    case dropDownRed
    case dropDownWhite
    case logo
    
    var image: Image {
        switch self {
        case .close:
            return Image(uiImage: UIImage(named: "btnClose")!)
        case .accept:
            return Image(uiImage: UIImage(named: "acceptAlert")!)
        case .message:
            return Image(uiImage: UIImage(named: "sendMessage")!)
        case .location:
            return Image(uiImage: UIImage(named: "pinLocation")!)
        case .send:
            return Image(uiImage: UIImage(named: "sendComment")!)
        case .trash:
            return Image(uiImage: UIImage(named: "trash")!)
        case .camera:
            return Image(uiImage: UIImage(named: "camera")!)
        case .notification:
            return Image(uiImage: UIImage(named: "notificationWhite")!)
        case .cameraShot:
            return Image(uiImage: UIImage(named: "cameraShot")!)
        case .profileImageBlack:
            return Image(uiImage: UIImage(named: "profileImageBlack")!)
        case .profileImageBlue:
            return Image(uiImage: UIImage(named: "profileImageBlue")!)
        case .profileImageRed:
            return Image(uiImage: UIImage(named: "profileImageRed")!)
        case .profileImageYellow:
            return Image(uiImage: UIImage(named: "profileImageYellow")!)
        case .closeBlack:
            return Image(uiImage: UIImage(named: "btnCloseBlack")!)
        case .pinDogActive:
            return Image(uiImage: UIImage(named: "pinDogActive")!)
        case .pinDogInactive:
            return Image(uiImage: UIImage(named: "pinDogInactive")!)
        case .pinCatActive:
            return Image(uiImage: UIImage(named: "pinCatActive")!)
        case .pinCatInactive:
            return Image(uiImage: UIImage(named: "pinCatInactive")!)
        case .pinBirdActive:
            return Image(uiImage: UIImage(named: "pinBirdActive")!)
        case .pinBirdInactive:
            return Image(uiImage: UIImage(named: "pinBirdInactive")!)
        case .closeWhite:
            return Image(uiImage: UIImage(named: "btnCloseWhite")!)
        case .pinLocationWhite:
            return Image(uiImage: UIImage(named: "pinLocationWhite")!)
        case .pinOtherActive:
            return Image(uiImage: UIImage(named: "pinDogActive")!)
        case .pinOtherInactive:
            return Image(uiImage: UIImage(named: "pinDogInactive")!)
        case .alertAcept:
            return Image(uiImage: UIImage(named: "alertAcept")!)
        case .alertAdd:
            return Image(uiImage: UIImage(named: "alertAdd")!)
        case .dropDown:
            return Image(uiImage: UIImage(named: "dropDown")!)
        case .logo:
            return Image(uiImage: UIImage(named: "logo")!)
        case .dropDownRed:
            return Image(uiImage: UIImage(named: "dropDownRed")!)
        case .dropDownWhite:
            return Image(uiImage: UIImage(named: "dropDownWhite")!)
        }
    }
}

enum TabBarIcon {
    case messages(isActive: Bool?), profile(isActive: Bool?), notification(isActive: Bool?), camera(isActive: Bool?)
    
    var icon : Image {
        switch self {
        case .messages(isActive: let isActive):
            return (isActive != nil) ? Image(uiImage: UIImage(named: "iconMessage:Active")!) : Image(uiImage: UIImage(named: "iconMessage:Inactive")!)
        case .profile(isActive: let isActive):
            return (isActive != nil) ? Image(uiImage: UIImage(named: "iconProfile:Active")!) : Image(uiImage: UIImage(named: "iconProfile:Inactive")!)
        case .notification(isActive: let isActive):
            return (isActive != nil) ? Image(uiImage: UIImage(named: "iconNotify:Active")!) : Image(uiImage: UIImage(named: "iconNotify:Inactive")!)
        case .camera(isActive: let isActive):
            return (isActive != nil) ? Image(uiImage: UIImage(named: "iconCamera:Active")!) : Image(uiImage: UIImage(named: "iconCamera:Inactive")!)
        }
    }
}
