//
//  PhotoCollectionViewLayout.swift
//  knpa2019f
//
//  Created by JinGu's iMac on 20/08/2019.
//  Copyright © 2019 JinGu's iMac. All rights reserved.
//

import UIKit


let numberOfitem = 52

class PhotoCollectionViewLayout: UICollectionViewLayout {

    /*================================
     레이아웃을 미리 계산할 수 있도록 해줌
     레이아웃 정보를 모두 초기화
     ================================*/

    let edgeInset : UIEdgeInsets = {
        if IS_NORCH {
            return UIEdgeInsets(top: 15, left: 15, bottom: 0, right: 15)
        }else{
            return UIEdgeInsets(top: 15, left: 15, bottom: 15, right: 15)
        }
    }()
    let cellGap : CGFloat = 10
    
    
    lazy var smallSize : CGSize = {
        let sizeWidth : CGFloat = (SCREEN.WIDTH - (edgeInset.left + edgeInset.right) - (3 * cellGap)) / 4
        let sizeHeight : CGFloat = sizeWidth
       return CGSize(width: sizeWidth, height: sizeHeight)
    }()
    
    lazy var largeSize : CGSize = {
        
        let sizeWidth : CGFloat = SCREEN.WIDTH - (edgeInset.left + edgeInset.right) - (smallSize.width * 2) - (cellGap * 2)
        let sizeHeight : CGFloat = sizeWidth
        
        return CGSize(width: sizeWidth, height: sizeHeight)
    }()
    

    
    var numberOfitem = 0
    
    var layoutDic = [IndexPath : UICollectionViewLayoutAttributes]()
    override func prepare() {
        super.prepare()
        
        layoutDic.removeAll()
        
        var groupOriginX : CGFloat = 0
        var groupOriginY : CGFloat = edgeInset.top

        var smallCount = 0
            for i in 0..<numberOfitem {
                
                let kIndexPath = IndexPath(row: i, section: 0)
                let kAtt = CollectionViewLayoutAttributes(forCellWith: kIndexPath)
                
                var itemSize : CGSize = CGSize.zero
                var itemOriginX : CGFloat = 0
                var itemOriginY : CGFloat = edgeInset.top
                
                if i % 10 == 1 {    //작은거 - 오른쪽 4개
//                    groupOriginX = SCREEN.WIDTH / 2
                    groupOriginX = edgeInset.left + largeSize.width + cellGap
                }
                else if i % 10 == 5 {  //작은거 - 왼쪽 4개
//                    groupOriginX = 0
                    groupOriginX = edgeInset.left
                }
                
                if i % 10 == 0 || i % 10 == 9 { //큰거
                    kAtt.isLarge = true
                    itemSize = largeSize
                    smallCount = 0
                    if i % 10 == 0 {    //왼쪽 큰거
//                        itemOriginX = 0
                        itemOriginX = edgeInset.left
                    }else{              //오른쪽 큰거
//                        itemOriginX = SCREEN.WIDTH / 2
                        itemOriginX = edgeInset.left + largeSize.width + cellGap
                    }
                    if i != 0 {
//                        groupOriginY += SCREEN.WIDTH / 2
                        groupOriginY += largeSize.width + cellGap
                        itemOriginY = groupOriginY
                    }
                }else{                          //작은거
                    itemSize = smallSize

                    itemOriginX = groupOriginX + ((smallSize.width + cellGap) * CGFloat(smallCount % 2))
                    itemOriginY = groupOriginY + ((smallSize.height + cellGap) * CGFloat(smallCount / 2))
                    smallCount += 1
                }
                

                kAtt.frame = CGRect(origin: CGPoint(x: itemOriginX, y: itemOriginY), size: itemSize)
                
                layoutDic[kIndexPath] = kAtt
                
            }
        
    }
    
    override var collectionViewContentSize: CGSize {
        let numberOfGroup = numberOfitem / 5
        let other = numberOfitem % 5
        let groupCount = (other == 0) ? numberOfGroup : (numberOfGroup + 1)
        let height = edgeInset.top + (CGFloat(groupCount) * (largeSize.height + cellGap)) + edgeInset.bottom
        return CGSize(width: SCREEN.WIDTH, height: height )
    }
    
   
    
    /*================================
     현재 보이는 화면 (=rect)에 해당하는 레이아웃을 반환해줘야함
     rect에 속하는지 확인(=intersects Function)하고 배열을 반환
     ================================*/
    override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {

        var layoutAttributesArray = [UICollectionViewLayoutAttributes]()
        
        for (_, layoutAttributes) in layoutDic {
            if rect.intersects(layoutAttributes.frame) {
                layoutAttributesArray.append(layoutAttributes)
            }
        }
        
        return layoutAttributesArray
        
    }
    
    /*================================
     레이아웃 정보를 반환하는 부분
     ================================*/
    override func layoutAttributesForItem(at indexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
        return layoutDic[indexPath]
    }
    
    
}


class CollectionViewLayoutAttributes : UICollectionViewLayoutAttributes {
    var isLarge = false
}
