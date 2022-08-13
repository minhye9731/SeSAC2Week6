//
//  CameraViewController.swift
//  SeSAC2Week6
//
//  Created by 강민혜 on 8/12/22.
//

import UIKit

import Alamofire
import SwiftyJSON
import YPImagePicker

class CameraViewController: UIViewController {

    @IBOutlet weak var resultImageView: UIImageView!
    @IBOutlet weak var cameraButton: UIButton!
    
    //UIImagePickerController 1.
    let picker = UIImagePickerController()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //UIImagePickerController 2.
        picker.delegate = self
        
        cameraButton.configuration = .cameraStyle()
        cameraButton.configurationUpdateHandler = {
            button in
            if button.isHighlighted {
                button.backgroundColor = .systemGray
            }
        }

    }
    
//    func configureCameraButton() {
//        var config = UIButton.Configuration.filled()
//        config.baseBackgroundColor = .darkGray
//        config.title = "카메라"
//        config.subtitle = "여기보세요~ 하나 둘 셋!"
//        config.image = UIImage(systemName: "star.fill")
//
//        cameraButton.configuration = config
//
//        cameraButton.configurationUpdateHandler = { button in
//            if button.isHighlighted {
//                button.backgroundColor = .black
//            }
//        }
//    }
    
    
    
    
    
    //OpenSource
    //권한은 다 허용 해주세요
    //권한 문구 등도 내부적으로 구현! 실제로 카메라를 쓸 떄 권한을 요청
    @IBAction func ypImagePickerButtonClicked(_ sender: UIButton) {
        
        let picker = YPImagePicker()
        picker.didFinishPicking { [unowned picker] items, _ in
            if let photo = items.singlePhoto {
                print(photo.fromCamera) // Image source (camera or library)
                print(photo.image) // Final image selected by the user
                print(photo.originalImage) // original image selected by the user, unfiltered
                print(photo.modifiedImage) // Transformed image, can be nil
                print(photo.exifMeta) // Print exif meta data of original image.
                
                self.resultImageView.image = photo.image
                
            }
            picker.dismiss(animated: true, completion: nil)
        }
        present(picker, animated: true, completion: nil)
        
    }
    
    //UIImagePickerController
    @IBAction func cameraButtonClicked(_ sender: UIButton) {
        
        guard UIImagePickerController.isSourceTypeAvailable(.camera) else {
            print("사용불가 + 사용자에게 토스트/얼럿")
            return
        }
        
        picker.sourceType = .camera
        picker.allowsEditing = true // 촬영후에 편집화면으로 넘어감(retake/use photo)
        
        present(picker, animated: true)
    
    }
    
    //UIImagePickerController
    @IBAction func photoLibraryButtonClicked(_ sender: UIButton) {
        
        guard UIImagePickerController.isSourceTypeAvailable(.camera) else {
            print("사용불가 + 사용자에게 토스트/얼럿")
            return
        }
        
        picker.sourceType = .photoLibrary
        picker.allowsEditing = true // 촬영후에 편집화면으로 넘어감(retake/use photo)
        
        present(picker, animated: true)
        
    }
    
    
    @IBAction func saveToPhotoLibrary(_ sender: UIButton) {
        
        if let image = resultImageView.image {
            UIImageWriteToSavedPhotosAlbum(image, nil, nil, nil)
        }
    }
    
    
    // 이미지뷰 이미지 > 네이버 > 얼굴 분석 해줘 요청 > 응답!
    // 문자열이 아닌 파일, 이미지, PDF 파일 자체가 그대로 전송 되지 않음. => 텍스트 형태로 인코딩
    // 어떤 파일의 종류가 서버에게 전달되는지 명시 = Content-Type
    @IBAction func clovaFaceButtonClicked(_ sender: UIButton) {
        
        let url = "https://openapi.naver.com/v1/vision/celebrity"
        let header: HTTPHeaders = [
            "X-Naver-Client-Id": "K4eAuQDJ6dFKNjh5QokT",
            "X-Naver-Client-Secret": "FW_zbLuYax",
            "Content-Type" : "multipart/form-data" // 왜 안해도 될까요? 라이브러리에 내장되어 있음
        ]

        //UIImage를 텍스트 형태(바이너리 타입)로 변환해서 전달 (즉, 용량을 줄여서 보냄)
        guard let imageData = resultImageView.image?.jpegData(compressionQuality: 0.5) else {
            print("이미지가 큼. 프린트 됨")
            return }

        AF.upload(multipartFormData: { multipartFormData in
            multipartFormData.append(imageData, withName: "image")
        }, to: url, headers: header)
        .validate(statusCode: 200...500).responseData { response in
            switch response.result {
            case .success(let value):

                let json = JSON(value)
                print(json)

            case .failure(let error):
                print(error)
            }
        }
        
    }
    
    
}

//UIImagePickerController 3.
//네비게이션 컨트롤러를 상속받고 있음.
extension CameraViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    //UIImagePickerController 4. 사진을 선택하거나 카메라 촬영 직후
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        print(#function)
        
        //원본, 편집, 메타 데이터 등 - infoKey
//        if let image = info[UIImagePickerController.InfoKey.editedImage] as? UIImage {
//            self.returnImageView.image = image
//            dismiss(animated: true)
//        }
        
        if let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
            self.resultImageView.image = image
            dismiss(animated: true)
        }
    }
    
    //UIImagePickerController 5. 취소 버튼 클릭 시
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        print(#function)
    }
    
}
