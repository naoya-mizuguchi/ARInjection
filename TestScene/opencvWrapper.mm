//
//  opencvWrapper.m
//  TestScene
//
//  Created by Naoya Mizuguchi on 2018/02/28.
//  Copyright © 2018年 Naoya Mizuguchi. All rights reserved.
//

#import <opencv2/opencv.hpp>
#import <opencv2/videoio/cap_ios.h>
#import <opencv2/imgcodecs/ios.h>

#import "opencvWrapper.h"

using namespace cv;
using namespace std;

Mat metal_image;

@interface opencvWrapper() <CvVideoCameraDelegate>{
    CvVideoCamera *cvCamera;
}
@end

@implementation opencvWrapper
- (void)SetMetalImage:(UIImage*)src{
    UIImageToMat(src, metal_image);
}
//引数 cv::Mat image : カメラの画像を入力
//imageを書き換えれば良さそう?
- (void)processImage:(cv::Mat &)image{
    Mat image_copy;
    Mat tmp_image;

    image_copy = image.clone();

    Mat hsv_image;
    cvtColor(image, hsv_image, CV_BGR2HSV);

    Mat output_img;
    output_img = hsv_image.clone();

    Mat tmp_metal_image;
    resize(metal_image, tmp_metal_image, cv::Size(hsv_image.cols,hsv_image.rows));
    Mat hsv_metal_image;
    cvtColor(tmp_metal_image, hsv_metal_image, CV_BGR2HSV);
    
//    Mat tmp_metal_image = imread("Documents/metal.jpg");
//    Mat metal_image;
//    resize(tmp_metal_image, metal_image, cv::Size(hsv_image.cols,hsv_image.rows));
    
    for(int y = 0; y < hsv_image.rows; ++y){
        for(int x = 0; x < hsv_image.cols; ++x){
//肌色検出したけど難しいっぽい
//            if (//H,S,Vそれぞれの範囲指定
//                ((0 <= hsv_image.data[y * hsv_image.step + x * hsv_image.elemSize()] &&
//                 hsv_image.data[y * hsv_image.step + x * hsv_image.elemSize()] <= 35) ||
//                (150 <= hsv_image.data[y * hsv_image.step + x * hsv_image.elemSize()] &&
//                 hsv_image.data[y * hsv_image.step + x * hsv_image.elemSize()] <= 180)) &&
//                58 <= hsv_image.data[y * hsv_image.step + x * hsv_image.elemSize() + 1]  &&
//                hsv_image.data[y * hsv_image.step + x * hsv_image.elemSize() + 1] <= 255 &&
//                88 <= hsv_image.data[y * hsv_image.step + x * hsv_image.elemSize() + 2] &&
//                hsv_image.data[y * hsv_image.step + x * hsv_image.elemSize() + 2] <= 255
//                )
//白以外の色を取るように変更
            if(50 <= hsv_image.data[y * hsv_image.step + x * hsv_image.elemSize() + 1]  &&
               hsv_image.data[y * hsv_image.step + x * hsv_image.elemSize() + 1] <= 255 &&
               0 <= hsv_image.data[y * hsv_image.step + x * hsv_image.elemSize() + 2] &&
               hsv_image.data[y * hsv_image.step + x * hsv_image.elemSize() + 2] <= 200
                )
            {
//                output_img.data[y * output_img.step + x * output_img.elemSize()] = 0;
//                output_img.data[y * output_img.step + x * output_img.elemSize() + 1]= 0;
//                output_img.data[y * output_img.step + x * output_img.elemSize() + 2]= 0;
                output_img.data[y * output_img.step + x * output_img.elemSize()] = hsv_metal_image.data[y * hsv_metal_image.step + x * hsv_metal_image.elemSize()];
                output_img.data[y * output_img.step + x * output_img.elemSize() + 1]= hsv_metal_image.data[y * hsv_metal_image.step + x * hsv_metal_image.elemSize() + 1];
                output_img.data[y * output_img.step + x * output_img.elemSize() + 2]= hsv_metal_image.data[y * hsv_metal_image.step + x * hsv_metal_image.elemSize() + 2];
            } else {
                output_img.data[y * output_img.step + x * output_img.elemSize()] = hsv_image.data[ y * hsv_image.step + x * hsv_image.elemSize()];
                output_img.data[y * output_img.step + x * output_img.elemSize() + 1] = hsv_image.data[ y * hsv_image.step + x * hsv_image.elemSize() + 1];
                output_img.data[y * output_img.step + x * output_img.elemSize() + 2] = hsv_image.data[ y * hsv_image.step + x * hsv_image.elemSize() + 2];
            }
        }
    }

    cvtColor(output_img, tmp_image, CV_HSV2BGR);

    cvtColor(tmp_image, image, CV_BGR2RGB); //BGRとRGB変換

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
