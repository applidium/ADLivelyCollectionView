//
//  ADLivelyCollectionView.m
//  ADLivelyCollectionView
//
//  Created by Romain Goyet on 18/04/12.
//  Copyright (c) 2012 Applidium. All rights reserved.
//

#import "ADLivelyCollectionView.h"
#import <QuartzCore/QuartzCore.h>

NSTimeInterval ADLivelyDefaultDuration = 0.2;

CGFloat CGFloatSign(CGFloat value) {
    if (value < 0) {
        return -1.0f;
    }
    return 1.0f;
}

ADLivelyTransform ADLivelyTransformCurl = ^(CALayer * layer, float speed){
    CATransform3D transform = CATransform3DIdentity;
    transform.m34 = 1.0 / -500;
    transform = CATransform3DTranslate(transform, -layer.bounds.size.width/2.0f, 0.0f, 0.0f);
    transform = CATransform3DRotate(transform, M_PI/2, 0.0f, 1.0f, 0.0f);
    layer.transform = CATransform3DTranslate(transform, layer.bounds.size.width/2.0f, 0.0f, 0.0f);
    return ADLivelyDefaultDuration;
};

ADLivelyTransform ADLivelyTransformFade = ^(CALayer * layer, float speed){
    if (speed != 0.0f) { // Don't animate the initial state
        layer.opacity = 1.0f - fabs(speed);
    }
    return 2 * ADLivelyDefaultDuration;
};

ADLivelyTransform ADLivelyTransformFan = ^(CALayer * layer, float speed){
    CATransform3D transform = CATransform3DIdentity;
    transform = CATransform3DTranslate(transform, -layer.bounds.size.width/2.0f, 0.0f, 0.0f);
    transform = CATransform3DRotate(transform, -M_PI/2 * speed, 0.0f, 0.0f, 1.0f);
    layer.transform = CATransform3DTranslate(transform, layer.bounds.size.width/2.0f, 0.0f, 0.0f);
    layer.opacity = 1.0f - fabs(speed);
    return ADLivelyDefaultDuration;
};

ADLivelyTransform ADLivelyTransformFlip = ^(CALayer * layer, float speed){
    CATransform3D transform = CATransform3DIdentity;
    transform = CATransform3DTranslate(transform, 0.0f, CGFloatSign(speed) * layer.bounds.size.height/2.0f, 0.0f);
    transform = CATransform3DRotate(transform, CGFloatSign(speed) * M_PI/2, 1.0f, 0.0f, 0.0f);
    layer.transform = CATransform3DTranslate(transform, 0.0f, -CGFloatSign(speed) * layer.bounds.size.height/2.0f, 0.0f);
    layer.opacity = 1.0f - fabs(speed);
    return 2 * ADLivelyDefaultDuration;
};

ADLivelyTransform ADLivelyTransformHelix = ^(CALayer * layer, float speed){
    CATransform3D transform = CATransform3DIdentity;
    transform = CATransform3DTranslate(transform, 0.0f, CGFloatSign(speed) * layer.bounds.size.height/2.0f, 0.0f);
    transform = CATransform3DRotate(transform, M_PI, 0.0f, 1.0f, 0.0f);
    layer.transform = CATransform3DTranslate(transform, 0.0f, -CGFloatSign(speed) * layer.bounds.size.height/2.0f, 0.0f);
    layer.opacity = 1.0f - 0.2*fabs(speed);
    return 2 * ADLivelyDefaultDuration;
};

ADLivelyTransform ADLivelyTransformTilt = ^(CALayer * layer, float speed){
    if (speed != 0.0f) { // Don't animate the initial state
        layer.transform = CATransform3DMakeScale(0.8f, 0.8f, 0.8f);
        layer.opacity = 1.0f - fabs(speed);
    }
    return 2 * ADLivelyDefaultDuration;
};

ADLivelyTransform ADLivelyTransformWave = ^(CALayer * layer, float speed){
    if (speed != 0.0f) { // Don't animate the initial state
        layer.transform = CATransform3DMakeTranslation(-layer.bounds.size.width/2.0f, 0.0f, 0.0f);
    }
    return ADLivelyDefaultDuration;
};

