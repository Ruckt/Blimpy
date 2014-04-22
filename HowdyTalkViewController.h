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
#import <OpenEars/PocketsphinxController.h>
#import <OpenEars/AcousticModel.h>
#import <OpenEars/OpenEarsEventsObserver.h>



@class HowdyTalkViewController;

typedef void (^AudioNoteRecorderFinishBlock) (BOOL wasRecordingTaken, NSURL *recordingURL) ;


@interface HowdyTalkViewController : UIViewController <AVAudioRecorderDelegate, AVAudioPlayerDelegate, OpenEarsEventsObserverDelegate>

    
- (IBAction)howdyButtonPressed:(UIButton *)sender;


//@property (weak, nonatomic) IBOutlet UILabel *heardWordList;


@property (weak, nonatomic) IBOutlet UILabel *recordingLengthLabel;
@property (weak, nonatomic) IBOutlet UILabel *statusLabel;


@property (strong, nonatomic) PocketsphinxController *pocketsphinxController;
@property (strong, nonatomic) OpenEarsEventsObserver *openEarsEventsObserver;





@end



