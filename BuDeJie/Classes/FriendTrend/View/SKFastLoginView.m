//
//  SKFastLoginView.m
//  BuDeJie
//
//  Created by hongchen li on 2022/2/23.
//  Copyright © 2022 shacokent. All rights reserved.
//

#import "SKFastLoginView.h"

@implementation SKFastLoginView
+(instancetype)fastLoginView{
    return [[[NSBundle mainBundle] loadNibNamed:NSStringFromClass(self) owner:nil options:nil] firstObject];
}

@end
