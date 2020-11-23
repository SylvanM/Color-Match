//
//  LibraryCollectionViewController.swift
//  Color Match
//
//  Created by Sylvan Martin on 11/5/20.
//

import UIKit

private let reuseIdentifier = "library_item"

class LibraryCollectionViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {
    
    // MARK: Properties
    
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var segmentedView: UISegmentedControl!
    
    var library: ColorLibraryObject.LibraryType {
        ColorLibraryObject.getColors()
    }
    
    var selectedColorArray: [(String, ColorLibraryObject.SavedColor)]!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false
        
        self.collectionView.delegate = self
        self.collectionView.dataSource = self

        // Register cell classes
        self.collectionView.register(UICollectionViewCell.self, forCellWithReuseIdentifier: reuseIdentifier)
        
        // by default, select the type of paint selected in settings
        self.segmentedView.selectedSegmentIndex = [Settings.PaintType.acrlyic, Settings.PaintType.watercolor].firstIndex(of: Settings.paintType)!
        
        findAndSortColors()
        // Do any additional setup after loading the view.
    }
    
    // MARK: Misc Methods
    
    func findAndSortColors() {
        let selectedLibrary = self.segmentedView.selectedSegmentIndex == 0 ? library.acrylic : library.watercolor
        selectedColorArray = Array(selectedLibrary)
        
        selectedColorArray.sort { (firstColor, secondColor) -> Bool in
            return firstColor.0 > secondColor.0
        }
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using [segue destinationViewController].
        // Pass the selected object to the new view controller.
    }
    */
    
    // MARK: Interface Actions
    
    @IBAction func userDidChangeSelectedPaintType(_ sender: Any) {
        findAndSortColors()
        self.collectionView.reloadData()
    }
    

    // MARK: UICollectionViewDataSource

    func numberOfSections(in collectionView: UICollectionView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }


    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of items
        
        return selectedColorArray.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! LibraryItemViewCell
        
        let colorItem = selectedColorArray[indexPath.row]
        
        let rgb = [CGFloat(colorItem.1.rgb.red), CGFloat(colorItem.1.rgb.green), CGFloat(colorItem.1.rgb.blue)]
        
        cell.colorImageView.backgroundColor = UIColor(red: rgb[0], green: rgb[1], blue: rgb[2], alpha: 1)
        cell.colorNameLabel.text = colorItem.0
    
        return cell
    }

    // MARK: UICollectionViewDelegate

    /*
    // Uncomment this method to specify if the specified item should be highlighted during tracking
    override func collectionView(_ collectionView: UICollectionView, shouldHighlightItemAt indexPath: IndexPath) -> Bool {
        return true
    }
    */

    /*
    // Uncomment this method to specify if the specified item should be selected
    override func collectionView(_ collectionView: UICollectionView, shouldSelectItemAt indexPath: IndexPath) -> Bool {
        return true
    }
    */

    /*
    // Uncomment these methods to specify if an action menu should be displayed for the specified item, and react to actions performed on the item
    override func collectionView(_ collectionView: UICollectionView, shouldShowMenuForItemAt indexPath: IndexPath) -> Bool {
        return false
    }

    override func collectionView(_ collectionView: UICollectionView, canPerformAction action: Selector, forItemAt indexPath: IndexPath, withSender sender: Any?) -> Bool {
        return false
    }

    override func collectionView(_ collectionView: UICollectionView, performAction action: Selector, forItemAt indexPath: IndexPath, withSender sender: Any?) {
    
    }
    */

}
