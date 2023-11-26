. ./RecasterMan.ps1
. ./FFmpegMan.ps1

function TestRecasterMan() {
    $man = [RecasterMan]::New("http://localhost:5001/api/SocialRecaster")
    #$man.ListRecast()
    $man.AddLoadTest(10, "rtmp://slab-live.sliq.net/LoadTest", 1)
    #$man.ListLoadTest()
    $man.DeleteLoadTest()
}

function TestFFmpegMan() {
    $man = [FFmpegMan]::New()
    #$man.ListFFmpeg()
    #$man.StopFFmpeg()
    $man.StartLoadTest(1)
    #$man.ListFFmpeg()
}

#-BaseUrl "http://s-app-recast-5x:5000"
#DoLoadTest -verb list