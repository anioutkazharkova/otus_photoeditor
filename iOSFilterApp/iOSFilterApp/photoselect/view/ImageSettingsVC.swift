//
//  ImageSettingsVC.swift
//  HSLImageProcessing
//
//  Created by 1 on 03.04.2019.
//  Copyright © 2019 azharkova. All rights reserved.
//

import UIKit

class ImageSettingsVC: BaseVC {
    
    var showPrevImageButton: ActionImageButton?
    
    var defaultImage: UIImage?
    var processedImage: UIImage?
    let queue = DispatchQueue(label: "image_queue", qos: .userInteractive)
    var imageItem: DispatchWorkItem?
    
    @IBOutlet weak var previewList: UICollectionView!
    private var previewAdapter: ImageHorizontallAdapter = ImageHorizontallAdapter()
    
    @IBOutlet weak var imageView: ImageScrollView?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        previewList?.register(UINib.init(nibName: ImagePickerCell.cellIdentifier, bundle: nil), forCellWithReuseIdentifier: ImagePickerCell.cellIdentifier)

        previewList.dataSource = previewAdapter
        ImagePhotoManager.shared.loadImageForCurrentAsset { [weak self] image in
            self?.setupImage(image: image)
        }
    }
    
    func setupImage(image: UIImage) {
        self.defaultImage = image.copy() as? UIImage
        self.processedImage=image.copy() as? UIImage
        setupFilters()
    }
    
    func setupFilters() {
        imageView?.setup()
        
        imageView?.imageContentMode = .aspectFit
        imageView?.initialOffset = .center
        imageView?.display(image: defaultImage!)
        FilterManager.shared.currentImage = defaultImage!
        getImages()
        //imageHelper?.setupFilter(image: defaultImage!)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        setupMenu()
        imageView?.imageScrollViewDelegate = self
    }
    
    func setupMenu() {
        if (showPrevImageButton == nil) {
            showPrevImageButton = ActionImageButton(frame: CGRect(origin: CGPoint(x: 0, y: 0), size: CGSize(width: 30, height: 30)))
            showPrevImageButton?.setBackgroundImage(UIImage(named: "prev_image"), for: .normal)
            showPrevImageButton?.listener = self
        }
        
        let prevImage = UIBarButtonItem(customView: showPrevImageButton!)
        
        self.navigationItem.leftBarButtonItem = prevImage
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        imageView?.imageScrollViewDelegate = nil
        self.clean()
        super.viewWillDisappear(animated)
    }
    
    @IBAction func intencityChanged(_ sender: Any) {
        let sense = ((sender as? UISlider)?.value ?? 15.0)/100.0
        getImages(intensity: Int(sense))
    }
    
    
    @IBAction func closeClicked(_ sender: Any) {
        self.clean()
        self.navigationController?.popViewController(animated: false)
    }
    
    @IBAction func okClicked(_ sender: Any) {
        self.saveImage()
    }
    
    @MainActor
    func getImages(intensity: Int = 0) {
        Task {
            let images = await FilterManager.shared.prepareImages()
            previewAdapter.setupItems(items: images)
            self.previewList.reloadData()
        }
    }
    
    func processImage() {
        if (imageItem != nil) {
            imageItem?.cancel()
        }
        
       /* imageItem = DispatchWorkItem { [weak self]  in
            if let output = self?.imageHelper?.apply() {
                DispatchQueue.main.async {
                    self?.processedImage = output
                    self?.imageView?.display(image: output)
                }
            }
        }
        if let item = imageItem {
            queue.async(execute: item)
            item.notify(queue: DispatchQueue.main) { [weak self] in
                self?.imageItem = nil
            }
        }*/
    }
    
    func showDefaultImage() {
        if let image = self.defaultImage {
            self.imageView?.display(image: image)
        }
    }
    
    func showProcessedImage() {
        if let image = self.processedImage {
            self.imageView?.display(image: image)
        }
    }
    
    func saveImage() {
        if let image = self.processedImage {
            ImagePhotoManager.shared.saveImage(image: image, successful: {
                [weak self] in
                DispatchQueue.main.async {
                    self?.navigationController?.popViewController(animated: false)
                }
            }) {}
        }
    }
    
    func clean() {
        self.defaultImage = nil
        self.processedImage = nil
        if (imageItem != nil) {
            imageItem?.cancel()
            imageItem = nil
        }
    }
}

extension ImageSettingsVC: LongPressListener {
    func longPressStarted() {
        showDefaultImage()
    }
    
    func longPressEnded() {
        showProcessedImage()
    }
}

extension ImageSettingsVC: ImageScrollViewDelegate {
    func imageScrollViewDidChangeOrientation(imageScrollView: ImageScrollView) {}
}
