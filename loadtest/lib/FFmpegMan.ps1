
class FFmpegMan
{
    [string]$Mp4 = ".\media\Media1.mp4"
    [string]$OutputPattern = "rtmp://s-app-recast-5x:1935/Recast/TestStream{0}"
    [string]$FFmpegPath = "ffmpeg.exe"

    FFmpegMan() {
    }
    FFmpegMan([hashtable]$Info) {
        switch ($Info.Keys) {
            'Mp4' { $this.Mp4 = $Info.Mp4 }
            #'DestBase' { $this.DestBase = $Info.DestBase.TrimEnd('/') }
            'OutputPattern' { $this.OutputPattern = $info.OutputPattern }
            'FFmpegPath' { $this.FFmpegPath = $Info.FFmpegPath } 
        }
    }

    [string]_getOutput($index) {
        $output = $this.OutputPattern.TrimEnd('/').TrimEnd('\')
        return $output.Replace("{0}", $index)
    }
    [object]_getOutputWildcard() {
        $output = $this.OutputPattern.TrimEnd('/').TrimEnd('\')
        return $output.Replace('{0}', '*')
    }    

    [object] StartFFmpeg($output) {        
        Write-Host "Send to $output"
        $argList = "-stream_loop -1 -re -i `"$($this.Mp4)`" -codec copy -f flv $output"
        #Write-Output $argList
        return Start-Process $this.FFmpegPath -ArgumentList $argList -PassThru -WindowStyle Hidden        
    }
        
    [object]ListFFmpeg() {
        return Get-Process | Where-Object { $_.name -like 'ffmpeg*' } 
    }

    [object]ListLoadTest() {
        $outputWildcard=_getOutputWildcard()
        return Get-Process | Where-Object { ($_.name -like 'ffmpeg*') -and ($_.CommandLine -like $outputWildcard) }
    }

    StartLoadTest($count) {
        if ($count -lt 1) {
            $count = 1
        }
            
        1..$count | Foreach-Object { 
            $output = $this._getOutput($_)
            $this.StartFFmpeg($output)
        }
    }

    StopLoadTest() {
        $list = $this.ListLoadTest()
        foreach($item in $list) {
            Write-Host "Stopping $($item.CommandLine)"
            Stop-Process $item
        }
    }    
}

