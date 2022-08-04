//
//  ImagePickerViewController.swift
//  pagetest
//
//  Created by min on 2022/07/29.
//

import Foundation
import BSImagePicker
import Photos

//class ImagePickerViewController : ImagePickerController{
//
//
//    func imagePick() {
//        let imagePicker = ImagePickerController()
//        imagePicker.modalPresentationStyle = .fullScreen
//        imagePicker.settings.selection.max = 5
//        imagePicker.settings.theme.selectionStyle = .numbered
//        imagePicker.settings.fetch.assets.supportedMediaTypes = [.image]
//        imagePicker.settings.theme.selectionFillColor = .white
//        imagePicker.doneButton.tintColor = .white
//        imagePicker.doneButtonTitle = "선택완료"
//        imagePicker.cancelButton.tintColor = .white
//
//        presentImagePicker(imagePicker, select: {
//            (asset) in
//                // 사진 하나 선택할 때마다 실행되는 내용 쓰기
//        }, deselect: {
//            (asset) in
//                // 선택했던 사진들 중 하나를 선택 해제할 때마다 실행되는 내용 쓰기
//        }, cancel: {
//            (assets) in
//                // Cancel 버튼 누르면 실행되는 내용
//        }, finish: {
//            (assets) in
//                // Done 버튼 누르면 실행되는 내용
//
//                self.selectedAssets.removeAll()
//
//                for i in assets {
//                    self.selectedAssets.append(i)
//                }
//
//                self.convertAssetToImage()
//                self.collectionView.reloadData()
//        })
//
//    }
//
//
//    // PHAsset Type 이었던 사진을 UIImage Type 으로 변환하는 함수
//    func convertAssetToImage() {
//        if selectedAssets.count != 0 {
//                for i in 0 ..< selectedAssets.count {
//                    let imageManager = PHImageManager.default()
//                        let option = PHImageRequestOptions()
//                        option.isSynchronous = true
//                        var thumbnail = UIImage()
//                        imageManager.requestImage(for: selectedAssets[i], targetSize: CGSize(width: selectedAssets[i].pixelWidth, height: selectedAssets[i].pixelHeight), contentMode: .aspectFill, options: option) {
//                                (result, info) in
//                                thumbnail = result!
//                    }
//
//                        let data = thumbnail.jpegData(compressionQuality: 0.7)
//                        let newImage = UIImage(data: data!)
//                        self.selectedImages.append(newImage! as UIImage)
//                    }
//            }
//    }
//
//}


