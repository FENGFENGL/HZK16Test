//
//  HZK16Helper.m
//  HZK16
//
//  Created by Jaime on 17/3/20.
//  Copyright © 2020年 Rayshine All rights reserved.
//

#import "HZK16Helper.h"
#import <UIKit/UIKit.h>
@implementation HZK16Helper

- (void)generateDotMatrix:(NSString *)word
{
    if (word.length != 1) {
        return;
    }
    
    NSStringEncoding encode = CFStringConvertEncodingToNSStringEncoding(kCFStringEncodingGB_18030_2000);
    const char *chars = [word cStringUsingEncoding:encode];
    // 0xA0 = 160
    NSInteger areaCode = [[NSNumber numberWithUnsignedChar:chars[0]] integerValue] - 160;
    NSInteger posCode = [[NSNumber numberWithUnsignedChar:chars[1]] integerValue] - 160;
    NSInteger offset = (94 * (areaCode - 1) + (posCode - 1 )) * 32;
    NSString *filePath =  [[NSBundle mainBundle] pathForResource:@"HZK16" ofType:@""];
//    NSString *mainBundleDirectory=[[NSBundle mainBundle] bundlePath];
//
//    NSString *filePath=[mainBundleDirectory stringByAppendingPathComponent:@"HZK16"];
    NSInteger fileLength = [NSData dataWithContentsOfFile:filePath].length;
    NSFileHandle *handle = [NSFileHandle fileHandleForReadingAtPath:filePath];
    if (!handle || offset >= fileLength) {
        return;
    }
    [handle seekToFileOffset:offset];
    NSData *data = [handle readDataOfLength:32];
    [handle closeFile];
    char buffer[32];
    [data getBytes:buffer length:32];
    char key[8] = {
        0x80,0x40,0x20,0x10,0x08,0x04,0x02,0x01
    };
    unsigned char b;
    int i,j,k;
//    for(NSInteger k = 0; k < 16; k++){
//        for(NSInteger j = 0; j < 2; j++){
//            for(NSInteger i = 0; i < 8; i++){
//               BOOL flag = buffer[k * 2 + j] & key[i];
//              //  printf("%s", flag?"*":" ");
//                NSLog(@"%s",flag?"●":"○");
//            }
//        }
//        printf("\n");
//    }
    
    for(i = 0; i < 16; i++)
    {
        /* 每行共FONT_SIZE / 8个字节 */
        for(j = 0; j < 16 / 8; j++)
        {
            b = buffer[i * 2 + j];
            /* 从左至右的点分别对应字节从高到低的位值 */
            for(k = 0; k < 8; k++)
            {
                if(b & 0x80)
                    printf("%s", "●");
                else
                    printf(" ");
                b <<= 1;
            }
        }
        printf("\n");
    }

}


