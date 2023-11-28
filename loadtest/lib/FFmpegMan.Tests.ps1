. ./FFmpegMan.ps1

function TestFFmpegMan() {
    $ffmpeg = [FFmpegMan]::New()
    #$ffmpeg.ListFFmpeg()
    #$ffmpeg.StopFFmpeg()
    $ffmpeg.StartLoadTest(1)
    #$ffmpeg.ListFFmpeg()
}
