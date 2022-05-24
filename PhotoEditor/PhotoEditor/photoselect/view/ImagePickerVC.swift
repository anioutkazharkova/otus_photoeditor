//
//  ImagePickerVC.swift
//  PhotoEditor
//
//  Created by Anna Zharkova on 19.05.2022.
//

import UIKit

class ImagePickerVC: UIViewController {

    @IBOutlet weak var imageList: UICollectionView!
    private lazy var adapter: PhotoImageAdapter = {
       return PhotoImageAdapter()
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let side = (UIScreen.main.bounds.size.width - 40)/3
        self.adapter.side = side
        self.adapter.listOwner = self
        imageList.register(UINib(nibName: ImageCell.cellId, bundle: nil), forCellWithReuseIdentifier: ImageCell.cellId)
        self.imageList.dataSource = adapter
        self.imageList.delegate = adapter
        self.adapter.photoHolder = PhotoImageHelper.shared
        PhotoImageHelper.shared.loadAssets {
            [weak self] result in
                guard let self = self else {return}
            DispatchQueue.main.async {
                self.imageList.reloadData()
            }
        } failure: {
            
        }

        // Do any additional setup after loading the view.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}

extension ImagePickerVC : ListOwner {
    func selectImage(index: Int) {
        PhotoImageHelper.shared.selectAsset(index: index)
        self.navigationController?.pushViewController(ImageSettingsVC(), animated: true)
    }
}
