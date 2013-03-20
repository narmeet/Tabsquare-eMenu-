//
//  TabSquareAppDelegate.h
//  TabSquareMenu
//
//  Created by Nikhil Kumar on 7/5/12.
//  Copyright (c) 2012 Trendsetterz. All rights reserved.
// Testing - Sankaran

#import <UIKit/UIKit.h>

enum ViewMode {
	ViewOnly = 1,
	ViewAndOrder
};

@class TabSquareHomeController;
@class TabSquareAssignTable;
@class TabSquareTableManagement;
@class TabSquareFavouriteViewController;
@class Reachability;
@class TabSquareQuickOrder;
@class PrintBillAndCheckOutFinal;

@interface AppDelegate: UIResponder

@property (strong, nonatomic) UIWindow *window;
@property (nonatomic, assign) NSInteger viewModeValue;
@property (nonatomic,strong)TabSquareTableManagement *viewController;

@end
