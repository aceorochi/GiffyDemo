//
//  GiffyListView.m
//  giffyDemo
//
//  Created by Pei Wu on 8/25/16.
//  Copyright © 2016 Pei Wu. All rights reserved.
//

#import "GiffyListView.h"
#import <SDWebImage/UIImage+GIF.h>
#import <SDWebImage/UIImageView+WebCache.h>

NSString *const kCellReusableId = @"kCellReusableId";

@interface GiffyListViewCell : UICollectionViewCell

- (void)updateWithGifUrl:(NSString *)url;

@end

@implementation GiffyListViewCell {
  UIImageView *_imageView;
  NSString *_currentUrl;
}

- (id)initWithFrame:(CGRect)frame {
  if (self = [super initWithFrame:frame]) {
    _imageView = [UIImageView new];
    [self.contentView addSubview:_imageView];
  }
  return self;
}

- (void)layoutSubviews {
  [super layoutSubviews];
  _imageView.frame = self.contentView.bounds;
}

- (void)updateWithGifUrl:(NSString *)url {
  if ([url isEqual:_currentUrl]) return;
  _currentUrl = url;
  [_imageView sd_setImageWithURL:[NSURL URLWithString:_currentUrl]
                       completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
                         [_imageView startAnimating];
                       }];
}


@end


@interface GiffyListViewDataModel : NSObject <UICollectionViewDataSource>

@property (nonatomic, weak) GiffyListView* hostView;
- (void)reloadDataWithKeyword:(NSString *)keyword;

@end

@implementation GiffyListViewDataModel {
  NSMutableArray<NSDictionary *> *_dataSource;
  NSString *_keyword;
  BOOL _onLoadingMore;
}

- (void)reloadDataWithKeyword:(NSString *)keyword {
  _keyword = [keyword copy];
  [self loadMoreItemsForKeyword:keyword withOffset:0 withCompletion:^(NSArray *itemList) {
    _dataSource = [itemList mutableCopy];
    [self.hostView reloadData];
  }];
}

- (void)loadMoreItems {
  if (_onLoadingMore) {
    return;
  }
  NSLog(@"Trying to load more from offset:%zd", _dataSource.count);
  _onLoadingMore = YES;
  [self loadMoreItemsForKeyword:_keyword withOffset:_dataSource.count withCompletion:^(NSArray *itemList) {
    [_dataSource addObjectsFromArray:itemList];
    [self.hostView reloadData];
    _onLoadingMore = NO;
  }];
}

- (void)loadMoreItemsForKeyword:(NSString *)keyword withOffset:(NSInteger)offset withCompletion:(void(^)(NSArray *itemList))completion {
  if (keyword.length == 0) return;
  NSString *urlStr = [NSString stringWithFormat:@"http://api.giphy.com/v1/gifs/search?q=%@&api_key=dc6zaTOxFJmzC&offset=%zd", keyword, offset];
  NSURLSessionTask *task = [[NSURLSession sharedSession] dataTaskWithURL:[NSURL URLWithString:urlStr]
                                                       completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
                                                         id jsonObj = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
                                                         NSMutableArray *itemList = [NSMutableArray array];
                                                         NSArray *dataList = jsonObj[@"data"];
                                                         for (NSDictionary *infoDict in dataList) {
                                                           [itemList addObject:infoDict[@"images"][@"downsized"]];
                                                         }
                                                         dispatch_async(dispatch_get_main_queue(), ^{
                                                           if (completion) {
                                                             completion(itemList);
                                                           }
                                                         });
                                                       }];
  [task resume];
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
  return _dataSource.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
  GiffyListViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:kCellReusableId forIndexPath:indexPath];
  [cell updateWithGifUrl:_dataSource[indexPath.row][@"url"]];
  if (_dataSource.count - indexPath.row <= 6) {
    [self loadMoreItems];
  }
  return cell;
}

@end

@interface GiffyListView () <UICollectionViewDelegate>

@property (nonatomic, strong) GiffyListViewDataModel *dataModel;

@end

@implementation GiffyListView

- (id)initWithFrame:(CGRect)frame {
  UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
  layout.minimumLineSpacing = 8.0;
  layout.minimumInteritemSpacing = 8.0;
  CGFloat itemWidth = floor(([UIScreen mainScreen].bounds.size.width - layout.minimumInteritemSpacing * 2)/3);
  layout.itemSize = CGSizeMake(itemWidth, itemWidth);
  layout.scrollDirection = UICollectionViewScrollDirectionVertical;
  return [self initWithFrame:frame collectionViewLayout:layout];
}

- (id)initWithFrame:(CGRect)frame collectionViewLayout:(UICollectionViewLayout *)layout {
  if (self = [super initWithFrame:frame collectionViewLayout:layout]) {
    self.backgroundColor = [UIColor greenColor];
    self.dataModel = [GiffyListViewDataModel new];
    self.dataModel.hostView = self;
    self.dataSource = self.dataModel;
    self.delegate = self;
    [self registerClass:[GiffyListViewCell class] forCellWithReuseIdentifier:kCellReusableId];
  }
  return self;
}

- (void)refreshDataWithKeyWord:(NSString *)keyword {
  [self.dataModel reloadDataWithKeyword:keyword];
}

@end
