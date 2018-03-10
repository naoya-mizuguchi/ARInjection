//
//  opencvWrapper.h
//  TestScene
//
//  Created by Naoya Mizuguchi on 2018/02/28.
//  Copyright © 2018年 Naoya Mizuguchi. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface opencvWrapper : NSObject
//(返り値の型 *)関数名:(引数の型 *)引数名;
-(void)createCameraWithParentView:(UIImageView*)parentView;
-(void)start;
-(void)SetMetalImage:(UIImage*)src;
@end
