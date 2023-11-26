. ./RecasterMan.ps1 
. ./FFmpegMan.ps1


#$ApiBaseUrl="http://s-app-recast-5x:5000/api/SocialRecaster"
$ApiBaseUrl="http://localhost:5001/api/SocialRecaster"
function StartYoutube() {
    $man = [RecasterMan]::New($ApiBaseUrl)

    $sinks=@(
        "rtmp://youtube_url", #youbute url
        "rtmp://facebook_url"  #facebook url
    )
    $man.AddRecast("TestYoutube", "rtmp://localhost/Recast/TestStream", $sinks)    

    $ffmpeg = [FFmpegMan]::New()
    $ffmpeg.StartFFmpeg("TestStream")
}

function StopYoutube() {
    $man = [RecasterMan]::New($ApiBaseUrl)
    $list = $man.ListRecast()
    foreach($item in $list) {
        if ($item.name -eq 'TestYoutube') {
            $man.DeleteRecast($item.id)
        }
    }

    $ffmpeg = [FFmpegMan]::New()
    $ffmpeg.StopLoadTest()
}