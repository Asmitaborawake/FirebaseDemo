//
//  ViewController.swift
//  FirebaseDemo
//
//  Created by Asmita Borawake on 24/12/21.
//

import UIKit
import Firebase
import FirebaseStorage

class ViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var myImagegView: UIImageView!
    @IBOutlet weak var textField: UITextField!
    var ref = DatabaseReference.init()
    var imagePicker = UIImagePickerController()
    var arrData = [ChatModle]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.ref = Database.database().reference()
        
        let tapGesture = UITapGestureRecognizer()
        tapGesture.addTarget(self, action: #selector(ViewController.openGalary(tapGesture:)))
        myImagegView.isUserInteractionEnabled = true
        myImagegView.addGestureRecognizer(tapGesture)
        
        self.getFirebaseData()
        
    }
    
    @objc func openGalary(tapGesture : UITapGestureRecognizer){
        print("hi")
        self.setImagePicker()
    }
    
    
    @IBAction func saveBtnClick(_ sender: Any) {
        self.saveFirebaseData()
        self.getFirebaseData()
    }
    
    func saveFirebaseData(){
        self.uploadImage(self.myImagegView.image!){url in
            self.saveImage(name: self.textField.text!, profileUrl: url!){ success in
                if success != nil{
                    print("got it")
                }
            }
        }
    }
}


extension ViewController : UIImagePickerControllerDelegate,UINavigationControllerDelegate{
    func setImagePicker(){
        if UIImagePickerController.isSourceTypeAvailable(.savedPhotosAlbum){
            imagePicker.sourceType = .savedPhotosAlbum
            imagePicker.delegate = self
            imagePicker.isEditing = true
            
            self.present(imagePicker, animated: true, completion: nil)
        }
}
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        let image = info[UIImagePickerController.InfoKey.originalImage] as! UIImage
        myImagegView.image = image
        self.dismiss(animated: true, completion: nil)
    }
    
}
extension ViewController {
    
    func uploadImage(_ image: UIImage, completion : @escaping ((_ url: URL?) -> ())){
        let storageRef = Storage.storage().reference().child("myImage.png")
        let imageData = myImagegView.image?.pngData()
        let metaData = StorageMetadata()
        metaData.contentType = "image/png"
        
        storageRef.putData(imageData!, metadata: metaData) { (metaData, error) in
            if error == nil {
                print("success")
                storageRef.downloadURL (completion: { (url, error) in
                    completion(url)
                })
            }else{
                print("error in save image")
                print(error?.localizedDescription)
                completion(nil)
            }
        }
}
    
 
    
    func saveImage(name : String, profileUrl : URL, completion : @escaping ((_ url: URL?) -> ())){
        
        let dict = ["name" : "Asmita" , "text" : textField.text!, "profileUrl" : profileUrl.absoluteString] as [String: Any]
        self.ref.child("chat").childByAutoId().setValue(dict)
        
    }
    
    
    func getFirebaseData(){
        self.ref.child("chat").queryOrderedByKey().observe(.value) { (snapshot) in
            self.arrData.removeAll()
            if let snapShot = snapshot.children.allObjects as? [DataSnapshot]{
                for snap in snapShot{
                    if let mainDict = snap.value as? [String:AnyObject]{
                        let name  = mainDict["name"] as? String
                        let text = mainDict["text"] as? String
                        let profileimgurl =  mainDict["profileUrl"] as? String ?? ""
                        self.arrData.append(ChatModle(name: name!, text: text!, profileImgUrl: profileimgurl))
                        self.tableView.reloadData()
                    }
                }
            }
        }
    }
}
extension ViewController : UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! TableViewCell
        cell.chatModel = arrData[indexPath.row]
        return cell
    }
}
