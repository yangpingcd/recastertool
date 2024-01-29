<#
Change the TestCase1.Setting.ps1 if needed

Load TestCase1.ps1
  . ./TestCase1.ps1

Init the case1
  InitCase1

Start/Stop the case1 (could run multiple times)
  StartCase1
  StopCase1

Delete the case1
  DeleteCase1
#>

#Requires -Version 7.0
param(
    [int]$Count = 10,
    [string]$SourceUrlPattern = "rtmp://localhost/Recast/TestStream{0}",
    [string]$SinkUrlPattern = "rtmp://slab-live.sliq.net/LoadTest/Stream{0}_{1}",
    [int]$SinkCount = 2,
    [string]$ApiBaseUrl = "http://s-app-recast-5x:5000/api/SocialRecaster",
    [string]$FFmpegOutputPattern = "rtmp://localhost/Recast/TestStream{0}",
    [string]$FFmpegPath = ".\ffmpeg\ffmpeg-6.1-full_build\bin\ffmpeg.exe",
    [string]$Mp4 = ".\media\Media1.mp4"
)

. $PSScriptRoot/lib/RecasterMan.ps1
. $PSScriptRoot/lib/FFmpegMan.ps1
. {
    $settingPath = "$PSScriptRoot/TestCase1.Setting.ps1"
    if (Test-Path -PathType Leaf $settingPath ) {
        . $settingPath 
    }
    Remove-Variable settingPath
}

$man = [RecasterMan]::New($ApiBaseUrl)
$ffmpeg = [FFmpegMan]::New(@{
        OutputPattern = $FFmpegOutputPattern
        FFmpegPath    = $FFmpegPath
        Mp4           = $Mp4
    })

function InitCase1() {
    $man.InitLoadTest($Count, $SourceUrlPattern, $SinkUrlPattern, $SinkCount)
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
