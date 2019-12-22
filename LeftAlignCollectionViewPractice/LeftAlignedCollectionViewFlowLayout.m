//
//  LeftAlignedCollectionViewFlowLayout.m
//  LeftAlignCollectionViewPractice
//
//  Created by pinyuan on 2019/12/22.
//  Copyright © 2019 Apple. All rights reserved.
//

#import "LeftAlignedCollectionViewFlowLayout.h"

@implementation LeftAlignedCollectionViewFlowLayout

- (NSArray *)layoutAttributesForElementsInRect:(CGRect)rect {
    NSArray *attributes = [super layoutAttributesForElementsInRect:rect];
    
    CGFloat leftMargin = self.sectionInset.left;
    CGFloat maxY = -1.0f;
    
    for (UICollectionViewLayoutAttributes *attribute in attributes) {
        if (attribute.frame.origin.y >= maxY) {
            leftMargin = self.sectionInset.left;
        }
        attribute.frame = CGRectMake(leftMargin, attribute.frame.origin.y, attribute.frame.size.width, attribute.frame.size.height);
        leftMargin += attribute.frame.size.width + self.minimumInteritemSpacing;
        maxY = MAX(CGRectGetMaxY(attribute.frame), maxY);
    }
    
    return attributes;
}
@end
