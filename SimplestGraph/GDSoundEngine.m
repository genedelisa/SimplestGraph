//
//  GDSoundEngine.m
//  SimplestGraph
//
//  Just a sampler connected to RemoteIO. No mixer. No sounds installed.
//  Plays a sine tone.
//
//  Created by Gene De Lisa on 6/26/12.
//  Copyright (c) 2012 Rockhopper Technologies. All rights reserved.
//

#import <AudioToolbox/AudioToolbox.h>
#import <AVFoundation/AVFoundation.h>
#import <CoreAudio/CoreAudioTypes.h>
#include "GDCoreAudioUtils.h"
#import "GDSoundEngine.h"

@interface GDSoundEngine()

@property (readwrite) AUGraph processingGraph;
@property (readwrite) AUNode samplerNode;
@property (readwrite) AUNode ioNode;
@property (readwrite) AudioUnit samplerUnit;
@property (readwrite) AudioUnit ioUnit;


@end

@implementation GDSoundEngine

@synthesize playing = _playing;
@synthesize processingGraph = _processingGraph;
@synthesize samplerNode = _samplerNode;
@synthesize ioNode = _ioNode;
@synthesize ioUnit = _ioUnit;
@synthesize samplerUnit = _samplerUnit;

- (id) init 
{
    if ( self = [super init] ) {
        [self createAUGraph];
        [self startGraph];
    }
    
    return self;
}

#pragma mark -
#pragma mark Audio setup
- (BOOL) createAUGraph
{
    NSLog(@"Creating the graph");
    
    CheckError(NewAUGraph(&_processingGraph),
			   "NewAUGraph");
    
    // create the sampler
    // for now, just have it play the default sine tone
	AudioComponentDescription cd = {};
	cd.componentType = kAudioUnitType_MusicDevice;
	cd.componentSubType = kAudioUnitSubType_Sampler;
	cd.componentManufacturer = kAudioUnitManufacturer_Apple;
	cd.componentFlags = 0;
	cd.componentFlagsMask = 0;
	CheckError(AUGraphAddNode(self.processingGraph, &cd, &_samplerNode), "AUGraphAddNode");
    
    
    // I/O unit
    AudioComponentDescription iOUnitDescription;
    iOUnitDescription.componentType          = kAudioUnitType_Output;
    iOUnitDescription.componentSubType       = kAudioUnitSubType_RemoteIO;
    iOUnitDescription.componentManufacturer  = kAudioUnitManufacturer_Apple;
    iOUnitDescription.componentFlags         = 0;
    iOUnitDescription.componentFlagsMask     = 0;
    
    CheckError(AUGraphAddNode(self.processingGraph, &iOUnitDescription, &_ioNode), "AUGraphAddNode");
    
    // now do the wiring. The graph needs to be open before you call AUGraphNodeInfo
	CheckError(AUGraphOpen(self.processingGraph), "AUGraphOpen");
    
	CheckError(AUGraphNodeInfo(self.processingGraph, self.samplerNode, NULL, &_samplerUnit), 
               "AUGraphNodeInfo");
    
    CheckError(AUGraphNodeInfo(self.processingGraph, self.ioNode, NULL, &_ioUnit), 
               "AUGraphNodeInfo");
    
    AudioUnitElement ioUnitOutputElement = 0;
    AudioUnitElement samplerOutputElement = 0;
    CheckError(AUGraphConnectNodeInput(self.processingGraph, 
                                       self.samplerNode, samplerOutputElement, // srcnode, inSourceOutputNumber
                                       self.ioNode, ioUnitOutputElement), // destnode, inDestInputNumber
               "AUGraphConnectNodeInput");
    
    
	NSLog (@"AUGraph is configured");
	CAShow(self.processingGraph);
    
    return YES;
}

- (void) startGraph
{
    if (self.processingGraph) {
        // this calls the AudioUnitInitialize function of each AU in the graph.
        // validates the graph's connections and audio data stream formats.
        // propagates stream formats across the connections
        Boolean outIsInitialized;
        CheckError(AUGraphIsInitialized(self.processingGraph,
                                        &outIsInitialized), "AUGraphIsInitialized");
        if(!outIsInitialized)
            CheckError(AUGraphInitialize(self.processingGraph), "AUGraphInitialize");
        
        Boolean isRunning;
        CheckError(AUGraphIsRunning(self.processingGraph,
                                    &isRunning), "AUGraphIsRunning");
        if(!isRunning)
            CheckError(AUGraphStart(self.processingGraph), "AUGraphStart");
        self.playing = YES;
    }
}
- (void) stopAUGraph {
    
    NSLog (@"Stopping audio processing graph");
    Boolean isRunning = false;
    CheckError(AUGraphIsRunning (self.processingGraph, &isRunning), "AUGraphIsRunning");
    
    if (isRunning) {
        CheckError(AUGraphStop(self.processingGraph), "AUGraphStop");
        self.playing = NO;
    }
}

#pragma mark -
#pragma mark Audio control
- (void)playNoteOn:(UInt32)noteNum :(UInt32)velocity 
{
    UInt32 noteCommand = 0x90 | 0;
    NSLog(@"playNoteOn %lu %lu cmd %lx", noteNum, velocity, noteCommand);
	CheckError(MusicDeviceMIDIEvent(self.samplerUnit, noteCommand, noteNum, velocity, 0), "NoteOn");
}

- (void)playNoteOff:(UInt32)noteNum
{
	UInt32 noteCommand = 0x80 | 0;
	CheckError(MusicDeviceMIDIEvent(self.samplerUnit, noteCommand, noteNum, 0, 0), "NoteOff");
}


@end
