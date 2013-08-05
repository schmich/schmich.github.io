---
layout: post
title: "HTML5 video: Content-Type is important"
---

If you're trying to play HTML5 video with the `<video/>` tag, ensure the correct `Content-Type`
header is being sent for your source media.

Some browsers, such as Chrome, seem willing to play a video regardless of its `Content-Type`
(perhaps through sniffing or file extensions), but others, such as IE, require a valid and supported value.

I ran into this while trying to play videos hosted on S3 with IE10:

{% highlight html %}
<video controls autoplay>
  <source src="http://s3-us-west-1.amazonaws.com/foo/bar.mp4" type="video/mp4" />
</video>
{% endhighlight %}

Even with the `type` attribute set to `video/mp4`, IE refused to play the video, saying only "Invalid Source" or
"Error: Unsupported video type or invalid file path". Some searching yielded
[this blog post](http://blogs.msdn.com/b/thebeebs/archive/2011/07/20/html5-video-not-working-in-ie9-some-tips-to-debug.aspx)
detailing common problems.

The error coming from the video element in IE was `MEDIA_ERR_SRC_NOT_SUPPORTED`. In my case, the source wasn't supported
because the MIME type being sent was not supported.

    $ curl -I http://s3-us-west-1.amazonaws.com/foo/bar.mp4
    HTTP/1.1 200 OK
    Date: Fri, 14 Jun 2013 03:24:53 GMT
    Last-Modified: Fri, 14 Jun 2013 03:24:40 GMT
    Content-Type: application/octet-stream
    Content-Length: 9227881
    Server: AmazonS3
    ...

Apparently after uploading the video, S3 automatically set its `Content-Type` to `application/octet-stream`,
which IE does not support.

This is normally not a problem when serving videos from a web server such as Apache, since the server is usually
configured to send the `Content-Type` header based on the file extension, but many cloud storage services like S3
require you to specify your own metadata.

We were uploading videos using the [AWS Ruby SDK](http://aws.amazon.com/sdkforruby/), so the fix was to simply specify
`:content-type` when uploading the file via
[S3Object#write](http://docs.aws.amazon.com/AWSRubySDK/latest/AWS/S3/S3Object.html#write-instance_method):

{% highlight ruby %}
obj.write(:content_type => 'video/mp4', ...)
{% endhighlight %}

If you need to support a wider range of MIME types, consider using the [mime-types](https://github.com/halostatue/mime-types) gem and `MIME::Types.type_for`.

