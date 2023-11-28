
class FFmpegMan
{
    [string]$Mp4 = ".\media\Media1.mp4"
    [string]$DestBase = "rtmp://s-app-recast-5x:1935/Recast"
    [string]$FFmpegPath = ".\ffmpeg\ffmpeg-6.1-full_build\bin\ffmpeg.exe"

    FFmpegMan() {        
    }
    FFmpegMan([hashtable]$Info) {
        switch ($Info.Keys) {
            'Mp4' { $this.Mp4 = $Info.Mp4 }
            'DestBase' { $this.DestBase = $Info.DestBase.TrimEnd('/') }
            'FFmpegPath' { $this.FFmpegPath = $Info.FFmpegPath } 
        }
    }

    [object] StartFFmpeg($streamName) {
        $dest = $this.DestBase + "/$streamName"
    
        Write-Host "Send to $dest"
        $argList = "-stream_loop -1 -re -i `"$($this.Mp4)`" -codec copy -f flv $dest"
        #Write-Output $argList
        return Start-Process $this.FFmpegPath -ArgumentList $argList -PassThru -WindowStyle Hidden        
    }
        
    [object]ListFFmpeg() {
        return Get-Process | Where-Object { $_.name -like 'ffmpeg*' } 
    }

    [object]ListLoadTest() {
        return Get-Process | Where-Object { ($_.name -like 'ffmpeg*') -and ($_.CommandLine -like '*TestStream*') }
    }

    StartLoadTest($count) {
        if ($count -lt 1) {
            $count = 1
        }
            
        1..$count | Foreach-Object { $this.StartFFmpeg("TestStream$_") }
    }

    StopLoadTest() {
        $list = $this.ListLoadTest()
        foreach($item in $list) {
            Write-Host "Stopping $($item.CommandLine)"
            Stop-Process $item
        }
    }    
}
