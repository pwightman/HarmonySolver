//
//  StaffView.m
//  HarmonySolver
//
//  Created by Parker Wightman on 2/28/15.
//  Copyright (c) 2015 Alora Studios. All rights reserved.
//

#import "StaffView.h"

@implementation StaffView

// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    //// Group
    {
        //// Bezier Drawing
        UIBezierPath* bezierPath = [UIBezierPath bezierPath];
        [bezierPath moveToPoint: CGPointMake(49.9, 19.5)];
        [bezierPath addCurveToPoint: CGPointMake(49.1, 27.7) controlPoint1: CGPointMake(49.9, 22.3) controlPoint2: CGPointMake(49.6, 25.1)];
        [bezierPath addCurveToPoint: CGPointMake(45.8, 37.2) controlPoint1: CGPointMake(48.4, 31.2) controlPoint2: CGPointMake(47.3, 34.4)];
        [bezierPath addCurveToPoint: CGPointMake(38.4, 46.1) controlPoint1: CGPointMake(43.9, 40.7) controlPoint2: CGPointMake(41.5, 43.6)];
        [bezierPath addLineToPoint: CGPointMake(40.4, 56.5)];
        [bezierPath addCurveToPoint: CGPointMake(44, 56.2) controlPoint1: CGPointMake(41.7, 56.3) controlPoint2: CGPointMake(42.9, 56.2)];
        [bezierPath addCurveToPoint: CGPointMake(53.5, 59.2) controlPoint1: CGPointMake(47.7, 56.2) controlPoint2: CGPointMake(50.8, 57.2)];
        [bezierPath addCurveToPoint: CGPointMake(58.8, 66.4) controlPoint1: CGPointMake(55.8, 61) controlPoint2: CGPointMake(57.6, 63.4)];
        [bezierPath addCurveToPoint: CGPointMake(60.5, 75.2) controlPoint1: CGPointMake(59.9, 69.2) controlPoint2: CGPointMake(60.5, 72.1)];
        [bezierPath addCurveToPoint: CGPointMake(56.7, 85.2) controlPoint1: CGPointMake(60.5, 79.1) controlPoint2: CGPointMake(59.2, 82.4)];
        [bezierPath addCurveToPoint: CGPointMake(47, 90.6) controlPoint1: CGPointMake(54.3, 87.9) controlPoint2: CGPointMake(51, 89.7)];
        [bezierPath addLineToPoint: CGPointMake(49.7, 106)];
        [bezierPath addCurveToPoint: CGPointMake(49.8, 106.9) controlPoint1: CGPointMake(49.8, 106.3) controlPoint2: CGPointMake(49.8, 106.6)];
        [bezierPath addCurveToPoint: CGPointMake(49.8, 107.9) controlPoint1: CGPointMake(49.8, 107.2) controlPoint2: CGPointMake(49.8, 107.5)];
        [bezierPath addCurveToPoint: CGPointMake(46.6, 115.3) controlPoint1: CGPointMake(49.8, 110.7) controlPoint2: CGPointMake(48.7, 113.2)];
        [bezierPath addCurveToPoint: CGPointMake(39.1, 119.3) controlPoint1: CGPointMake(44.6, 117.3) controlPoint2: CGPointMake(42.1, 118.7)];
        [bezierPath addCurveToPoint: CGPointMake(37, 119.5) controlPoint1: CGPointMake(38.4, 119.4) controlPoint2: CGPointMake(37.8, 119.5)];
        [bezierPath addCurveToPoint: CGPointMake(29.1, 115.9) controlPoint1: CGPointMake(34.1, 119.5) controlPoint2: CGPointMake(31.5, 118.3)];
        [bezierPath addCurveToPoint: CGPointMake(25.8, 108.8) controlPoint1: CGPointMake(26.9, 113.6) controlPoint2: CGPointMake(25.8, 111.3)];
        [bezierPath addCurveToPoint: CGPointMake(25.9, 107.7) controlPoint1: CGPointMake(25.8, 108.4) controlPoint2: CGPointMake(25.8, 108.1)];
        [bezierPath addCurveToPoint: CGPointMake(28.6, 103) controlPoint1: CGPointMake(26.3, 105.8) controlPoint2: CGPointMake(27.2, 104.2)];
        [bezierPath addCurveToPoint: CGPointMake(33.6, 101.2) controlPoint1: CGPointMake(30, 101.8) controlPoint2: CGPointMake(31.7, 101.2)];
        [bezierPath addCurveToPoint: CGPointMake(38.6, 103.1) controlPoint1: CGPointMake(35.5, 101.2) controlPoint2: CGPointMake(37.2, 101.8)];
        [bezierPath addCurveToPoint: CGPointMake(40.7, 107.9) controlPoint1: CGPointMake(40, 104.4) controlPoint2: CGPointMake(40.7, 106)];
        [bezierPath addCurveToPoint: CGPointMake(38.7, 113.1) controlPoint1: CGPointMake(40.7, 109.9) controlPoint2: CGPointMake(40, 111.6)];
        [bezierPath addCurveToPoint: CGPointMake(33.7, 115.3) controlPoint1: CGPointMake(37.4, 114.6) controlPoint2: CGPointMake(35.7, 115.3)];
        [bezierPath addCurveToPoint: CGPointMake(33.3, 115.3) controlPoint1: CGPointMake(33.5, 115.3) controlPoint2: CGPointMake(33.4, 115.3)];
        [bezierPath addCurveToPoint: CGPointMake(32.6, 115.3) controlPoint1: CGPointMake(33.2, 115.3) controlPoint2: CGPointMake(32.9, 115.3)];
        [bezierPath addCurveToPoint: CGPointMake(35.5, 117.3) controlPoint1: CGPointMake(33.5, 116.2) controlPoint2: CGPointMake(34.5, 116.8)];
        [bezierPath addCurveToPoint: CGPointMake(38.4, 118) controlPoint1: CGPointMake(36.5, 117.7) controlPoint2: CGPointMake(37.5, 118)];
        [bezierPath addCurveToPoint: CGPointMake(39.4, 117.9) controlPoint1: CGPointMake(38.7, 118) controlPoint2: CGPointMake(39, 118)];
        [bezierPath addCurveToPoint: CGPointMake(41.8, 117) controlPoint1: CGPointMake(39.8, 117.9) controlPoint2: CGPointMake(40.6, 117.5)];
        [bezierPath addCurveToPoint: CGPointMake(46.1, 113.8) controlPoint1: CGPointMake(43.6, 116.1) controlPoint2: CGPointMake(45, 115.1)];
        [bezierPath addCurveToPoint: CGPointMake(48.3, 107.9) controlPoint1: CGPointMake(47.6, 112.1) controlPoint2: CGPointMake(48.3, 110.1)];
        [bezierPath addCurveToPoint: CGPointMake(48.1, 105.8) controlPoint1: CGPointMake(48.3, 107.3) controlPoint2: CGPointMake(48.2, 106.6)];
        [bezierPath addLineToPoint: CGPointMake(45.4, 91.1)];
        [bezierPath addCurveToPoint: CGPointMake(42.2, 91.6) controlPoint1: CGPointMake(44.3, 91.3) controlPoint2: CGPointMake(43.2, 91.5)];
        [bezierPath addCurveToPoint: CGPointMake(38.6, 91.7) controlPoint1: CGPointMake(41.2, 91.7) controlPoint2: CGPointMake(40, 91.7)];
        [bezierPath addCurveToPoint: CGPointMake(22.1, 84.7) controlPoint1: CGPointMake(32.3, 91.7) controlPoint2: CGPointMake(26.8, 89.4)];
        [bezierPath addCurveToPoint: CGPointMake(15.1, 67.9) controlPoint1: CGPointMake(17.4, 80) controlPoint2: CGPointMake(15.1, 74.4)];
        [bezierPath addCurveToPoint: CGPointMake(20.1, 54.6) controlPoint1: CGPointMake(15.1, 64.3) controlPoint2: CGPointMake(16.8, 59.9)];
        [bezierPath addCurveToPoint: CGPointMake(29.5, 42.6) controlPoint1: CGPointMake(22.5, 50.8) controlPoint2: CGPointMake(25.6, 46.8)];
        [bezierPath addCurveToPoint: CGPointMake(34.9, 37.2) controlPoint1: CGPointMake(32.7, 39.1) controlPoint2: CGPointMake(34.4, 37.4)];
        [bezierPath addCurveToPoint: CGPointMake(33.5, 31.3) controlPoint1: CGPointMake(34.6, 36.4) controlPoint2: CGPointMake(34.1, 34.4)];
        [bezierPath addCurveToPoint: CGPointMake(32.3, 23.8) controlPoint1: CGPointMake(32.9, 28.2) controlPoint2: CGPointMake(32.5, 25.7)];
        [bezierPath addCurveToPoint: CGPointMake(32.2, 21.5) controlPoint1: CGPointMake(32.2, 23.1) controlPoint2: CGPointMake(32.2, 22.4)];
        [bezierPath addCurveToPoint: CGPointMake(35.2, 8.3) controlPoint1: CGPointMake(32.2, 17.1) controlPoint2: CGPointMake(33.2, 12.7)];
        [bezierPath addCurveToPoint: CGPointMake(42.3, 1.1) controlPoint1: CGPointMake(37.3, 3.5) controlPoint2: CGPointMake(39.7, 1.1)];
        [bezierPath addCurveToPoint: CGPointMake(47.5, 7.8) controlPoint1: CGPointMake(44.1, 1.1) controlPoint2: CGPointMake(45.8, 3.3)];
        [bezierPath addCurveToPoint: CGPointMake(49.9, 19.5) controlPoint1: CGPointMake(49.2, 12.2) controlPoint2: CGPointMake(49.9, 16)];
        [bezierPath closePath];
        [bezierPath moveToPoint: CGPointMake(37.2, 47.4)];
        [bezierPath addCurveToPoint: CGPointMake(32.9, 51.6) controlPoint1: CGPointMake(36.5, 47.9) controlPoint2: CGPointMake(35, 49.3)];
        [bezierPath addCurveToPoint: CGPointMake(28.1, 57.2) controlPoint1: CGPointMake(30.8, 53.9) controlPoint2: CGPointMake(29.2, 55.7)];
        [bezierPath addCurveToPoint: CGPointMake(24.9, 61.9) controlPoint1: CGPointMake(26.8, 58.9) controlPoint2: CGPointMake(25.7, 60.4)];
        [bezierPath addCurveToPoint: CGPointMake(22.4, 67.2) controlPoint1: CGPointMake(23.8, 63.7) controlPoint2: CGPointMake(23, 65.4)];
        [bezierPath addCurveToPoint: CGPointMake(21.4, 73) controlPoint1: CGPointMake(21.7, 69.2) controlPoint2: CGPointMake(21.4, 71.1)];
        [bezierPath addCurveToPoint: CGPointMake(22.1, 77.7) controlPoint1: CGPointMake(21.4, 74.6) controlPoint2: CGPointMake(21.6, 76.2)];
        [bezierPath addCurveToPoint: CGPointMake(24.5, 81.9) controlPoint1: CGPointMake(22.4, 78.8) controlPoint2: CGPointMake(23.2, 80.2)];
        [bezierPath addCurveToPoint: CGPointMake(30.5, 87.4) controlPoint1: CGPointMake(26.2, 84.2) controlPoint2: CGPointMake(28.2, 86)];
        [bezierPath addCurveToPoint: CGPointMake(40, 90.1) controlPoint1: CGPointMake(33.5, 89.2) controlPoint2: CGPointMake(36.6, 90.1)];
        [bezierPath addCurveToPoint: CGPointMake(42.7, 89.8) controlPoint1: CGPointMake(41, 90.1) controlPoint2: CGPointMake(41.9, 90)];
        [bezierPath addCurveToPoint: CGPointMake(45.1, 89) controlPoint1: CGPointMake(43.1, 89.7) controlPoint2: CGPointMake(43.9, 89.5)];
        [bezierPath addLineToPoint: CGPointMake(40, 63.6)];
        [bezierPath addCurveToPoint: CGPointMake(32.3, 68.4) controlPoint1: CGPointMake(36.7, 64) controlPoint2: CGPointMake(34.1, 65.6)];
        [bezierPath addCurveToPoint: CGPointMake(30.2, 75.2) controlPoint1: CGPointMake(30.9, 70.6) controlPoint2: CGPointMake(30.2, 72.8)];
        [bezierPath addCurveToPoint: CGPointMake(32.5, 80.8) controlPoint1: CGPointMake(30.2, 77.1) controlPoint2: CGPointMake(31, 79)];
        [bezierPath addCurveToPoint: CGPointMake(37.2, 84.7) controlPoint1: CGPointMake(33.7, 82.3) controlPoint2: CGPointMake(35.3, 83.6)];
        [bezierPath addCurveToPoint: CGPointMake(41, 86.2) controlPoint1: CGPointMake(38.9, 85.7) controlPoint2: CGPointMake(40.1, 86.2)];
        [bezierPath addLineToPoint: CGPointMake(41, 86.9)];
        [bezierPath addCurveToPoint: CGPointMake(36.8, 85.4) controlPoint1: CGPointMake(39.9, 86.8) controlPoint2: CGPointMake(38.5, 86.3)];
        [bezierPath addCurveToPoint: CGPointMake(31.3, 81.4) controlPoint1: CGPointMake(34.7, 84.3) controlPoint2: CGPointMake(32.8, 83)];
        [bezierPath addCurveToPoint: CGPointMake(27.7, 74.8) controlPoint1: CGPointMake(29.4, 79.4) controlPoint2: CGPointMake(28.2, 77.2)];
        [bezierPath addCurveToPoint: CGPointMake(27.4, 71.7) controlPoint1: CGPointMake(27.5, 73.8) controlPoint2: CGPointMake(27.4, 72.8)];
        [bezierPath addCurveToPoint: CGPointMake(30.6, 62.3) controlPoint1: CGPointMake(27.4, 68.2) controlPoint2: CGPointMake(28.5, 65)];
        [bezierPath addCurveToPoint: CGPointMake(39, 56.9) controlPoint1: CGPointMake(32.7, 59.5) controlPoint2: CGPointMake(35.5, 57.7)];
        [bezierPath addLineToPoint: CGPointMake(37.2, 47.4)];
        [bezierPath closePath];
        [bezierPath moveToPoint: CGPointMake(43, 9.5)];
        [bezierPath addCurveToPoint: CGPointMake(38.4, 14.4) controlPoint1: CGPointMake(41.5, 9.5) controlPoint2: CGPointMake(40, 11.1)];
        [bezierPath addCurveToPoint: CGPointMake(35.2, 24.3) controlPoint1: CGPointMake(36.9, 17.4) controlPoint2: CGPointMake(35.8, 20.7)];
        [bezierPath addCurveToPoint: CGPointMake(35.1, 25.6) controlPoint1: CGPointMake(35.1, 24.6) controlPoint2: CGPointMake(35.1, 25.1)];
        [bezierPath addCurveToPoint: CGPointMake(35.6, 31.6) controlPoint1: CGPointMake(35.1, 27.2) controlPoint2: CGPointMake(35.3, 29.2)];
        [bezierPath addCurveToPoint: CGPointMake(36.5, 36.4) controlPoint1: CGPointMake(35.9, 34) controlPoint2: CGPointMake(36.2, 35.6)];
        [bezierPath addLineToPoint: CGPointMake(39, 34.2)];
        [bezierPath addCurveToPoint: CGPointMake(41.4, 31.8) controlPoint1: CGPointMake(39.4, 34) controlPoint2: CGPointMake(40.2, 33.2)];
        [bezierPath addCurveToPoint: CGPointMake(45.3, 26) controlPoint1: CGPointMake(43, 29.9) controlPoint2: CGPointMake(44.3, 27.9)];
        [bezierPath addCurveToPoint: CGPointMake(47.4, 18.2) controlPoint1: CGPointMake(46.7, 23.3) controlPoint2: CGPointMake(47.4, 20.7)];
        [bezierPath addCurveToPoint: CGPointMake(47.4, 17.1) controlPoint1: CGPointMake(47.4, 17.8) controlPoint2: CGPointMake(47.4, 17.5)];
        [bezierPath addCurveToPoint: CGPointMake(47.3, 16) controlPoint1: CGPointMake(47.4, 16.7) controlPoint2: CGPointMake(47.3, 16.4)];
        [bezierPath addCurveToPoint: CGPointMake(46.4, 11.7) controlPoint1: CGPointMake(46.9, 13.7) controlPoint2: CGPointMake(46.6, 12.3)];
        [bezierPath addCurveToPoint: CGPointMake(43, 9.5) controlPoint1: CGPointMake(45.5, 10.2) controlPoint2: CGPointMake(44.5, 9.5)];
        [bezierPath closePath];
        [bezierPath moveToPoint: CGPointMake(46.6, 88.2)];
        [bezierPath addCurveToPoint: CGPointMake(53.6, 83.9) controlPoint1: CGPointMake(49.5, 87.5) controlPoint2: CGPointMake(51.8, 86.1)];
        [bezierPath addCurveToPoint: CGPointMake(56.3, 76.3) controlPoint1: CGPointMake(55.4, 81.7) controlPoint2: CGPointMake(56.3, 79.2)];
        [bezierPath addCurveToPoint: CGPointMake(56.2, 74.8) controlPoint1: CGPointMake(56.3, 75.8) controlPoint2: CGPointMake(56.3, 75.3)];
        [bezierPath addCurveToPoint: CGPointMake(52, 66.6) controlPoint1: CGPointMake(55.8, 71.5) controlPoint2: CGPointMake(54.4, 68.8)];
        [bezierPath addCurveToPoint: CGPointMake(43.6, 63.4) controlPoint1: CGPointMake(49.6, 64.4) controlPoint2: CGPointMake(46.8, 63.4)];
        [bezierPath addCurveToPoint: CGPointMake(43, 63.4) controlPoint1: CGPointMake(43.4, 63.4) controlPoint2: CGPointMake(43.2, 63.4)];
        [bezierPath addCurveToPoint: CGPointMake(41.8, 63.5) controlPoint1: CGPointMake(42.8, 63.4) controlPoint2: CGPointMake(42.4, 63.5)];
        [bezierPath addLineToPoint: CGPointMake(46.6, 88.2)];
        [bezierPath closePath];
        bezierPath.miterLimit = 4;

        [[UIColor blackColor] setFill];
        [bezierPath fill];
    }


    //// Group 2
    {
        //// Bezier 2 Drawing
        UIBezierPath* bezier2Path = [UIBezierPath bezierPath];
        [bezier2Path moveToPoint: CGPointMake(2.3, 27.1)];
        [bezier2Path addLineToPoint: CGPointMake(141.4, 27.1)];
        [bezier2Path addLineToPoint: CGPointMake(141.4, 28.3)];
        [bezier2Path addLineToPoint: CGPointMake(2.3, 28.3)];
        [bezier2Path addLineToPoint: CGPointMake(2.3, 27.1)];
        [bezier2Path closePath];
        [bezier2Path moveToPoint: CGPointMake(2.3, 42.8)];
        [bezier2Path addLineToPoint: CGPointMake(141.4, 42.8)];
        [bezier2Path addLineToPoint: CGPointMake(141.4, 44)];
        [bezier2Path addLineToPoint: CGPointMake(2.3, 44)];
        [bezier2Path addLineToPoint: CGPointMake(2.3, 42.8)];
        [bezier2Path closePath];
        [bezier2Path moveToPoint: CGPointMake(2.3, 58.8)];
        [bezier2Path addLineToPoint: CGPointMake(141.4, 58.8)];
        [bezier2Path addLineToPoint: CGPointMake(141.4, 60)];
        [bezier2Path addLineToPoint: CGPointMake(2.3, 60)];
        [bezier2Path addLineToPoint: CGPointMake(2.3, 58.8)];
        [bezier2Path closePath];
        [bezier2Path moveToPoint: CGPointMake(2.3, 74.7)];
        [bezier2Path addLineToPoint: CGPointMake(141.4, 74.7)];
        [bezier2Path addLineToPoint: CGPointMake(141.4, 75.9)];
        [bezier2Path addLineToPoint: CGPointMake(2.3, 75.9)];
        [bezier2Path addLineToPoint: CGPointMake(2.3, 74.7)];
        [bezier2Path closePath];
        [bezier2Path moveToPoint: CGPointMake(2.3, 90.6)];
        [bezier2Path addLineToPoint: CGPointMake(141.4, 90.6)];
        [bezier2Path addLineToPoint: CGPointMake(141.4, 91.8)];
        [bezier2Path addLineToPoint: CGPointMake(2.3, 91.8)];
        [bezier2Path addLineToPoint: CGPointMake(2.3, 90.6)];
        [bezier2Path closePath];
        bezier2Path.miterLimit = 4;
        
        [[UIColor blackColor] setFill];
        [bezier2Path fill];
    }
}

@end
