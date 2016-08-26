//
//  SearchCTABar.h
//  giffyDemo
//
//  Created by Pei Wu on 8/25/16.
//  Copyright © 2016 Pei Wu. All rights reserved.
//

#import <UIKit/UIKit.h>

@class SearchCTABar;
@protocol SearchCTABarDelegate <NSObject>

- (void)onSearchCTAtriggered:(SearchCTABar *)sender;

@end

@interface SearchCTABar : UIView

@property (nonatomic, strong, readonly) NSString *searchTitle;
@property (nonatomic, weak) id<SearchCTABarDelegate> delegate;

@end
