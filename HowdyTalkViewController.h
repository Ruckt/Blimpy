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


//Look this up:   UI pressed gesture recognizer


@interface HowdyTalkViewController : UIViewController <AVAudioRecorderDelegate, AVAudioPlayerDelegate>

@property (nonatomic, weak) id<AudioNoteRecorderDelegate> delegate;
@property (nonatomic, copy) AudioNoteRecorderFinishBlock finishedBlock;


- (IBAction)howdyButtonPressed:(UIButton *)sender;
- (IBAction)playBackButtonPressed:(UIButton *)sender;
@property (weak, nonatomic) IBOutlet UILabel *recordingLengthLabel;






@end



