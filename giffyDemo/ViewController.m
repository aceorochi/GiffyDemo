//
//  ViewController.m
//  giffyDemo
//
//  Created by Pei Wu on 8/25/16.
//  Copyright © 2016 Pei Wu. All rights reserved.
//

#import "ViewController.h"
#import "GiffyListView.h"
#import "SearchCTABar.h"

@interface ViewController () <SearchCTABarDelegate>

@property (nonatomic, strong) GiffyListView *giffyListView;
@property (nonatomic, strong) SearchCTABar *bar;

@end

@implementation ViewController

- (void)viewDidLoad {
  [super viewDidLoad];
  _bar = [SearchCTABar new];
  _bar.frame = CGRectMake(0, 20, self.view.bounds.size.width, 50);
  [self.view addSubview:_bar];
  _bar.delegate = self;
  
  _giffyListView = [GiffyListView new];
  [self.view addSubview:_giffyListView];
  _giffyListView.frame = CGRectMake(0, 70, self.view.bounds.size.width, self.view.bounds.size.height-70);
}

- (void)didReceiveMemoryWarning {
  [super didReceiveMemoryWarning];
  // Dispose of any resources that can be recreated.
}

- (void)onSearchCTAtriggered:(SearchCTABar *)sender {
  [_giffyListView refreshDataWithKeyWord:sender.searchTitle];
}

@end
