//
//  TagCollectionViewCell.h
//  LeftAlignCollectionViewPractice
//
//  Created by pinyuan on 2019/12/22.
//  Copyright © 2019 Apple. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface TagCollectionViewCell : UICollectionViewCell
@property (weak, nonatomic) IBOutlet UIView *tagBackgroundView;
@property (weak, nonatomic) IBOutlet UILabel *tagLabelTitle;
@property (weak, nonatomic) IBOutlet UIButton *tagDeleteButton;
@end
