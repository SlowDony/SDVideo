
//
//  SDHeader.h
//  SDVideo
//
//  Created by slowdony on 2018/6/12.
//  Copyright © 2018年 slowdony. All rights reserved.
//

#ifndef SDHeader_h
#define SDHeader_h
///随机色
#define UIColorFormRandom [UIColor colorWithRed:(arc4random() % 256)/255.0 green:(arc4random() % 256)/255.0 blue:(arc4random() % 256)/255.0 alpha:1]

///屏幕宽高
#define SCREEN_WIDTH    [UIScreen mainScreen].bounds.size.width
#define SCREEN_HEIGHT   [UIScreen mainScreen].bounds.size.height

#endif /* SDHeader_h */
