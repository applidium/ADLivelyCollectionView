# ADLivelyCollectionView - UICollectionView with style

ADLivelyCollectionView is a drop-in subclass of UICollectionView that lets you add custom animations to any UICollectionView.

This is the port of [ADLivelyTableView](https://github.com/applidium/ADLivelyTableView), one of our most starred libraries on GitHub, to UICollectionView.

It's rather simple to use :

*   Add ADLivelyCollectionView.h and ADLivelyCollectionView.m to your iOS project
*   Link against the QuartzCore framework if you don't already
*   Turn any UICollectionView you want to animate (or subclass thereof) into a subclass of ADLivelyCollectionView
*   Pick whichever animation you like, like this : ``livelyCollectionView.initialCellTransformBlock = ADLivelyTransformFan;``

You can also write your own initial transform block.
