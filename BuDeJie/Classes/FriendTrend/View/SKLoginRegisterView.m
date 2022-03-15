//
//  SKLoginRegisterView.m
//  BuDeJie
//
//  Created by hongchen li on 2022/2/23.
//  Copyright © 2022 shacokent. All rights reserved.
//

#import "SKLoginRegisterView.h"
@interface SKLoginRegisterView()
@property (weak, nonatomic) IBOutlet UIButton *loginRegisterBtn;

@end

@implementation SKLoginRegisterView

+(instancetype)loginView{
    return [[[NSBundle mainBundle] loadNibNamed:NSStringFromClass(self) owner:nil options:nil] firstObject];
}

+(instancetype)registerView{
    return [[[NSBundle mainBundle] loadNibNamed:NSStringFromClass(self) owner:nil options:nil] lastObject];
}

- (void)awakeFromNib{
    [super awakeFromNib];
    UIImage *image = _loginRegisterBtn.currentBackgroundImage;
    image = [image stretchableImageWithLeftCapWidth:image.size.width*0.5 topCapHeight:image.size.height*0.5];
    [_loginRegisterBtn setBackgroundImage:image forState:UIControlStateNormal];
    UIImage *highLightImage = [UIImage imageNamed:@"loginBtnBgClick"];
    highLightImage = [highLightImage stretchableImageWithLeftCapWidth:highLightImage.size.width*0.5 topCapHeight:highLightImage.size.height*0.5];
    [_loginRegisterBtn setBackgroundImage:highLightImage forState:UIControlStateHighlighted];
}
@end
