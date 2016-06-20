//
//  ViewController.m
//  CreateNewApp
//
//  Created by MAC Mini on 16/1/25.
//  Copyright © 2016年 test. All rights reserved.
//

#import "ViewController.h"
#import "NextViewController.h"
#import <AVFoundation/AVMediaFormat.h>
#import <AVFoundation/AVCaptureDevice.h>
#import <PassKit/PassKit.h>

#import <SMS_SDK/SMSSDK.h>
#import "SMSSDKUI.h"

#import <sys/socket.h>
#import <netinet/in.h>
#import <arpa/inet.h>
#import <unistd.h>
#import "AsyncUdpSocket.h"
#import "GCDAsyncSocket.h"
#import "GCDAsyncUdpSocket.h"

#define HostStr @"192.168.2.58"
#define PortKey 9527

#import "MBProgressHUD.h"
#import "FVCustomAlertView.h"

#define  Wdith   [UIScreen mainScreen].bounds.size.width
#define  Height  [UIScreen mainScreen].bounds.size.height

@interface ViewController ()<PKPaymentAuthorizationViewControllerDelegate,GCDAsyncSocketDelegate,GCDAsyncUdpSocketDelegate>
@property (nonatomic , assign) BOOL isLightOn;
@property (nonatomic , strong) AVCaptureDevice * device;
@property (nonatomic ,assign)  BOOL isappear;
@property (nonatomic ,strong) GCDAsyncSocket * asySocket ;
@property (nonatomic ,strong) GCDAsyncSocket * s ;
@property (nonatomic ,strong) MBProgressHUD * hud;
@property (nonatomic ,strong) UIImageView * imageView;
@end

@implementation ViewController


-(MBProgressHUD *)hud {
    if (!_hud) {
        MBProgressHUD * hud = [[MBProgressHUD alloc] initWithView:self.view];
        _hud = hud;
        hud.dimBackground = YES;
        hud.mode = MBProgressHUDModeIndeterminate;
        hud.labelText =nil;
        hud.labelFont = [UIFont systemFontOfSize:16.0];
        hud.removeFromSuperViewOnHide = YES;
        [self.view addSubview:hud];
    
    }

    return _hud;
}

-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self createlisten];
  //  [self.hud show:YES];

}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    self.title = @"伟大的日子";
    self.view.backgroundColor = [UIColor purpleColor];
    
