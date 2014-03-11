//
//  ADLivelyCollectionView.h
//  ADLivelyCollectionView
//
//  Created by Romain Goyet on 18/04/12.
//  Copyright (c) 2012 Applidium. All rights reserved.
//

#import <UIKit/UIKit.h>

extern NSTimeInterval ADLivelyDefaultDuration;
typedef NSTimeInterval (^ADLivelyTransform)(CALayer * layer, float speed);

extern ADLivelyTransform ADLivelyTransformCurl;
extern ADLivelyTransform ADLivelyTransformFade;
extern ADLivelyTransform ADLivelyTransformFan;
extern ADLivelyTransform ADLivelyTransformFlip;
extern ADLivelyTransform ADLivelyTransformHelix;
extern ADLivelyTransform ADLivelyTransformTilt;
extern ADLivelyTransform ADLivelyTransformWave;
extern ADLivelyTransform ADLivelyTransformGrow;

@interface ADLivelyCollectionView : UICollectionView <UICollectionViewDelegate, UICollectionViewDataSource> {
    id <UICollectionViewDelegate>  _preLivelyDelegate;
    id <UICollectionViewDataSource> _preLivelyDataSource;
    CGPoint _lastScrollPosition;
    CGPoint _currentScrollPosition;
    ADLivelyTransform _transformBlock;
}
- (CGPoint)scrollSpeed;
- (void)setInitialCellTransformBlock:(ADLivelyTransform)block;
@end
