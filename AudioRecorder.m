//
//  AudioRecorder.m
//  Howdy
//
//  Created by Edan Lichtenstein on 3/14/14.
//  Copyright (c) 2014 Edan Lichtenstein. All rights reserved.
//

#import "AudioRecorder.h"

@interface AudioRecorder()



@property (nonatomic, strong) AVAudioRecorder *recorder;
@property (nonatomic, strong) AVAudioPlayer *player;
@property (nonatomic, strong) NSTimer *recordingTimer;
@property (nonatomic, strong) UIView *controlsBg;

@end

@implementation AudioRecorder



- (void) recordStart:(UIButton *) sender
{
    if (sender.selected) {
        // stop
        [self.recorder stop];
        //***UI here for button waiting to be used
      //  _play.enabled = YES;
        [self.recordingTimer invalidate];
        self.recordingTimer = nil;
        NSLog(@"%@", self.recorder.url);
    } else {
        // Start recording
        // UI for button in action here
        
     //   _play.enabled = NO;
        //        NSURL *tmp = [NS]
        
        NSDictionary* recorderSettings = [NSDictionary dictionaryWithObjectsAndKeys:
                                          [NSNumber numberWithInt:kAudioFormatAppleIMA4],AVFormatIDKey,
                                          [NSNumber numberWithInt:44100],AVSampleRateKey,
                                          [NSNumber numberWithInt:1],AVNumberOfChannelsKey,
                                          [NSNumber numberWithInt:16],AVLinearPCMBitDepthKey,
                                          [NSNumber numberWithBool:NO],AVLinearPCMIsBigEndianKey,
                                          [NSNumber numberWithBool:NO],AVLinearPCMIsFloatKey,
                                          nil];
        NSError* error = nil;
        self.recorder = [[AVAudioRecorder alloc] initWithURL:[NSURL URLWithString:[NSTemporaryDirectory() stringByAppendingPathComponent:@"tmp.caf"]]  settings:recorderSettings error:&error];
        
        [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryPlayAndRecord error: nil];
        [[AVAudioSession sharedInstance] setActive: YES error: nil];
        UInt32 doChangeDefault = 1;
        AudioSessionSetProperty(kAudioSessionProperty_OverrideCategoryDefaultToSpeaker, sizeof(doChangeDefault), &doChangeDefault);
        
        self.recorder.delegate = self;
        [self.recorder record];
        self.recordingTimer = [NSTimer scheduledTimerWithTimeInterval:0.1 target:self selector:@selector(recordingTimerUpdate:) userInfo:nil repeats:YES];
        [_recordingTimer fire];
    }
    sender.selected = !sender.selected;
    
}
- (void) playTap:(UIButton *) sender
{
    //    [SimpleAudioPlayer playFile:_recorder.url.description];
    NSError* error = nil;
    
    self.player = [[AVAudioPlayer alloc] initWithContentsOfURL:_recorder.url error:&error];
    _player.volume = 1.0f;
    _player.numberOfLoops = 0;
    _player.delegate = self;
    [_player play];
    NSLog(@"duration: %f", _player.duration);
}


- (void) recordingTimerUpdate:(id) sender
{
    NSLog(@"%f %@", _recorder.currentTime, sender);
   // self.recordLengthLabel.text = [NSString stringWithFormat:@"%.2f", _recorder.currentTime];
}


//- (void) audioPlayerDidFinishPlaying:(AVAudioPlayer *)player successfully:(BOOL)flag
//{
//    NSLog(@"did finish playing %d", flag);
//}
//
//- (void) cancel :(UIButton *)sender
//{
//    if (_recorder == nil || _recorder.isRecording == NO) {
//        [UIView animateWithDuration:0.5 animations:^{
//            _controlsBg.center = CGPointMake(_controlsBg.center.x, _controlsBg.center.y + self.view.frame.size.height);
//        } completion:^(BOOL finished) {
//            [self dismissViewControllerAnimated:YES completion:^{
//                if (self.delegate) {
//                    [self.delegate audioNoteRecorderDidCancel:self];
//                }
//                if (self.finishedBlock) {
//                    self.finishedBlock ( NO, nil );
//                }
//            }];
//        }];
//    }
//}
//- (void) done:(UIButton *) sender
//{
//    if (_recorder && _recorder.isRecording == NO) {
//        
//        [UIView animateWithDuration:0.5 animations:^{
//            _controlsBg.center = CGPointMake(_controlsBg.center.x, _controlsBg.center.y + self.view.frame.size.height);
//        } completion:^(BOOL finished) {
//            [self dismissViewControllerAnimated:YES completion:^{
//                if (self.delegate) {
//                    [self.delegate audioNoteRecorderDidTapDone:self withRecordedURL:_recorder.url];
//                }
//                if (self.finishedBlock) {
//                    self.finishedBlock ( YES, _recorder.url );
//                }
//            }];
//        }];
//    }
//}

@end