ADLivelyTransform ADLivelyTransformGrow = ^(CALayer * layer, float speed){
    if (speed != 0.0f) { // Don't animate the initial state
        layer.transform = CATransform3DMakeScale(0.0, 0.0, 1.0);
    }
    return ADLivelyDefaultDuration;
};

@implementation ADLivelyCollectionView
#pragma mark - NSObject
- (void)dealloc {
    Block_release(_transformBlock);
    [super dealloc];
}

#pragma mark - UIView
+ (Class)layerClass {
    // This lets us rotate cells in the collectionview's 3D space
    return [CATransformLayer class];
}

#pragma mark - UICollectionView
- (void)setDelegate:(id<UICollectionViewDelegate>)delegate {
    // The order here is important, as there seem to be some observing done on setDelegate:
    if (delegate == self) {
        _preLivelyDelegate = nil;
    } else {
        _preLivelyDelegate = delegate;
    }
    [super setDelegate:self];
}

- (void)setDataSource:(id<UICollectionViewDataSource>)dataSource {
    // The order here is important, as there seem to be some observing done on setDelegate:
    if (dataSource == self) {
        _preLivelyDataSource = nil;
    } else {
        _preLivelyDataSource = dataSource;
    }
    [super setDataSource:self];
}

- (BOOL)respondsToSelector:(SEL)aSelector {
    return [super respondsToSelector:aSelector] || [_preLivelyDelegate respondsToSelector:aSelector] || [_preLivelyDataSource respondsToSelector:aSelector];
}

- (void)forwardInvocation:(NSInvocation *)anInvocation {
    if ([_preLivelyDelegate respondsToSelector:[anInvocation selector]]) {
        [anInvocation invokeWithTarget:_preLivelyDelegate];
    } else if ([_preLivelyDataSource respondsToSelector:[anInvocation selector]]) {
        [anInvocation invokeWithTarget:_preLivelyDataSource];
    } else {
        [super forwardInvocation:anInvocation];
    }
}

#pragma mark - ADLivelyCollectionView
- (CGPoint)scrollSpeed {
    return CGPointMake(_lastScrollPosition.x - _currentScrollPosition.x,
                       _lastScrollPosition.y - _currentScrollPosition.y);
}

- (void)setInitialCellTransformBlock:(ADLivelyTransform)block {
    CATransform3D transform = CATransform3DIdentity;
    if (block != nil) {
        transform.m34 = -1.0/self.bounds.size.width;
    }
    self.layer.transform = transform;

    if (block != _transformBlock) {
        Block_release(_transformBlock);
        _transformBlock = Block_copy(block);
    }
}

#pragma mark - UIScrollViewDelegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    if ([_preLivelyDelegate respondsToSelector:@selector(scrollViewDidScroll:)]) {
        [_preLivelyDelegate scrollViewDidScroll:scrollView];
    }
    _lastScrollPosition = _currentScrollPosition;
    _currentScrollPosition = [scrollView contentOffset];
}

#pragma mark - UICollectionViewDataSource
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    UICollectionViewCell * cell = nil;
    if ([_preLivelyDataSource respondsToSelector:@selector(collectionView:cellForItemAtIndexPath:)]) {
        cell = [_preLivelyDataSource collectionView:collectionView cellForItemAtIndexPath:indexPath];
    }
    float speed = self.scrollSpeed.y;
    float normalizedSpeed = MAX(-1.0f, MIN(1.0f, speed/20.0f));

    if (_transformBlock) {
        NSTimeInterval animationDuration = _transformBlock(cell.layer, normalizedSpeed);
        // The block-based equivalent doesn't play well with iOS 4
        [UIView beginAnimations:nil context:NULL];
        [UIView setAnimationDuration:animationDuration];
    }
    cell.layer.transform = CATransform3DIdentity;
    cell.layer.opacity = 1.0f;
    if (_transformBlock) {
        [UIView commitAnimations];
    }

    return cell;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return [_preLivelyDataSource collectionView:collectionView numberOfItemsInSection:section];
}
@end
