# https://pester.dev/docs/quick-start

param(
    $Mp4 = ".\media\Media1.mp4",
    #[string]$DestBase = "rtmp://s-app-recast-5x:1935/Recast"
    $OutputPattern = "rtmp://s-app-recast-5x:1935/Recast/TestStream{0}",
    $FFmpegPath = "ffmpeg.exe"
)

BeforeAll {
    . $PSScriptRoot/FFmpegMan.ps1
    $settingPath = "$PSScriptRoot/FFmpegMan.Tests.Setting.ps1"
    if (Test-Path -PathType Leaf $settingPath) {
        . $settingPath
    }
    Remove-Variable -Name settingPath
}

Describe 'TestPattern' {
    It 'Pattern should be replaced' {
        $pattern = "rtmp://s-app-recast-5x:1935/Recast/TestStream{0}"
        $ffmpeg = [FFmpegMan]::New(@{
                $OutputPattern = $pattern
            })

        $result = $ffmpeg._getOutputWildcard()
        #$true | Should -Be $true
        $result | Should -Be "rtmp://s-app-recast-5x:1935/Recast/TestStream*"
    }
}

function TestPattern() {
    $ffmpeg = [FFmpegMan]::New(@{
            $OutputPattern = "rtmp://s-app-recast-5x:1935/Recast/TestStream{0}"
        })

    $ffmpeg._getOutputWildcard()
}


function TestFFmpegMan() {
    $ffmpeg = [FFmpegMan]::New()
    #$ffmpeg.ListFFmpeg()
    #$ffmpeg.StopFFmpeg()
    $ffmpeg.StartLoadTest(1)
    #$ffmpeg.ListFFmpeg()
}
