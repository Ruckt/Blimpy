//
//  AudioRecorder.h
//  Howdy
//
//  Created by Edan Lichtenstein on 3/14/14.
//  Copyright (c) 2014 Edan Lichtenstein. All rights reserved.
//

#import <AVFoundation/AVFoundation.h>
#import <Foundation/Foundation.h>


@class AudioNoteRecorderViewController;

typedef void (^AudioNoteRecorderFinishBlock) (BOOL wasRecordingTaken, NSURL *recordingURL) ;


@protocol AudioNoteRecorderDelegate <NSObject>

//- (void) audioNoteRecorderDidCancel:(AudioNoteRecorderViewController *)audioNoteRecorder;
//- (void) audioNoteRecorderDidTapDone:(AudioNoteRecorderViewController *)audioNoteRecorder withRecordedURL:(NSURL *) recordedURL;

@end

@interface AudioRecorder : NSObject <AVAudioRecorderDelegate, AVAudioPlayerDelegate>

@property (nonatomic, weak) id<AudioNoteRecorderDelegate> delegate;

@property (nonatomic, copy) AudioNoteRecorderFinishBlock finishedBlock;


- (void) recordStart:(UIButton *) sender;





@end
