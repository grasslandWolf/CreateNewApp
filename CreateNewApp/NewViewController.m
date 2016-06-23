//
//  NewViewController.m
//  CreateNewApp
//
//  Created by MAC Mini on 16/3/7.
//  Copyright © 2016年 test. All rights reserved.
//

#import "NewViewController.h"




@interface NewViewController ()

@property (nonatomic ,strong) UIImageView * zoomView;

@end

@implementation NewViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self setup];
    
    
}

-(void)setup {


}
-(void)bindModel {



    UITapGestureRecognizer *tapClothesImageView = [[UITapGestureRecognizer alloc]init];
    [self.zoomView addGestureRecognizer:tapClothesImageView];
    [tapClothesImageView addTarget:self action:@selector(touchUpAndDown)];
    
    
    
  
}

-(void)touchUpAndDown:(UITapGestureRecognizer *)gesture {

//    JTSImageInfo *imageInfo = [[JTSImageInfo alloc] init];
//    imageInfo.referenceContentMode = self.zoomView.contentMode;
//    imageInfo.image = self.zoomView.image;
//    imageInfo.referenceRect = self.zoomView.frame;
//    imageInfo.referenceView = self.zoomView.superview;
//    
//    // Setup view controller
//    JTSImageViewController *imageViewer = [[JTSImageViewController alloc]
//                                           initWithImageInfo:imageInfo
//                                           mode:JTSImageViewControllerMode_Image
//                                           backgroundStyle:JTSImageViewControllerBackgroundOption_Scaled];
//    
//    // Present the view controller.
//    [imageViewer showFromViewController:self transition:JTSImageViewControllerTransition_FromOriginalPosition];

}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)dismiss:(id)sender {
    [self dismissViewControllerAnimated:YES completion:^{
        
    }];
}

-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {

    [self.view endEditing:YES];
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
