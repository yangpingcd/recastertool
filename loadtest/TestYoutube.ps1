<#
Change the TestYoutube.Setting.ps1 if needed

Load TestYoubute.ps1
  . ./TestYoubute.ps1

Start the Youbute
  StartYoubute

Stop the Youbute
  StopYoubute
#>

param(
    [string]$ApiBaseUrl = "http://s-app-recast-5x:5000/api/SocialRecaster", 
    [string]$SourceUrl = "rtmp://localhost/Recast/TestStream", 
    [string[]]$SinkUrls = @("rtmp://youtube_url", "rtmp://facebook_url"),
    
    [string]$DestBase = "rtmp://s-app-recast-5x:1935/Recast",
    [string]$FFmpegPath = "ffmpeg.exe"
)

. ./lib/RecasterMan.ps1 
. ./lib/FFmpegMan.ps1
if (Test-Path -PathType Leaf './TestYoutube.Setting.ps1') {
    . ./TestYoutube.Setting.ps1
}

function GetStreamName() {
    $pos = $SourceUrl.LastIndexOfAny(@('/', '\'))
    if ($pos -gt 0) {
        return $SourceUrl.Substring($pos + 1)
    }
    else {
        return $SourceUrl
    }
}

function StartYoutube() {
    StopYoutube

    $man = [RecasterMan]::New($ApiBaseUrl)
    $man.AddRecast("TestYoutube", $SourceUrl, $SinkUrls) 
    $list = $man.ListRecast()
    foreach ($item in $list) {
        if ($item.name -eq 'TestYoutube') {
            Write-Host "Starting id=$($item.id)"
            $man.StartRecast($item.id) | Out-Null
        }
    }

    $ffmpeg = [FFmpegMan]::New(@{
            DestBase   = $DestBase
            FFmpegPath = $FFmpegPath
        })
    $streamName = GetStreamName
    $ps = $ffmpeg.StartFFmpeg($streamName)
    Write-Host "Started $($ps.CommandLine)"
}

function StopYoutube() {
    $man = [RecasterMan]::New($ApiBaseUrl)
    $list = $man.ListRecast()
    foreach ($item in $list) {
        if ($item.name -eq 'TestYoutube') {
            Write-Host "Deleting id=$($item.id)"
            $man.DeleteRecast($item.id) | Out-Null
        }
    }

    $ffmpeg = [FFmpegMan]::New()
    $streamName = GetStreamName
    $insts = $ffmpeg.ListFFmpeg() | Where-Object { $_.CommandLine -like "*$streamName*" }
    foreach ($inst in $insts) {
        Write-Host "Stopping $($inst.CommandLine)"
        Stop-Process $inst
    }
}