//    UIBezierPath *path = [UIBezierPath bezierPath];
//    // 添加路径[1条点(100,100)到点(200,100)的线段]到path
//    [path moveToPoint:CGPointMake(100 , 100)];
//    [path addLineToPoint:CGPointMake(200, 100)];
//    // 将path绘制出来
//    [path stroke];
    
    self.isappear = YES;
    
    UIButton * enterBtn = [UIButton buttonWithType:UIButtonTypeSystem];
    enterBtn.frame = CGRectMake(50, 100, 60, 30);
    [enterBtn setTitle:@"下一页" forState:UIControlStateNormal];
    [enterBtn addTarget:self action:@selector(enterNextPage:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:enterBtn];
    
    CGFloat x = 0;
    CGFloat y = Height ;
    // 0 1 2 3 4 5
    for (int i = 0; i < 6; i++) {
         UIButton * secondBtn = [UIButton buttonWithType:UIButtonTypeSystem];
        secondBtn.tag = i + 7777;
//        int row = i/2;
//        int loc = i%2;
//        secondBtn.frame = CGRectMake(20 + (40 +20) * row, y + (40 + 20) * loc , 40, 40);
       secondBtn.frame = CGRectMake(x, y, 60, 60);
        secondBtn.backgroundColor = [UIColor blueColor];
        [self.view addSubview:secondBtn];
        if (i == 2) {
            
            x= 0; y += 80;
        } else {
        
            x += 80;
        }
        
    }
   
//    UIButton * checkMessageBtn = [UIButton buttonWithType:UIButtonTypeSystem];
//    checkMessageBtn.frame = CGRectMake(50, 300, 80, 40);
//    [checkMessageBtn setTitle:@"短信验证" forState:UIControlStateNormal];
//    [checkMessageBtn addTarget:self action:@selector(checkMessage:) forControlEvents:UIControlEventTouchUpInside];
//    [self.view addSubview:checkMessageBtn];
    
    UIButton * checkMessageBtn = [UIButton buttonWithType:UIButtonTypeSystem];
    checkMessageBtn.frame = CGRectMake(50, 300, 80, 40);
    [checkMessageBtn setTitle:@"UDP通讯" forState:UIControlStateNormal];
    [checkMessageBtn addTarget:self action:@selector(checkMessage:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:checkMessageBtn];
   
    
    UIButton * skipPageBtn = [UIButton buttonWithType:UIButtonTypeSystem];
    skipPageBtn.frame = CGRectMake(50, 500, 80, 40);
    [skipPageBtn setTitle:@"跳转界面" forState:UIControlStateNormal];
    [skipPageBtn addTarget:self action:@selector(skipPage:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:skipPageBtn];
    
//    self.imageView = [[UIImageView alloc] init];
//    self.imageView.frame = CGRectMake(Wdith - 150 ,100,100,100 );
//    self.imageView.backgroundColor = [UIColor lightGrayColor];
//    [self.view addSubview:self.imageView];
//    [self erweima];
}


-(void)erweima {

    CIFilter * filter = [CIFilter filterWithName:@"CIQRCodeGenerator"];
    [filter setDefaults];
    NSString * str = @"http://www.baidu.com";
    NSData * data = [str dataUsingEncoding:NSUTF8StringEncoding];
    [filter setValue:data forKey:@"inputMessage"];
    CIImage * image = [filter outputImage];
    self.imageView.image = [self createNonInterpolatedUIImageFormCIImage:image withSize:100.0];
    
}


- (void) shakeToShow:(UIView*)aView{
    CAKeyframeAnimation* animation = [CAKeyframeAnimation animationWithKeyPath:@"transform"];
    animation.duration = 0.5;
    
    NSMutableArray *values = [NSMutableArray array];
    [values addObject:[NSValue valueWithCATransform3D:CATransform3DMakeScale(0.1, 0.1, 1.0)]];
    [values addObject:[NSValue valueWithCATransform3D:CATransform3DMakeScale(1.2, 1.2, 1.0)]];
    [values addObject:[NSValue valueWithCATransform3D:CATransform3DMakeScale(0.9, 0.9, 1.0)]];
    [values addObject:[NSValue valueWithCATransform3D:CATransform3DMakeScale(1.0, 1.0, 1.0)]];
    animation.values = values;
    [aView.layer addAnimation:animation forKey:nil];
}

- (UIImage *)createNonInterpolatedUIImageFormCIImage:(CIImage *)image withSize:(CGFloat) size {
    
    CGRect extent = CGRectIntegral(image.extent);
    
    CGFloat scale = MIN(size/CGRectGetWidth(extent), size/CGRectGetHeight(extent));
    
    // 创建bitmap;
    
    size_t width = CGRectGetWidth(extent) * scale;
    
    size_t height = CGRectGetHeight(extent) * scale;
    
    CGColorSpaceRef cs = CGColorSpaceCreateDeviceGray();
    
    CGContextRef bitmapRef = CGBitmapContextCreate(nil, width, height, 8, 0, cs, (CGBitmapInfo)kCGImageAlphaNone);
    
    CIContext *context = [CIContext contextWithOptions:nil];
    
    CGImageRef bitmapImage = [context createCGImage:image fromRect:extent];
    
    CGContextSetInterpolationQuality(bitmapRef, kCGInterpolationNone);
    
    CGContextScaleCTM(bitmapRef, scale, scale);
    
    CGContextDrawImage(bitmapRef, extent, bitmapImage);
    
    // 保存bitmap到图片
    
    CGImageRef scaledImage = CGBitmapContextCreateImage(bitmapRef);
    
    CGContextRelease(bitmapRef);
    
    CGImageRelease(bitmapImage);
    
    return [UIImage imageWithCGImage:scaledImage];
    
}

-(void)createlisten {
    
    self.asySocket = [[GCDAsyncSocket alloc] initWithDelegate:self delegateQueue:dispatch_get_main_queue()];
    NSError * error = nil;
    
    BOOL right = [self.asySocket acceptOnPort:PortKey error:&error];
    if (!right) {
        NSLog(@"错误信息是 %@",error.description);
        self.hud.labelText = error.description;
        [self.hud hide:YES afterDelay:0.05];
    } else {
    
        NSLog(@"开始监听端口%d的数据",PortKey);
        self.hud.labelText = [NSString stringWithFormat:@"开始监听端口%d的数据",PortKey];
        [self.hud hide:YES afterDelay:0.05];

    }
    
    [self.s connectToHost:HostStr onPort:PortKey error:&error];
}
-(void)socket:(GCDAsyncSocket *)sock didAcceptNewSocket:(GCDAsyncSocket *)newSocket {
    
    NSLog(@"建立与%@的连接",newSocket.connectedHost);
    self.hud.labelText = newSocket.connectedHost;
    [self.hud hide:YES afterDelay:2.0];
    self.s = newSocket;
    self.s.delegate = self;
    [self.s readDataWithTimeout:-1 tag:0];
    
    
}

-(void) socket:(GCDAsyncSocket *)sock didReadData:(NSData *)data withTag:(long)tag {
    
    NSString * message = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    
    NSString * str = [NSString stringWithFormat:@"服务器收到信息内容是 /n %@",message];
    self.hud.labelText = str;
    [self.hud hide:YES afterDelay:2.0];
    
    
   
    
}




// 短信验证
-(void)checkMessage:(UIButton *)btn {

    //[SMSSDKUI showVerificationCodeViewWithMethod:SMSGetCodeMethodSMS];
    
//    [SMSSDKUI showVerificationCodeViewWithMetohd:SMSGetCodeMethodSMS result:^(enum SMSUIResponseState state, NSString *phoneNumber, NSString *zone, NSError *error) {
//        
//    }];
    
    NSString* message = @"这是真的吗";
    NSData * da = [message dataUsingEncoding:NSUTF8StringEncoding];
    [self.s writeData:da withTimeout:-1 tag:0];
    [self.s  readDataWithTimeout:-1 tag:0];

}

//
-(void)skipPage:(UIButton *)btn {

//    
//    NextViewController * VC = [[NextViewController alloc] init];
//    [self.navigationController pushViewController:VC animated:YES];
    [ self shakeToShow:self.imageView];
 

}

// apple pay 支付
-(void)enterNextPage:(UIButton *)btn {
    
    
    if([PKPaymentAuthorizationViewController canMakePayments]) {
        
        NSLog(@"Woo! Can make payments!");
        
        PKPaymentRequest *request = [[PKPaymentRequest alloc] init];
        
        PKPaymentSummaryItem *widget1 = [PKPaymentSummaryItem summaryItemWithLabel:@"Widget 1"
                                                                            amount:[NSDecimalNumber decimalNumberWithString:@"0.99"]];
        
        PKPaymentSummaryItem *widget2 = [PKPaymentSummaryItem summaryItemWithLabel:@"Widget 2"
                                                                            amount:[NSDecimalNumber decimalNumberWithString:@"1.00"]];
        
        PKPaymentSummaryItem *total = [PKPaymentSummaryItem summaryItemWithLabel:@"Grand Total"
                                                                          amount:[NSDecimalNumber decimalNumberWithString:@"1.99"]];
        
        request.paymentSummaryItems = @[widget1, widget2, total];
        request.countryCode = @"US";
        request.currencyCode = @"USD";
        request.supportedNetworks = @[PKPaymentNetworkAmex, PKPaymentNetworkMasterCard, PKPaymentNetworkVisa];
        request.merchantIdentifier = @"merchant.com.test.CreateNewApp";
        request.merchantCapabilities = PKMerchantCapabilityEMV;
        
        PKPaymentAuthorizationViewController *paymentPane = [[PKPaymentAuthorizationViewController alloc] initWithPaymentRequest:request];
        paymentPane.delegate = self;
        
        [self presentViewController:paymentPane animated:YES completion:^{
            
        }];
        
    } else {
        
        NSLog(@"This device cannot make payments");
    }

// 当设置成没有动画的时候 直接跳转
//    NextViewController * vc = [[NextViewController alloc] init];
//    [self presentViewController:vc animated:YES completion:^{
//        
//    }];
   // [self turnOnLed:YES];
//    if (self.isappear) {
//        self.isappear = NO;
//        for (UIView * view in  self.view.subviews) {
//            UIButton * button = (UIButton*)view;
//            switch (button.tag -7777) {
//                case 0:
//                {
//                    [UIView animateWithDuration:1 delay:0.f usingSpringWithDamping:0.4f initialSpringVelocity:1.0f options:UIViewAnimationOptionCurveEaseInOut animations:^{
//                        button.frame = CGRectMake(view.frame.origin.x, view.frame.origin.y -400, view.frame.size.width, view.frame.size.height);
//                    } completion:^(BOOL finished) {
//                        
//                    }];
//                }
//                    break;
//                case 1:
//                {
//                    [UIView animateWithDuration:1 delay:0.04f usingSpringWithDamping:0.4f initialSpringVelocity:1.0f options:UIViewAnimationOptionCurveEaseInOut animations:^{
//                        button.frame = CGRectMake(view.frame.origin.x, view.frame.origin.y -400, view.frame.size.width, view.frame.size.height);
//                    } completion:^(BOOL finished) {
//                        
//                    }];
//                }
//                    break;
//                case 2:
//                {
//                    [UIView animateWithDuration:1 delay:0.08f usingSpringWithDamping:0.4f initialSpringVelocity:1.0f options:UIViewAnimationOptionCurveEaseInOut animations:^{
//                        button.frame = CGRectMake(view.frame.origin.x, view.frame.origin.y -400, view.frame.size.width, view.frame.size.height);
//                    } completion:^(BOOL finished) {
//                        
//                    }];
//                }
//                    break;
//                case 3:
//                {
//                    [UIView animateWithDuration:1 delay:0.12f usingSpringWithDamping:0.4f initialSpringVelocity:1.0f options:UIViewAnimationOptionCurveEaseInOut animations:^{
//                        button.frame = CGRectMake(view.frame.origin.x, view.frame.origin.y -400, view.frame.size.width, view.frame.size.height);
//                    } completion:^(BOOL finished) {
//                        
//                    }];
//                }
//                    break;
//                case 4:
//                {
//                    [UIView animateWithDuration:1 delay:0.16f usingSpringWithDamping:0.4f initialSpringVelocity:1.0f options:UIViewAnimationOptionCurveEaseInOut animations:^{
//                        button.frame = CGRectMake(view.frame.origin.x, view.frame.origin.y -400, view.frame.size.width, view.frame.size.height);
//                    } completion:^(BOOL finished) {
//                        
//                    }];
//                }
//                    break;
//                case 5:
//                {
//                    [UIView animateWithDuration:1 delay:0.2f usingSpringWithDamping:0.4f initialSpringVelocity:1.0f options:UIViewAnimationOptionCurveEaseInOut animations:^{
//                        button.frame = CGRectMake(view.frame.origin.x, view.frame.origin.y -400, view.frame.size.width, view.frame.size.height);
//                    } completion:^(BOOL finished) {
//                        
//                    }];
//                }
//                    break;
//                    
//                default:
//                    break;
//            }
//        }
//        
//
//    } else {
//        self.isappear = YES;
//        
//        for (UIView * view in  self.view.subviews) {
//            UIButton * button = (UIButton*)view;
//            switch (button.tag -7777) {
//                case 0:
//                {
//                    [UIView animateWithDuration:1 delay:0.2f usingSpringWithDamping:0.4f initialSpringVelocity:1.0f options:UIViewAnimationOptionCurveEaseInOut animations:^{
//                        button.frame = CGRectMake(view.frame.origin.x, view.frame.origin.y +400, view.frame.size.width, view.frame.size.height);
//                    } completion:^(BOOL finished) {
//                        
//                    }];
//                }
//                    break;
//                case 1:
//                {
//                    [UIView animateWithDuration:1 delay:0.16f usingSpringWithDamping:0.4f initialSpringVelocity:1.0f options:UIViewAnimationOptionCurveEaseInOut animations:^{
//                        button.frame = CGRectMake(view.frame.origin.x, view.frame.origin.y +400, view.frame.size.width, view.frame.size.height);
//                    } completion:^(BOOL finished) {
//                        
//                    }];
//                }
//                    break;
//                case 2:
//                {
//                    [UIView animateWithDuration:1 delay:0.12f usingSpringWithDamping:0.4f initialSpringVelocity:1.0f options:UIViewAnimationOptionCurveEaseInOut animations:^{
//                        button.frame = CGRectMake(view.frame.origin.x, view.frame.origin.y +400, view.frame.size.width, view.frame.size.height);
//                    } completion:^(BOOL finished) {
//                        
//                    }];
//                }
//                    break;
//                case 3:
//                {
//                    [UIView animateWithDuration:1 delay:0.08f usingSpringWithDamping:0.4f initialSpringVelocity:1.0f options:UIViewAnimationOptionCurveEaseInOut animations:^{
//                        button.frame = CGRectMake(view.frame.origin.x, view.frame.origin.y +400, view.frame.size.width, view.frame.size.height);
//                    } completion:^(BOOL finished) {
//                        
//                    }];
//                }
//                    break;
//                case 4:
//                {
//                    [UIView animateWithDuration:1 delay:0.04f usingSpringWithDamping:0.4f initialSpringVelocity:1.0f options:UIViewAnimationOptionCurveEaseInOut animations:^{
//                        button.frame = CGRectMake(view.frame.origin.x, view.frame.origin.y +400, view.frame.size.width, view.frame.size.height);
//                    } completion:^(BOOL finished) {
//                        
//                    }];
//                }
//                    break;
//                case 5:
//                {
//                    [UIView animateWithDuration:1 delay:0.f usingSpringWithDamping:0.4f initialSpringVelocity:1.0f options:UIViewAnimationOptionCurveEaseInOut animations:^{
//                        button.frame = CGRectMake(view.frame.origin.x, view.frame.origin.y +400, view.frame.size.width, view.frame.size.height);
//                    } completion:^(BOOL finished) {
//                        
//                    }];
//                }
//                    break;
//                    
//                default:
//                    break;
//            }
//        }
//    }
}

-(void)turnOnLed:(bool)update
{
    
    AVCaptureDevice *device=[AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
    
    if ([device hasTorch])
    {
        [device lockForConfiguration:nil];
        [device setTorchMode:AVCaptureTorchModeOn];
        [device unlockForConfiguration];
    }
   
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma  PKPaymentAuthorizationViewControllerDelegate
- (void)paymentAuthorizationViewController:(PKPaymentAuthorizationViewController *)controller
                       didAuthorizePayment:(PKPayment *)payment
                                completion:(void (^)(PKPaymentAuthorizationStatus status))completion {
    
    NSLog(@"Payment was authorized: %@", payment);
    BOOL asyncSuccessful = FALSE;
    if(asyncSuccessful) {
        completion(PKPaymentAuthorizationStatusSuccess);
        
        NSLog(@"Payment was successful");
        
    } else {
        completion(PKPaymentAuthorizationStatusFailure);
        
        
        
        NSLog(@"Payment was unsuccessful");
        
    }
    
    
}



- (void)paymentAuthorizationViewControllerDidFinish:(PKPaymentAuthorizationViewController *)controller {
    
    NSLog(@"Finishing payment view controller");
    
    // hide the payment window
    [controller dismissViewControllerAnimated:TRUE completion:nil];
    
}




//- (void)viewDidLoad
//{
//    [super viewDidLoad];
//    UIButton *btn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
//    [btn setFrame:CGRectMake(80, 150, 100, 80)];
//    [btn addTarget:self action:@selector(btnClicked) forControlEvents:UIControlEventTouchUpInside];
//    [self.view addSubview:btn];
//    
//    //AVCaptureDevice代表抽象的硬件设备
//    // 找到一个合适的AVCaptureDevice
//    self.device = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
//    if (![self.device hasTorch]) {//判断是否有闪光灯
//        UIAlertView *alter = [[UIAlertView alloc]initWithTitle:@"提示" message:@"当前设备没有闪光灯，不能提供手电筒功能" delegate:nil cancelButtonTitle:@"Cancel" otherButtonTitles:nil, nil];
//        [alter show];
//     
//    }
//    
//    self.isLightOn = NO;
//    
//}
//
//-(void)btnClicked
//{
//    self.isLightOn = 1-self.isLightOn;
//    if (self.isLightOn) {
//        [self turnOnLed:YES];
//    }else{
//        [self turnOffLed:YES];
//    }
//}
//
////打开手电筒
//-(void) turnOnLed:(bool)update
//{
//    [self.device lockForConfiguration:nil];
//    [self.device setTorchMode:AVCaptureTorchModeOn];
//    [self.device unlockForConfiguration];
//}
//
////关闭手电筒
//-(void) turnOffLed:(bool)update
//{
//    [self.device lockForConfiguration:nil];
//    [self.device setTorchMode: AVCaptureTorchModeOff];
//    [self.device unlockForConfiguration];
//}
@end
