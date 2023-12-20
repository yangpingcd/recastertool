<#
Change the TestCase2.Setting.ps1 if needed

Load TestCase2.ps1
  . ./TestCase2.ps1
  or 
  . ./TestCase2.ps1 -ApiBaseUrl1 "http://s-app-recast-5x:5000/api/SocialRecaster" -ApiBaseUrl2 = "http://s-app-recast-5x:5000/api/SocialRecaster"

Init the case2
  InitCase2

Start/Stop the case2 (could run multiple times)
  StartCase2
  StopCase2

Delete the case2
  DeleteCase2
#>

param(
    [int]$Count = 50,
    [int]$SinkCount = 1,
    [string]$SourceUrlPattern1 = "rtmp://localhost/Recast/TestStream{0}",
    [string]$SinkUrlPattern1 = "rtmp://s-app-recast-5x:1935/Recast/TestStream{1}",
    [string]$SourceUrlPattern2 = "rtmp://localhost/Recast/TestStream{0}",
    [string]$SinkUrlPattern2 = "rtmp://slab-live.sliq.net/LoadTest/Stream{0}_{1}",
    [string]$ApiBaseUrl1 = "http://localhost:5000/api/SocialRecaster",
    [string]$ApiBaseUrl2 = "http://s-app-recast-5x:5000/api/SocialRecaster",
    [string]$FFmpegPath = ".\ffmpeg\ffmpeg-6.1-full_build\bin\ffmpeg.exe"
)

. ./lib/RecasterMan.ps1
. ./lib/FFmpegMan.ps1
if (Test-Path -PathType Leaf './TestCase2.Setting.ps1') {
    . ./TestCase2.Setting.ps1
}


#$ApiBaseUrl1 = "http://s-app-recast-5x:5000/api/SocialRecaster"
#$ApiBaseUrl1 = "http://localhost:5001/api/SocialRecaster"
#$ApiBaseUrl2 = "http://localhost:5001/api/SocialRecaster"

$man1 = [RecasterMan]::New($ApiBaseUrl1)
$man2 = [RecasterMan]::New($ApiBaseUrl2)
$ffmpeg = [FFmpegMan]::New(@{
        #Mp4 = ".\media\Media1.mp4"        
        OutputPattern = $SourceUrlPattern1
        FFmpegPath = $FFmpegPath
    })

function InitCase2() {
    Write-Host "Init the source SocialRecaster ($ApiBaseUrl1)"
    $man1.InitLoadTest(1, $SourceUrlPattern1, $SinkUrlPattern1, $Count)
    Write-Host "Init the target SocialRecaster ($ApiBaseUrl2)"
    $man2.InitLoadTest($Count, $SourceUrlPattern2, $SinkUrlPattern2, $SinkCount)
}

function StartCase2() {
    Write-Host "Starting the source SocialRecaster ($ApiBaseUrl1)"
    $man1.StartLoadTest()
    Write-Host "Starting the target SocialRecaster ($ApiBaseUrl2)"
    $man2.StartLoadTest()
 
    $ffmpeg.StopLoadTest()
    $ffmpeg.StartLoadTest(1)
}

function StopCase2() {
    Write-Host "Stopping the source SocialRecaster ($ApiBaseUrl1)"
    $man1.StopLoadTest()
    Write-Host "Stopping the target SocialRecaster ($ApiBaseUrl2)"
    $man2.StopLoadTest()

    $ffmpeg.StopLoadTest()
}

function DeleteCase2() {
    Write-Host "Delete the source SocialRecaster ($ApiBaseUrl1)"
    $man1.DeleteLoadTest()
    Write-Host "Delete the target SocialRecaster ($ApiBaseUrl2)"
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

