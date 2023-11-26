# 10 ffmpeg + 2 sinks for each stream

param(
    [int]$count = 10,
    [int]$sinkCount = 1,
    [string]$SinkUrlPattern1 = "rtmp://localhost:1935/Recast/TestStream{0}",
    [string]$SinkUrlPattern2 = "rtmp://slab-live.sliq.net/LoadTest/Stream{0}_{1}",
    [string]$ApiBaseUrl1 = "http://localhost:5000/api/SocialRecaster", # "http://localhost:5001/api/SocialRecaster",
    [string]$ApiBaseUrl2 = "http://s-app-recast-5x:5000/api/SocialRecaster" # "http://localhost:5001/api/SocialRecaster"
)

. ./RecasterMan.ps1
. ./FFmpegMan.ps1

#$ApiBaseUrl1 = "http://s-app-recast-5x:5000/api/SocialRecaster"
#$ApiBaseUrl1 = "http://localhost:5001/api/SocialRecaster"
#$ApiBaseUrl2 = "http://localhost:5001/api/SocialRecaster"

$man1 = [RecasterMan]::New($ApiBaseUrl1)
$man2 = [RecasterMan]::New($ApiBaseUrl2)
$ffmpeg = [FFmpegMan]::New(@{
        #Mp4 = ".\media\Media1.mp4"
        DestBase = "rtmp://localhost:1935/Recast"
        #FFmpeg = ".\ffmpeg\ffmpeg-6.1-full_build\bin\ffmpeg.exe"
    })

function InitCase2() {
    $man1.InitLoadTest(1, $SinkUrlPattern1, $count)
    $man2.InitLoadTest($count, $SinkUrlPattern2, $sinkCount)
}

function StartCase2() {
    $man1.StartLoadTest()
    $man2.StartLoadTest()
 
    $ffmpeg.StopLoadTest()
    $ffmpeg.StartLoadTest($Count)
}

function StopCase2() {
    $man1.StopLoadTest()
    $man2.StopLoadTest()

    $ffmpeg.StopLoadTest()
}

function DeleteCase2() {
    $man1.DeleteLoadTest()
    $man2.DeleteLoadTest()

    $ffmpeg.StopLoadTest()
}

<# 
#-BaseUrl "http://s-app-recast-5x:5000"
#DoLoadTest -verb list


# Create 10 recast jobs
. ./RecasterMan.ps1 -BaseUrl "http://s-app-recast-5x:5000"
#ListLoadTest
AddLoadTest -count $count -sinkBase "rtmp://slab-live.sliq.net/LoadTest" -sinkCount $sinkCount
StartLoadTest

# Start 10 ffmpeg instances
. ./FfmpegMan.ps1 -destBase "rtmp://s-app-recast-5x:1935/Recast/"
StartFfmpeg -count $count

# Check the wowza
foreach ($i in 1..$count) {
    foreach ($iSink in 1..$sinkCount) { 
        $url = "http://slab-live.sliq.net/LoadTest/Stream${i}_${iSink}/playlist.m3u8"
        echo $url
        #Invoke-WebRequest $url
    }
}
 #>