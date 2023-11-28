. ./RecasterMan.ps1

function TestRecasterMan() {
    $man = [RecasterMan]::New("http://localhost:5001/api/SocialRecaster")
    #$man.ListRecast()
    $man.AddLoadTest(10, "rtmp://slab-live.sliq.net/LoadTest", 1)
    #$man.ListLoadTest()
    $man.DeleteLoadTest()
}
