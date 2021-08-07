# GIFphyCat


 Using Giphy API  created an application which allows users to search, view, and favourite gifs. 
A Giphy API framework and a demo client that shows trending and search results of GIFs.

Go to https://developers.giphy.com and set up an app, and grab your API key.
In APIKey.swift, add your key.

The demo app requires iOS 10.3 or later to run.

Technologies

This app uses the following technologies:

- Swift 5

NSURLSession and NSURLSessionTask for data downloading and minimal caching
ImageIO.framework for loading GIF images from NSData, for display in UIImageView
UICollectionView and UIImageView for display



- Architecture

The app follows basic MVVM principles. 



Technical Challenges

Communicating with Giphy API

Giphy's API is "stringly typed." So there are a couple of challenges here. First, accessing the API in a structured way. I accomplish this by implementing several model classes and enums in a framework called GiphyKit. (An original name, no doubt.) It has just enough of the API modeled to complete the interview prompt, but for expediency, I omitted the meta and pagination related classes.

One neat thing about GIFphyCat is that it uses Swift enums to model several of the stringly typed enums. This lets us to things like add computed properties to help parse out the JSON keys by file type. (This in turn makes for some more-readable and more maintainable code.)

To avoid the runtime cost of instantiating NSDateFormatters for each GIF, GIFphyCat creates one constant date formatter and keeps it around.

Asynchronous Loading

The GIFs in this app come from the network, and as such, take time to download. Rather than blocking the main thread, I use NSURLSession to grab the data from the network asynchronously. When the data comes back, it's important to check if the cell that we loaded the image for is still onscreen.

Caching

I actually started building a seperate framework for caching but realized that URLSession has what I was building baked right in. So, I turned it on, by switching from URLSession.shared to URLSession.default. The other change necessary to get this working correctly was to configure the session's cache policy to try the cache before the network.

Knowing Which GIF to Render

The Giphy API has a bunch of what it calls "renditions." That is, as many as two dozen versions of the same image in several image formats and file sizes. The premise is that if you know what file format you need, and Giphy has one that that matches, or is at least pretty close, you can optimize for performance or storage space.

In this sample app, I tried loading the originals, but they were very large, and with a few searches my image usage hit over a gig of RAM. (Remember, the default URLSession cache keeps a copy of data in memory for as long as possible, so this is probably a good optimization point.)

I switched to the rendition called "preview_GIF" which supplies a nice and small version of the animations. I'm not happy with the image quality, but this is a compromise I'm making for expediency as well.

Rendering GIFs

There were three options for this:

1. ImageIO and Framerate Trickery

Apple shipped some sample code for animated GIFs with iOS 11, but I didn't see it until after I implemented it myself. I based my code on Rob Mayoff's Objective-C code and Arne Bahlo's Swift implementation. (Bahlo's Swift port led me to ImageIO, and Mayoff's original. I started with the ImageIO docs, and then referenced Mayoff's code for variable framerate support.) Mayoff bases his variable framerate support on Diego Peinador's implementation, which has a pretty cool algorithm:

Get the greatest common divisor of each of the frames' durations.
Use that as the image view's playback speed.
For frames that have longer framerates, repeat as necessary, so that the frame stays on screen for longer.
One downside to this approach is memory usage: We're creating copies of the frames to pad the playback time. This also requires more work at runtime to calculate the GCD, generate the padded frames, etc.

2. NSTimer and ImageIO

An alternative approach that was suggested to me on a Slack channel, is to just keep the a single copy of the frame images, and use an NSTimer to iterate the frames "manually."

3. AVPlayerLayer and MP4

Initially, I had actually considered using AVPlayerLayer to display the mp4 version of the GIFs. Once I started going down that route, I saw that MP4 wasn't going to be faster than rendering GIFs. Additionally, there's no guarantee that any specific rendition of the GIF supports mp4, and a service for GIFs is more likely to include GIFs in each "rendition." Finally, it felt like cheating. Animating MP4s isn't animating GIFs.




# Screenshots and Video


https://user-images.githubusercontent.com/70209068/128614703-4a2e6536-08ac-4777-aebc-977a87e412d6.mp4

![Simulator Screen Shot - iPhone 12 Pro - 2021-08-07 at 16 57 48](https://user-images.githubusercontent.com/70209068/128614157-ddbc9de4-9077-4a33-bc04-43c8b91c593a.png)
![Simulator Screen Shot - iPhone 12 Pro - 2021-08-07 at 16 58 37](https://user-images.githubusercontent.com/70209068/128614159-e921649a-ce49-468d-adc7-e70ce42483a0.png)
![Simulator Screen Shot - iPhone 12 Pro - 2021-08-07 at 16 58 56](https://user-images.githubusercontent.com/70209068/128614162-f846e92b-e170-4a04-b144-8dfa74dc8372.png)
