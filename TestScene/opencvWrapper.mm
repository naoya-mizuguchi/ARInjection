//
//  opencvWrapper.m
//  TestScene
//
//  Created by Naoya Mizuguchi on 2018/02/28.
//  Copyright © 2018年 Naoya Mizuguchi. All rights reserved.
//

#import <opencv2/opencv.hpp>
#import <opencv2/videoio/cap_ios.h>

#import "opencvWrapper.h"

using namespace cv;
using namespace std;

@interface opencvWrapper() <CvVideoCameraDelegate>{
    CvVideoCamera *cvCamera;
}
@end

@implementation opencvWrapper

//引数 cv::Mat image : カメラの画像を入力
//imageを書き換えれば良さそう?
- (void)processImage:(cv::Mat &)image {
    Mat image_copy;
    image_copy = image.clone();
    
    Mat hsv_image;
    cvtColor(image, hsv_image, CV_BGR2HSV);

    Mat output_img;
    output_img = hsv_image.clone();


    for(int y = 0; y < hsv_image.rows; ++y){
        for(int x = 0; x < hsv_image.cols; ++x){
            if (//H,S,Vそれぞれの範囲指定
                0 <= hsv_image.data[y * hsv_image.step + x * hsv_image.elemSize()] &&
                hsv_image.data[y * hsv_image.step + x * hsv_image.elemSize()] <= 25 &&
                58 <= hsv_image.data[y * hsv_image.step + x * hsv_image.elemSize() + 1]  &&
                hsv_image.data[y * hsv_image.step + x * hsv_image.elemSize() + 1] <= 173 &&
                88 <= hsv_image.data[y * hsv_image.step + x * hsv_image.elemSize() + 2] &&
                hsv_image.data[y * hsv_image.step + x * hsv_image.elemSize() + 2] <= 229
                )
            {
                output_img.data[y * output_img.step + x * output_img.elemSize()] = 0;
                output_img.data[y * output_img.step + x * output_img.elemSize() + 1]= 0;
                output_img.data[y * output_img.step + x * output_img.elemSize() + 2]= 0;
            } else {
                output_img.data[y * output_img.step + x * output_img.elemSize()] = hsv_image.data[ y * hsv_image.step + x * hsv_image.elemSize()];
                output_img.data[y * output_img.step + x * output_img.elemSize() + 1] = hsv_image.data[ y * hsv_image.step + x * hsv_image.elemSize() + 1];
                output_img.data[y * output_img.step + x * output_img.elemSize() + 2] = hsv_image.data[ y * hsv_image.step + x * hsv_image.elemSize() + 2];
            }
        }
    }

    cvtColor(output_img, image, CV_HSV2BGR);
    
}

- (void)createCameraWithParentView:(UIImageView*)parentView{
    cvCamera = [[CvVideoCamera alloc] initWithParentView:parentView];
    
    cvCamera.defaultAVCaptureDevicePosition = AVCaptureDevicePositionBack;
    cvCamera.defaultAVCaptureSessionPreset = AVCaptureSessionPreset640x480;
    cvCamera.defaultAVCaptureVideoOrientation = AVCaptureVideoOrientationPortrait;
    cvCamera.defaultFPS = 30;
    cvCamera.grayscaleMode = NO;
    
    cvCamera.delegate = self;
}

- (void)start {
    [cvCamera start];
}

@end
