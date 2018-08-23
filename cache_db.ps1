#Check if SQLite exists
try{write-host "sqlite3.exe version => "-f Yellow -nonewline; sqlite3.exe -version }
catch {
    write-host "It seems that you do not have sqlite3.exe in the system path"
    write-host "Please read below`n" -f Yellow
    write-host "Install SQLite On Windows:`n

        Go to SQLite download page, and download precompiled binaries from Windows section.
        Instructions: http://www.sqlitetutorial.net/download-install-sqlite/
        Create a folder C:\sqlite and unzip above two zipped files in this folder which will give you sqlite3.def, sqlite3.dll and sqlite3.exe files.
        Add C:\sqlite to the system PATH (https://www.architectryan.com/2018/03/17/add-to-the-path-on-windows-10/)" -f White

    exit}

# Show an Open File Dialog 
Function Get-FileName($initialDirectory)
{  
[System.Reflection.Assembly]::LoadWithPartialName("System.windows.forms") |Out-Null
		$OpenFileDialog = New-Object System.Windows.Forms.OpenFileDialog
		$OpenFileDialog.Title = 'Select Skype cache_db.db database to open'
		$OpenFileDialog.initialDirectory = $initialDirectory
		$OpenFileDialog.Filter = "cache_db.db (*.db)|cache_db.db"
		$OpenFileDialog.ShowDialog() | Out-Null
		$OpenFileDialog.ShowReadOnly = $true
		$OpenFileDialog.filename
		$OpenFileDialog.ShowHelp = $false
} #end function Get-FileName 

$dBPath =  $env:userprofile + "\desktop"
$File = Get-FileName -initialDirectory $dBPath


# Run SQLite query of the Selected dB
# The Query (between " " below)
# can also be copy/pasted and run on 'DB Browser for SQLite' 

Try{(Get-Item $File).FullName}
Catch{Write-Host "(cache_db.ps1):" -f Yellow -nonewline; Write-Host " User Cancelled" -f White; exit}
$elapsedTime = [system.diagnostics.stopwatch]::StartNew()    
$swn = [Diagnostics.Stopwatch]::StartNew()

# SQlite Query
$dbn = $File
$sql = 
"
select
Assets.id as 'id',
Assets.key as 'key',
Assets.sub_key as 'sub_key',
assets.lock_count as 'lock_count',
datetime(assets.access_time /10000000, 'unixepoch', 'localtime')  as 'AccessTime',
assets.actual_size as 'actual_size',
assets.reserved_size as 'reserved_size',
assets.type as 'type',
assets.owner as 'owner',
hex(assets.serialized_data) as 'serial'

from  Assets
"

1..1000 | %{write-progress -id 1 -activity "Running SQLite query" -status "$([string]::Format("Time Elapsed: {0:d2}:{1:d2}:{2:d2}", $elapsedTime.Elapsed.hours, $elapsedTime.Elapsed.minutes, $elapsedTime.Elapsed.seconds))" -percentcomplete ($_/100);}

#Run SQLite3.exe with the above query
$dbnresults = @(sqlite3.exe -readonly -separator '**' $dbn $sql |
ConvertFrom-String -Delimiter '\u002A\u002A' -PropertyNames Id, key, sub_key, lock_count, AccessTime, actual_size, reserved_size, type, owner, serial)

$dbncount=$dbnresults.count
$elapsedTime.stop()
#write-progress -id 1 -activity "Running SQLite query" -status "$dbncount Entries - Query Finished" 
$rn=0

#Create Output
$output = @(foreach ($item in $dbnresults ){$rn++
                    Write-Progress -id 2 -Activity "Creating Output" -Status "$rn of $($dbnresults.count))" -PercentComplete (([double]$rn / $dbnresults.count)*100) 
                  
            $s = $item.serial -replace '[\x00-\x22]'    
                  
                  [PSCustomObject]@{
                                ID = $item.ID 
                                Key = $item.key
                                Sub_Key = $item.sub_key
                                Lock_Count = $item.lock_count
                                AccessTime = $item.accesstime
                                Actual_Size = $item.actual_size
                                Reserved_Size = $item.reserved_size
                                Type = $item.type
                                Owner = $item.owner
                                Serial = -join($s -split'(..)'|?{$_}|%{[char]+"0x$_"}) -replace "`0", ""

                                 }
                       
                        } )                             


#Stop Timer2
$swn.stop()           
$Tn = $swn.Elapsed  
$output|Out-GridView -PassThru -Title "There are ($dbncount) Notifications in : '$File' - QueryTime $Tn"
$output|Export-Csv -path "$($env:userprofile)\desktop\cache_db.csv" -Delimiter ","