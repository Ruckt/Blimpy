//
//  HowdyTalkViewController.h
//  Howdy
//
//  Created by Edan Lichtenstein on 3/3/14.
//  Copyright (c) 2014 Edan Lichtenstein. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>
#import <Foundation/Foundation.h>
#import <AudioToolbox/AudioToolbox.h>



@class HowdyTalkViewController;

typedef void (^AudioNoteRecorderFinishBlock) (BOOL wasRecordingTaken, NSURL *recordingURL) ;


//Look this up:   UI pressed gesture recognizer
// UI activity view controller -


@interface HowdyTalkViewController : UIViewController <AVAudioRecorderDelegate, AVAudioPlayerDelegate>

@property (nonatomic, copy) AudioNoteRecorderFinishBlock finishedBlock;


- (IBAction)howdyButtonPressed:(UIButton *)sender;
- (IBAction)playBackButtonPressed:(UIButton *)sender;

@property (weak, nonatomic) IBOutlet UILabel *recordingLengthLabel;

@property (weak, nonatomic) IBOutlet UILabel *statusLabel;





@end



