# ADLivelyCollectionView - UICollectionView with style

ADLivelyCollectionView is a drop-in subclass of UICollectionView that lets you add custom animations to any UICollectionView.

This is the port of [ADLivelyTableView](https://github.com/applidium/ADLivelyTableView), one of our most starred libraries on GitHub, to UICollectionView.

It's rather simple to use :

*   Add ADLivelyCollectionView.h and ADLivelyCollectionView.m to your iOS project
*   Link against the QuartzCore framework if you don't already
*   Turn any UICollectionView you want to animate (or subclass thereof) into a subclass of ADLivelyCollectionView
*   Pick whichever animation you like, like this : ``livelyCollectionView.initialCellTransformBlock = ADLivelyTransformFan;``

You can also write your own initial transform block.

## Compatibility
This project does not use ARC. To add ADLivelyCollectionView to a project using ARC, set the compiler flag `-fno-objc-arc` for the source file `ADLivelyCollectionView.m` in Targets → Build Phases → Compile Sources (double click on the right column of the row under Compiler Flags).