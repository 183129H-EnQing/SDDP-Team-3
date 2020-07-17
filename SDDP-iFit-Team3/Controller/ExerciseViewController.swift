//
//  ExerciseViewController.swift
//  SDDP-iFit-Team3
//
//  Created by 182452K  on 7/7/20.
//  Copyright © 2020 SDDP_Team3. All rights reserved.
//

import UIKit

class ExerciseViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {

    @IBOutlet weak var collectionView: UICollectionView!
    
    var exercise: [Exercise] = []
//    let exercise = ["Jump", "Crawl", "Jump", "Crawl"]
    let exerciseImage: [UIImage] = [UIImage(named: "pull_string")!, UIImage(named: "step_string")!, UIImage(named: "pull_string")!, UIImage(named: "step_string")!]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        self.navigationItem.title = "Exercise"
        
        loadExercise()
        let layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
        layout.sectionInset = UIEdgeInsets(top: 0, left: 1, bottom: 0, right: 1)
        layout.itemSize = CGSize(width: (self.collectionView.frame.size.width - 4)/2, height: (self.collectionView.frame.size.height - 8)/3)
        layout.minimumInteritemSpacing = 2
        layout.minimumLineSpacing = 2
        collectionView!.collectionViewLayout = layout
    }
    
    func loadExercise(){
        DataManager.ExerciseClass.loadExercises { (data) in
            
            if data.count > 0 {
                self.exercise = data
                
                DispatchQueue.main.async {
                    self.collectionView.reloadData()
                }
            }
        }
    }
            
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.exercise.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ExerciseCell", for: indexPath) as! ExerciseCollectionViewCell
        
        let e = self.exercise[indexPath.row]
        cell.imageView.image = UIImage(named: e.exImage)
        cell.nameLabel.text = e.exName
        
//        cell.imageView.image = exerciseImage[indexPath.row]
//        cell.nameLabel.text = exercise[indexPath.row]
        
        cell.layer.borderColor = UIColor.lightGray.cgColor
        cell.layer.borderWidth = 0.5
        
        return cell
    }
    
    //pass data to detailsController
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        let exerciseDetailVC = storyboard?.instantiateViewController(identifier: "ExerciseDetailVC") as! ExerciseDetailViewController
        exerciseDetailVC.exerciseList = exercise[indexPath.row]
        
        self.navigationController?.pushViewController(exerciseDetailVC, animated: true)
    }
    
    
//    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
//        <#code#>
//    }
//
//    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
//        <#code#>
//    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}

