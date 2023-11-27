<#
Load TestCase2.ps1
  . ./TestCase2
  or 
  . ./TestCase2 -ApiBaseUrl1 "http://s-app-recast-5x:5000/api/SocialRecaster" -ApiBaseUrl2 = "http://s-app-recast-5x:5000/api/SocialRecaster"

Init the case1
  InitCase2

Start/Stop the case2 (could run multiple times)
  StartCase2
  StopCase2

Delete the case2
  DeleteCase2
#>

param(
    [int]$Count = 10,
    [int]$SinkCount = 1,
    [string]$SourceUrlPattern1 = "rtmp://localhost/Recast/TestStream{0}",
    [string]$SinkUrlPattern1 = "rtmp://localhost:1935/Recast/TestStream{0}",
    [string]$SourceUrlPattern2 = "rtmp://localhost/Recast/TestStream{0}",
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
    $man1.InitLoadTest(1, $SourceUrlPattern1, $SinkUrlPattern1, $Count)
    $man2.InitLoadTest($Count, $SourceUrlPattern2, $SinkUrlPattern2, $SinkCount)
}

function StartCase2() {
    $man1.StartLoadTest()
    $man2.StartLoadTest()
 
    $ffmpeg.StopLoadTest()
    $ffmpeg.StartLoadTest(1)
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

function CheckWowza() {
    # todo: check the chunklist.m3u8 and media.ts
    foreach ($i in 1..$Count) {
        foreach ($iSink in 1..$SinkCount) { 
            $url = "http://slab-live.sliq.net/LoadTest/Stream${i}_${iSink}/playlist.m3u8"
            #$url
            Invoke-WebRequest $url
        }
    }    
}

