#import <UIKit/UIKit.h>

@interface PLPlatterHeaderContentView : UIView
@property (nonatomic,copy) NSArray * icons;
-(UIColor *)averageColorOfImage:(UIImage*)image;
@end

@interface PLPlatterView : UIView
@end

@interface PLTitledPlatterView : PLPlatterView
@end

@interface NCNotificationShortLookView : PLTitledPlatterView
@end

%hook PLPlatterHeaderContentView

%new
-(UIColor *)averageColorOfImage:(UIImage*)image {
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    unsigned char rgba[4];
    CGContextRef context = CGBitmapContextCreate(rgba, 1, 1, 8, 4, colorSpace, kCGImageAlphaPremultipliedLast | kCGBitmapByteOrder32Big);
    CGContextDrawImage(context, CGRectMake(0, 0, 1, 1), image.CGImage);
    CGColorSpaceRelease(colorSpace);
    CGContextRelease(context);
    if(rgba[3] > 0) {
        CGFloat alpha = ((CGFloat)rgba[3])/255.0;
        CGFloat multiplier = alpha/255.0;
        return [UIColor colorWithRed:((CGFloat)rgba[0])*multiplier
                               green:((CGFloat)rgba[1])*multiplier
                                blue:((CGFloat)rgba[2])*multiplier
                               alpha:alpha];
    } else {
        return [UIColor colorWithRed:((CGFloat)rgba[0])/255.0
                               green:((CGFloat)rgba[1])/255.0
                                blue:((CGFloat)rgba[2])/255.0
                               alpha:((CGFloat)rgba[3])/255.0];
    }
}

-(void)layoutSubviews {
	%orig;
	UIImage* image = self.icons[0];
	UIColor *domColor = [self averageColorOfImage:image];
	self.backgroundColor = [domColor colorWithAlphaComponent:1.5f];
	self.layer.cornerRadius = 13;
	
}

%end

%hook PLPlatterView

-(void)setBackgroundView:(UIView *)arg1 {
	arg1.alpha = 0.3;
	arg1.backgroundColor = [UIColor clearColor];
	%orig(arg1);
}

%end