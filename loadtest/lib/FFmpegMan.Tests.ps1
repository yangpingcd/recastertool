param(
    $Mp4 = ".\media\Media1.mp4",
    #[string]$DestBase = "rtmp://s-app-recast-5x:1935/Recast"
    $OutputPattern = "rtmp://s-app-recast-5x:1935/Recast/TestStream{0}",
    $FFmpegPath = "ffmpeg.exe"
)

. $PSScriptRoot/FFmpegMan.ps1
$settingPath = "$PSScriptRoot/FFmpegMan.Tests.Setting.ps1"
if (Test-Path -PathType Leaf $settingPath) {
    . $settingPath
}
Remove-Variable -Name settingPath


function TestPattern() {
    $ffmpeg = [FFmpegMan]::New(@{
            $OutputPattern = "rtmp://s-app-recast-5x:1935/Recast/TestStream{0}"
        })

    $ffmpeg._getOutputWildcard()
}
TestPattern

function TestFFmpegMan() {
    $ffmpeg = [FFmpegMan]::New()
    #$ffmpeg.ListFFmpeg()
    #$ffmpeg.StopFFmpeg()
    $ffmpeg.StartLoadTest(1)
    #$ffmpeg.ListFFmpeg()
}
