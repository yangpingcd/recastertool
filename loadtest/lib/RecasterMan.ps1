class RecasterMan
{
    [string]$ApiBaseUrl = "http://localhost:5000/api/SocialRecaster"

    #$Headers = @{accept = 'text/plain' }
    $Headers = @{"Content-Type" = "application/json" }

    RecasterMan() {
    }
    RecasterMan([string]$api_BaseUrl) {
        $this.ApiBaseUrl = $api_BaseUrl.TrimEnd('/')
    }
    
    [object]StartRecast($id) {
        $url = $this.ApiBaseUrl + "/Start/$id"    
        $r = Invoke-RestMethod -Uri $url -Method Put -Headers $this.Headers
        return $r
    }

    [object] StopRecast($id) {
        $url = $this.ApiBaseUrl + "/Stop/$id"    
        $r = Invoke-RestMethod -Uri $url -Method Put -Headers $this.Headers    
        return $r
    }

    [object]ListRecast() {
        $url = $this.ApiBaseUrl + "/List"    
        $r = Invoke-RestMethod -Uri $url -Method Get -Headers $this.Headers
        return $r
    }

    [object] AddRecast($name, $sourceUrl, $sinkUrls) {
        $url = $this.ApiBaseUrl + "/Add"    

        $body = @{
            id     = 0 
            #creationTime= "2023-11-19T14:18:04.684Z", 
            name   = $name
            source = @{
                name = "LoadTestSource"
                url  = $sourceUrl #"rtmp://localhost/Recast/TestStream"
            }
            sinks  = [System.Collections.ArrayList]@(
                #   {
                #     "name": "string",
                #     "url": "string"
                #   }
            )
            #enabled= $true
            #startTime= "2023-11-19T14:18:04.684Z"
            #duration= 0
        }

        foreach ($sinkUrl in $sinkUrls) {
            $sink = @{
                name = "LoadTestSink"
                url  = $sinkUrl
            }
            [void]$body.sinks.Add($sink)
        }

        $body_json = ConvertTo-Json $body
        $r = Invoke-RestMethod -Uri $url -Method Post -Body $body_json -Headers $this.Headers # | ConvertFrom-Json    
        return $r
    }

    [object] DeleteRecast($id) {
        $url = $this.ApiBaseUrl + "/Delete/$id"    
        $r = Invoke-RestMethod -Uri $url -Method Delete -Headers $this.Headers
        #Write-Output $r
        return $r
    }

    [string]_getUrl([string]$pattern, $iSource, $iSink) {        
        return $pattern.Replace("{0}", $iSource).Replace("{1}", $iSink)
    }

    [object] InitLoadTest($count, $sourceUrlPattern, $sinkUrlPattern, $sinkCount) {
        $name = "LoadTest"
                
        $r = @()
        for ($iSource = 1; $iSource -le $count; $iSource++) {
            $sourceUrl = $this._getUrl($sourceUrlPattern, $iSource, 1)
            $sinkUrls = @()
            
            for ($iSink = 1; $iSink -le $sinkCount; $iSink++) {
                $sinkUrls = $sinkUrls + $this._getUrl($sinkUrlPattern, $iSource, $iSink)
            }
            $r = $r + $this.AddRecast($name, $sourceUrl, $sinkUrls)
        }
        return $r
    }

    [object]ListLoadTest() {
        return $this.ListRecast() | Where-Object { $_.Name -eq "LoadTest" }
    }

    StartLoadTest() {
        $list = $this.ListLoadTest()
        foreach ($item in $list) {
            $id = $item.id
            Write-Host "Starting id=$id"
            $this.StartRecast($id)
        }
    }

    StopLoadTest() {
        $list = $this.ListLoadTest()
        foreach ($item in $list) {
            $id = $item.id
            Write-Host "Stopping id=$id"
            $this.StopRecast($id)
        }
    }

    DeleteLoadTest() {
        $list = $this.ListLoadTest()
        foreach ($item in $list) {
            $id = $item.id
            Write-Host "Deleting id=$id"
            $this.DeleteRecast($id)
        }
    }
}
