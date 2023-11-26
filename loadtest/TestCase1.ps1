<#
Load TestCase1.ps1
  . ./TestCase1
  or 
  . ./TestCase1 -ApiBaseUrl "http://s-app-recast-5x:5000/api/SocialRecaster" -DestBase "rtmp://s-app-recast-5x:1935/Recast"

Init the case1
  InitCase1

Start/Stop the case1 (could run multiple times)
  StartCase1
  StopCase1

Delete the case1
  DeleteCase1
#>

param(
    [int]$Count = 10,
    [string]$SinkUrlPattern = "rtmp://slab-live.sliq.net/LoadTest/Stream{0}_{1}",
    [int]$SinkCount = 2,
    [string]$ApiBaseUrl = "http://s-app-recast-5x:5000/api/SocialRecaster", # "http://localhost:5001/api/SocialRecaster"
    [string]$DestBase = "rtmp://s-app-recast-5x:1935/Recast" #"rtmp://localhost:1935/Recast"
)

. ./RecasterMan.ps1
. ./FFmpegMan.ps1

$man = [RecasterMan]::New($ApiBaseUrl)
$ffmpeg = [FFmpegMan]::New(@{
        #Mp4 = ".\media\Media1.mp4"
        DestBase = $DestBase
        #FFmpeg = ".\ffmpeg\ffmpeg-6.1-full_build\bin\ffmpeg.exe"
    })

function InitCase1() {
    $man.InitLoadTest($Count, $SinkUrl, $SinkCount)
}

function StartCase1() { 
    $man.StartLoadTest()
        
    $ffmpeg.StopLoadTest()
    $ffmpeg.StartLoadTest($Count)    
}

function StopCase1() {
    $man.StopLoadTest()
        
    $ffmpeg.StopLoadTest()
}

function DeleteCase1() {    
    $man.DeleteLoadTest()
    
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
