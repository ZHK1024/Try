//
//  AppDelegate.h
//  WiFFServer
//
//  Created by ZHK on 2018/2/12.
//  Copyright © 2018年 ZHK. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

@property (readonly, strong) NSPersistentContainer *persistentContainer;

- (void)saveContext;


@end

