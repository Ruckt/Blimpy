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



@class HowdyTalkViewController;

typedef void (^AudioNoteRecorderFinishBlock) (BOOL wasRecordingTaken, NSURL *recordingURL) ;


@protocol AudioNoteRecorderDelegate <NSObject>

- (void) audioNoteRecorderDidCancel:(HowdyTalkViewController *)audioNoteRecorder;
- (void) audioNoteRecorderDidTapDone:(HowdyTalkViewController *)audioNoteRecorder withRecordedURL:(NSURL *) recordedURL;

@end


//UI pressed gesture recognizer


@interface HowdyTalkViewController : UIViewController <AVAudioRecorderDelegate, AVAudioPlayerDelegate>

@property (nonatomic, weak) id<AudioNoteRecorderDelegate> delegate;

@property (nonatomic, copy) AudioNoteRecorderFinishBlock finishedBlock;


- (IBAction)howdyButtonPressed:(UIButton *)sender;
- (IBAction)playBackButtonPressed:(UIButton *)sender;


+ (id) showRecorderWithMasterViewController:(UIViewController *) masterViewController withDelegate:(id<AudioNoteRecorderDelegate>) delegate;
+ (id) showRecorderMasterViewController:(UIViewController *) masterViewController withFinishedBlock:(AudioNoteRecorderFinishBlock) finishedBlock;




@end