- (void)sendText:(NSString *)str {
    
    FILE* fphzk = NULL;
    
    int offset;
    
    unsigned char buffer[32];
    
    unsigned char key[8] = { 0x80,0x40,0x20,0x10,0x08,0x04,0x02,0x01 };
    
    unsigned char word[3]; // 改成你的转码后的汉字编码//
    
    //文件路径
    NSString *path = [[NSBundle mainBundle] pathForResource:@"HZK16" ofType:@""];
    
    fphzk = fopen(path.UTF8String, "rb");
    
    if(fphzk == NULL){
        
        fprintf(stderr, "error hzk16\n");
        
        return;
        
    }
    
    NSMutableString *sendStr = [NSMutableString string];
    //循环解码    --》因为可能是多个汉字
    for (int i=0; i<str.length; i++) {
        
        NSString *endStr = [str substringWithRange:NSMakeRange(i, 1)];
        Byte *bytes = [self convertStringToGBKStr:endStr];//汉字ascii编码
        word[0] = bytes[0];

        word[1] = bytes[1];
        
        offset = (94*(unsigned int)(word[0]-0xa0-1)+(word[1]-0xa0-1))*32;
        
        fseek(fphzk, offset, SEEK_SET);
        
        fread(buffer, 1, 32, fphzk);
        
        NSMutableArray<NSArray *> *ary = [NSMutableArray array];
        NSLog(@"==========================================================");
        for(int k=0; k < 16; k++) {
            
            NSMutableArray<NSString *> *strMutableArray = [NSMutableArray array];
            
            for(int j=0; j < 2; j++) {
                
                for(int i=0; i < 8; i++) {
                    
                    int flag = buffer[k*2+j] & key[i];
                    
                    printf("%s", flag?"●":" ");
                    //2.设置字体格式
                      NSMutableDictionary *dict = [NSMutableDictionary dictionary];
                      dict[NSForegroundColorAttributeName] = [UIColor redColor];
                      dict[NSFontAttributeName] = [UIFont systemFontOfSize:30.0];
                      //3.绘制到View中
                      [str drawAtPoint:CGPointMake(100 , 100) withAttributes:dict];
                   
                    
                    [strMutableArray addObject:flag?@"●":@" "];
                    
                }
                
            }
            printf("\n");
            
            [ary addObject:strMutableArray];
            
        }
        
        //开始处理取模方式   --》在这里进行扫描以及取模的计算
        
        NSMutableString *overStr = [NSMutableString string];

        for (int i = 0; i < 16; i ++) {

            NSMutableString *newStr = [NSMutableString string];

            for (int j = 0; j < 8; j ++) {

                NSArray *strArr = ary[7-j];

                [newStr appendFormat:@"%@",strArr[i]];

            }

            [overStr appendFormat:@"%@",[self getHexByBinary:newStr]];

        }

        for (int i = 0; i < 16; i ++) {

            NSMutableString *newStr = [NSMutableString string];

            for (int j = 0; j < 8; j ++) {

                NSArray *strArr = ary[15-j];

                [newStr appendFormat:@"%@",strArr[i]];

            }

            [overStr appendFormat:@"%@",[self getHexByBinary:newStr]];

        }
        
        NSLog(@"最终输出的自处穿%@",overStr);
        
        [sendStr appendString:overStr];
         NSLog(@"最终输出的字符串%@",sendStr);
        
    }
    
    fclose(fphzk);
    
    fphzk = NULL;
    
    //在这里得到的sendStr即为按该中方式取模后的十六进制字符串
    
}


- (Byte *)convertStringToGBKStr:(NSString *)string {
    
    NSStringEncoding   gbkEncoding=CFStringConvertEncodingToNSStringEncoding(kCFStringEncodingGB_18030_2000);
    NSData*data = [string dataUsingEncoding: gbkEncoding];
    
    Byte *testByte = (Byte *)[data bytes];
    return testByte;
}

- (NSString *)getHexByBinary:(NSString *)binary {
    
    NSMutableDictionary *binaryDic = [[NSMutableDictionary alloc] initWithCapacity:16];
    [binaryDic setObject:@"0" forKey:@"0000"];
    [binaryDic setObject:@"1" forKey:@"0001"];
    [binaryDic setObject:@"2" forKey:@"0010"];
    [binaryDic setObject:@"3" forKey:@"0011"];
    [binaryDic setObject:@"4" forKey:@"0100"];
    [binaryDic setObject:@"5" forKey:@"0101"];
    [binaryDic setObject:@"6" forKey:@"0110"];
    [binaryDic setObject:@"7" forKey:@"0111"];
    [binaryDic setObject:@"8" forKey:@"1000"];
    [binaryDic setObject:@"9" forKey:@"1001"];
    [binaryDic setObject:@"A" forKey:@"1010"];
    [binaryDic setObject:@"B" forKey:@"1011"];
    [binaryDic setObject:@"C" forKey:@"1100"];
    [binaryDic setObject:@"D" forKey:@"1101"];
    [binaryDic setObject:@"E" forKey:@"1110"];
    [binaryDic setObject:@"F" forKey:@"1111"];
    
    if (binary.length % 4 != 0) {
        
        NSMutableString *mStr = [[NSMutableString alloc]init];;
        for (int i = 0; i < 4 - binary.length % 4; i++) {
            
            [mStr appendString:@"0"];
        }
        binary = [mStr stringByAppendingString:binary];
    }
    NSString *hex = @"";
    for (int i=0; i<binary.length; i+=4) {
        
        NSString *key = [binary substringWithRange:NSMakeRange(i, 4)];
        NSString *value = [binaryDic objectForKey:key];
        if (value) {
            
            hex = [hex stringByAppendingString:value];
        }
    }
    return hex;
}


@end
