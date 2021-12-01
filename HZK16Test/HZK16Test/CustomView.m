//
//  CustomView.m
//  CGContextRef
//
//  Created by Jaime on 2020/12/8.
//  Copyright © 2020年 Rayshine. All rights reserved.
//

#import "CustomView.h"
#import <QuartzCore/QuartzCore.h>
#define PI 3.14159265358979323846

@implementation CustomView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor blackColor];
        self.path = [[NSBundle mainBundle] pathForResource:@"HZK16" ofType:@""];
        self.fphzk = NULL;
    }
    return self;
}

// 覆盖drawRect方法，你可以在此自定义绘画和动画
- (void)drawRect:(CGRect)rect
{
    [super drawRect:rect];
    //An opaque type that represents a Quartz 2D drawing environment.
    //一个不透明类型的Quartz 2D绘画环境,相当于一个画布,你可以在上面任意绘画
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    /*写文字*/
    CGContextSetRGBFillColor (context,  1, 0, 0, 1.0);//设置填充颜色
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    dict[NSForegroundColorAttributeName] = [UIColor whiteColor];
    dict[NSFontAttributeName] = [UIFont systemFontOfSize:30.0];
    
    NSString * str = @"欢迎光临";
    
 //   [str drawInRect:CGRectMake(10, 20, 80, 50) withAttributes:dict];
    

    
      // FILE* fphzk = NULL;
       
       int offset;
       
       Byte buffer[32];
       
       Byte key[8] = { 0x80,0x40,0x20,0x10,0x08,0x04,0x02,0x01 };
       
       Byte word[3]; // 改成你的转码后的汉字编码//
       
       //文件路径
     //  NSString *path = [[NSBundle mainBundle] pathForResource:@"HZK16" ofType:@""];
       
       self.fphzk = fopen(self.path.UTF8String, "rb");
       
       if(self.fphzk == NULL){
           
           fprintf(stderr, "error hzk16\n");
           
           return;
           
       }
       
  //     NSMutableString *sendStr = [NSMutableString string];
       //循环解码    --》因为可能是多个汉字
       for (int i= 0; i<str.length; i++) {
           
           NSString *endStr = [str substringWithRange:NSMakeRange(i, 1)];
           Byte *bytes = [self convertStringToGBKStr:endStr];//汉字ascii编码
           word[0] = bytes[0];

           word[1] = bytes[1];
           
           offset = (94*(unsigned int)(word[0]-0xa0-1)+(word[1]-0xa0-1))*32;
           
           fseek(self.fphzk, offset, SEEK_SET);
           
           fread(buffer, 1, 32, self.fphzk);
           
           NSMutableArray<NSArray *> *ary = [NSMutableArray array];
           NSLog(@"==========================================================%d",i);
     
           for(int k=0; k < 16; k++) {

               NSMutableArray<NSString *> *strMutableArray = [NSMutableArray array];

               for(int j=0; j < 2; j++) {

                   for(int m =0; m < 8; m++) {

                       int flag = buffer[k*2+j] & key[m];

                     //  printf("%s", flag?"●":" ");
                       //2.设置字体格式
//                         NSMutableDictionary *dict = [NSMutableDictionary dictionary];
//                         dict[NSForegroundColorAttributeName] = [UIColor whiteColor];
//                         dict[NSFontAttributeName] = [UIFont systemFontOfSize:10.0];

                       //  [strMutableArray addObject:flag?@"●":@" "];

                       if (flag) {
                           NSMutableDictionary *dict = [NSMutableDictionary dictionary];
                           dict[NSForegroundColorAttributeName] = [UIColor redColor];
                           dict[NSFontAttributeName] = [UIFont systemFontOfSize:10.0];

                           [@"●" drawAtPoint:CGPointMake((i*180)+(j*8+m)*(10+1*2),k*(10+1*2)) withAttributes:dict];
                           printf("%s","●");
                       } else {
                           NSMutableDictionary *dict = [NSMutableDictionary dictionary];
                           dict[NSForegroundColorAttributeName] = [UIColor blackColor];
                           dict[NSFontAttributeName] = [UIFont systemFontOfSize:10.0];

                           [@" " drawAtPoint:CGPointMake((i*180)+(j*8+m)*(10+1*2),k*(10+1*2)) withAttributes:dict];
                           printf("%s"," ");
                       }


                   }

               }
               printf("\n");

               [ary addObject:strMutableArray];

           }
//           unsigned char b;
//           int i,j,k;
//           NSMutableDictionary *dict = [NSMutableDictionary dictionary];
//           dict[NSForegroundColorAttributeName] = [UIColor whiteColor];
//           dict[NSFontAttributeName] = [UIFont systemFontOfSize:16.0];
//           for(i = 0; i < 16; i++)
//           {
//               /* 每行共FONT_SIZE / 8个字节 */
//               for(j = 0; j < 16 / 8; j++)
//               {
//                   b = buffer[i * 2 + j];
//                   /* 从左至右的点分别对应字节从高到低的位值 */
//                   for(k = 0; k < 8; k++)
//                   {
//                       if(b & 0x80) {
//                           [@"●" drawAtPoint:CGPointMake(j*(10+1*4)*k + 100 , i*(10+1*2) + 10 ) withAttributes:dict];
//                           printf("%s", "●");
//                       }
//                       else {
//                           [@"*" drawAtPoint:CGPointMake(j*(10+1*4)*k + 100 , i*(10+1*2) + 10 ) withAttributes:dict];
//                            printf(" ");
//                       }
//
//                       b <<= 1;
//                   }
//               }
//               printf("\n");
//           }
           
           // for (int row = 0; row < mDotMatrixFontType.getValue(); row++) {
           //            for (int col = 0; col < mDotMatrixFontType.getValue() * this.mWordNumber; col++) {
           //                if (mWordsMatrix[row][col]) {
           //                    canvas.drawCircle(col * (mPointSpace + mPaintRadius * 2) + mPointSpace + mPaintRadius,
           //                            row * (mPointSpace + mPaintRadius * 2) + mPointSpace + mPaintRadius,
           //                            mPaintRadius, mFillPaint);
           //                } else {
           //                    canvas.drawCircle(col * (mPointSpace + mPaintRadius * 2) + mPointSpace + mPaintRadius,
           //                            row * (mPointSpace + mPaintRadius * 2) + mPointSpace + mPaintRadius,
           //                            mPaintRadius, mHollowPaint);
           //                }
           //            }
           //        }
//           NSMutableDictionary *dict = [NSMutableDictionary dictionary];
//           dict[NSForegroundColorAttributeName] = [UIColor whiteColor];
//           dict[NSFontAttributeName] = [UIFont systemFontOfSize:13.0];
           
           
//           for (int row = 0; row < 16; row++ ) {
//               for (int col = 0; col < 2; col ++ ) {
//
//                   for (int i = 0; i < 8; i++ ) {
//                       int flag = buffer[row*2+col] & key[i];
//                       if (flag == 1) {
//                         //  [@"●" drawAtPoint:CGPointMake(col*(2+3*2) + 2 + 3, row*(2+3*2) + 2 +3) withAttributes:dict];
//                            printf("%s","●");
//                       } else {
//
//                          // [@" " drawAtPoint:CGPointMake(col*(2+3*2) + 2 + 3, row*(2+3*2) + 2 +3) withAttributes:dict];
//                            printf("%s"," ");
//                       }
//                   }
//               }
//
//               printf("\n");
//           }
           
           
           float w = self.frame.size.width;


           CGRect frame = self.frame;
           frame.origin.x = 375;
           self.frame = frame;

           [UIView beginAnimations:@"textAnimation" context:NULL];

           // [UIView setAnimationDuration:8.0f*(w<320?320:w) /320.0];

           [UIView setAnimationDuration:8.0f * (w < 375 ? 375:w ) / 375.0];

           [UIView setAnimationCurve:UIViewAnimationCurveLinear];
           [UIView setAnimationDelegate:self];
           [UIView setAnimationRepeatAutoreverses:NO];//是否能反转
           [UIView setAnimationRepeatCount:LONG_MAX];//重复次数

           frame = self.frame;
           frame.origin.x = -w;
           self.frame = frame;
           [UIView commitAnimations];
           
         //  [self addAnimationLabel];
           
       }
}


//给label添加滚动动画
- (void)addAnimationLabel {
    [self.layer removeAllAnimations];
    CGFloat space = 300 - self.frame.size.width;//label设置了sizetofit 宽度自适应
    CAKeyframeAnimation *keyFrameAnimation = [CAKeyframeAnimation animation];
    keyFrameAnimation.keyPath = @"transform.translation.x";
    keyFrameAnimation.values = @[@(0), @(-300), @(0)];
   // keyFrameAnimation.repeatCount = MAXFLOAT;
    keyFrameAnimation.duration = 0.01* 10;
    keyFrameAnimation.timingFunctions = @[[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut], [CAMediaTimingFunction functionWithControlPoints:0 :0 :0.5 :0.5]];
    [self.layer addAnimation:keyFrameAnimation forKey:nil];
}

- (Byte *)convertStringToGBKStr:(NSString *)string {
        
        NSStringEncoding   gbkEncoding=CFStringConvertEncodingToNSStringEncoding(kCFStringEncodingGB_18030_2000);
        NSData*data = [string dataUsingEncoding: gbkEncoding];
        
        Byte *testByte = (Byte *)[data bytes];
        return testByte;
}

@end
