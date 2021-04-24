//
//  MainController.swift
//  FacebookApp
//
//  Created by Admin on 2021-04-23.
//

import UIKit
import SwiftUI
import LBTATools

class PostCell: LBTAListCell<String> {
    let imageView = UIImageView(backgroundColor: .red)
    let nameLabel = UILabel(text:"Name label")
    let dateLabel = UILabel(text:"Friday at 11:00pm")
    let postTextLabel = UILabel(text:"Here is my first post")
    let imageViewGrid = PhotosGridController()
    override func setupViews() {
        stack(
            hstack(
                imageView.withHeight(40).withWidth(40),
                stack(
                    nameLabel,
                    dateLabel
                ),
                spacing:8
            ).padLeft(10).padTop(10).padRight(10),
            postTextLabel,
            imageViewGrid.view,
            spacing:10
        )
        backgroundColor = .white
    }
}

class StoryHeader: UICollectionReusableView {
    
    let storiesController = StoriesController(scrollDirection: .horizontal)
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .yellow
        stack(storiesController.view)
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
}

class StoriesController: LBTAListController<StoryPhotoCell,String>,UICollectionViewDelegateFlowLayout {
    override func viewDidLoad() {
        super.viewDidLoad()
        self.items = ["avatar1","avatar1","avatar1","avatar1"]
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return .init(width: 100, height: view.frame.height - 24)
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return .init(top: 0, left: 12, bottom: 0, right: 12)
    }
}

class StoryPhotoCell: LBTAListCell<String> {
    override var item: String! {
        didSet {
            imageView.image = UIImage(named: item)
        }
    }
    
    let imageView = UIImageView(image: nil, contentMode: .scaleAspectFill)
    let nameLabel = UILabel(text: "Lee Ji Eun", font: .boldSystemFont(ofSize: 14), textColor: .white)
    override func setupViews() {
        imageView.layer.cornerRadius = 10
        
        stack(imageView)
        
        setupGradientLayer()
        
        stack(UIView(), nameLabel).withMargins(.allSides(8))
    }
    let gradientLayer = CAGradientLayer()
    
    fileprivate func setupGradientLayer() {
        gradientLayer.colors = [UIColor.clear.cgColor, UIColor.black.cgColor]
        gradientLayer.locations = [0.7, 1.1]
        layer.cornerRadius = 10
        clipsToBounds = true
        layer.addSublayer(gradientLayer)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        gradientLayer.frame = bounds
    }
}

class MainController: LBTAListHeaderController <PostCell,String,StoryHeader> ,UICollectionViewDelegateFlowLayout{
    
    let fbLogoImageView = UIImageView(image: UIImage(named: "fb_logo"), contentMode: .scaleAspectFit)
    
    let searchButton = UIButton(title: "Search", titleColor: .black)
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return .init(width: 0, height: 200)
    }
    override func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let safeAreaTop = UIApplication.shared.windows.filter {$0.isKeyWindow}.first?.safeAreaInsets.top ?? 0
        let magicalSafeareaTop:CGFloat = safeAreaTop + (navigationController?.navigationBar.frame.height ?? 0)
        let offset = min(0,-(magicalSafeareaTop + scrollView.contentOffset.y))
        
        let alphaVal: CGFloat = 1 - ((scrollView.contentOffset.y + magicalSafeareaTop) / magicalSafeareaTop)

        [fbLogoImageView,searchButton].forEach{$0.alpha = alphaVal}
        navigationController?.navigationBar.transform = .init(translationX:0,y:offset)
    }
    fileprivate func setupNavBar() {
                
        let width = view.frame.width - 120 - 16 - 60
        let titleView = UIView(backgroundColor: .white)
        titleView.frame = .init(x: 0, y: 0, width: width, height: 50)

        titleView.hstack(
            fbLogoImageView.withWidth(120),
            UIView(backgroundColor: .clear).withWidth(width),
            searchButton.withWidth(60)
        )
        navigationItem.titleView = titleView
        
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        collectionView.backgroundColor = .init(white:0.9,alpha:1)
        self.items = ["hello", "WORLD", "1", "3"]
        setupNavBar()

    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return .init(width: view.frame.width, height: 400   )
    }
}



struct MainPreview:PreviewProvider {
    static var previews: some View {
        ContainerView().edgesIgnoringSafeArea(/*@START_MENU_TOKEN@*/.all/*@END_MENU_TOKEN@*/)
    }
    
    struct ContainerView: UIViewControllerRepresentable {
        
        func makeUIViewController(context: UIViewControllerRepresentableContext<MainPreview.ContainerView>) -> some UIViewController {
            return UINavigationController(rootViewController: MainController())
        }
        
        func updateUIViewController(_ uiViewController: MainPreview.ContainerView.UIViewControllerType, context: UIViewControllerRepresentableContext<MainPreview.ContainerView>) {
            
        }
    }
}
