# Lab 7 · Profile Screen (Variant A)

A profile screen built in UIKit with a Storyboard only. Every view and every constraint is set in Interface Builder; no `UIStackView`. Swift code only fills in the data.

## Layout

- Avatar: 96 × 96 circle, centered
- Name: up to 2 lines, centered
- Stats: 3 equal columns (Equal Widths) with dividers
- Follow and Message: equal widths, 12 pt apart, 48 pt tall
- About: wraps with no line limit
- 16 pt side margins, all content inside the safe area

Long text test: name is "Maximilian Alexander von Habsburg".

## iPhone 18 Pro

![iPhone 18 Pro](screenshots/iphone18pro.png)

## iPhone 18 Pro Max

![iPhone 18 Pro Max](screenshots/iphone18promax.png)

## iPhone SE (3rd generation), Interface Builder preview

The Xcode version used (iOS 27 runtime) has no iPhone SE simulator, so the small screen was checked with "View as: iPhone SE (3rd generation)" in Interface Builder.

![iPhone SE preview](screenshots/iphonese.png)

## No constraint warnings

![Document Outline without warnings](screenshots/outline.png)
