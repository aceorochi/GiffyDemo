//
//  SearchCTABar.m
//  giffyDemo
//
//  Created by Pei Wu on 8/25/16.
//  Copyright © 2016 Pei Wu. All rights reserved.
//

#import "SearchCTABar.h"

@interface SearchCTABar()

@property (nonatomic, strong) UITextField *inputField;
@property (nonatomic, strong) UIButton *searchButton;

@end

@implementation SearchCTABar

- (id)initWithFrame:(CGRect)frame {
  if (self = [super initWithFrame:frame]) {
    self.inputField = [UITextField new];
    self.inputField.backgroundColor = [UIColor lightGrayColor];
    self.inputField.placeholder = @"Enter keywords";
    [self addSubview:self.inputField];
    self.searchButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self addSubview:self.searchButton];
    [self.searchButton setTitle:@"Search" forState:UIControlStateNormal];
    [self.searchButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [self.searchButton addTarget:self action:@selector(onSearchButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    self.searchButton.backgroundColor = [UIColor yellowColor];
  }
  return self;
}

- (void)layoutSubviews {
  [super layoutSubviews];
  self.inputField.frame = CGRectMake(40, 4, 160, 40);
  self.searchButton.frame = CGRectMake(260, 4, 100, 40);
}

- (NSString *)searchTitle {
  return self.inputField.text;
}

- (void)onSearchButtonClicked:(id)sender {
  [self.delegate onSearchCTAtriggered:self];
  [self endEditing:YES];
}

@end
