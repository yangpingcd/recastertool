# https://pester.dev/docs/quick-start
 
BeforeAll {
    . $PSScriptRoot/RecasterMan.ps1
    $settingPath = "$PSScriptRoot/RecasterMan.Tests.Setting.ps1"
    if (Test-Path -PathType Leaf $settingPath) {
        . $settingPath
    }
    Remove-Variable -Name settingPath
}

Describe 'TestPattern' {
    It 'Pattern should be replaced' {
        $man = $man = [RecasterMan]::New()
        $pattern = "rtmp://slab-live.sliq.net/LoadTest/Stream{0}_{1}"
        $result =$man._getUrl($pattern, 5, 10)
        $result | Should -Be "rtmp://slab-live.sliq.net/LoadTest/Stream5_10"
    }
}

function TestRecasterMan() {
    $man = [RecasterMan]::New("http://localhost:5001/api/SocialRecaster")
    #$man.ListRecast()
    $man.AddLoadTest(10, "rtmp://slab-live.sliq.net/LoadTest", 1)
    #$man.ListLoadTest()
    $man.DeleteLoadTest()
}
