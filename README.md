Simplest Graph
======

Core Audio graph example.

What is Simplest Graph?
---------------
This is an iOS 5 app that will set up an Audio Unit graph with a sampler Audio Unit and a RemoteIO unit.

The audio frobs are all in GDSoundEngine. The UI classes know nothing about any of the audio stuff. The controller gets a cookie to the sound engine and asks it to do any audio tasks.

 The UI is a single button which sends middle C to the engine as a note on message on touch down and a note off message on touch up inside. The pitch is
 specified in the button's tag.

The graph is as simple as possible; the sampler unit feeding directly into the RemoteIO unit. 

The sound played is the default sine wave. In the next project, we'll add a DLS file and/or a SountFont2 bank.

All errors are checked using a modified version of Chris Adamson's CheckError function.
Get his book if you are doing any Core Audio programming. If you're not, then why are you here? :)

License
-------

You may incorporate this code in your own applications.

Attribution is welcomed, but not required.

Copyright (c) 2010-2012 Gene De Lisa. All rights reserved.


Release Notes
-------------

* Latest
Initial release