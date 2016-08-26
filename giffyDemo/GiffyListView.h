//
//  GiffyListView.h
//  giffyDemo
//
//  Created by Pei Wu on 8/25/16.
//  Copyright © 2016 Pei Wu. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface GiffyListView : UICollectionView

- (void)refreshDataWithKeyWord:(NSString *)keyword;

@end
