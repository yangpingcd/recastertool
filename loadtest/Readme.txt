
Load the RecasterMan.ps1
  . ./RecasterMan.ps1
  or
  . ./RecasterMan.ps1 -BaseUrl "http://s-app-recast-5x:5000"

Set ApiBaseUrl if it is not the default "http://localhost/Recast"
  $ApiBaseUrl = "http://s-app-recast-5x:5000/api/SocialRecaster"

The list of the load test functions
  AddLoadTest -count 10 #(count=1)
  ListLoadTest 
  StartLoadTest
  StopLoadTest
  DeleteLoadTest


Load the FfmpegMan.ps1
  . ./FfmpegMan.ps1
Set the mp4 file, destBase (the rtmp server + app name), ffmpeg path
  $mp4 = "C:\Media\test1.mp4"
  $destBase = "rtmp://s-app-recast-5x:1935/Recast/"
  $ffmpeg = "C:\ProgramLocal\ffmpeg-4.3.1-2020-09-21-full_build\bin\ffmpeg.exe"

List the ffmpeg instances
  DoFfmpeg -verb List
Start the ffmpeg
  $times = 10
  DoFfmpeg -verb Start
Stop the ffmpeg
  DoFfmpeg -verb Stop