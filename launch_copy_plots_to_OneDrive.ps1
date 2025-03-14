Import-Module BitsTransfer
################################################################################
$f_copy_from = 'C:\cygwin64\home\Frederic\SwanSea\SourceCodes\Bench_Grid_HiRep\Plots'  #"C:\Users\Frederic\Desktop\cuda_12.3.2_546.12_windows.exe"
################################ QNAP-T431P ####################################
$f_copy_to   = 'C:\Users\Frederic\OneDrive - Swansea University\Bench_Grid_HiRep\Plots'
################################################################################
# Getting the data from the copymounting the drives
Write-Host "Launching file copying script --->  rid_HiRep.py ..."
################################################################################
# Check if ddestinmation folder exists
################################################################################
# Ensure the destination directory exists
if (!(Test-Path -Path $f_copy_to)) {
    Write-Host "Destination directory not found. Creating it..."
    New-Item -ItemType Directory -Path $f_copy_to | Out-Null
    Write-Host "Destination directory created: $f_copy_to"
}
################################################################################
# Counting the files in the source folder exit if empty
################################################################################
$files = Get-ChildItem -Path $f_copy_from -File -Recurse
if ($files.Count -eq 0) {
    Write-Host "No files found in $f_copy_from"
    exit
}
################################################################################
# Copying files over
################################################################################
Write-Host "Transfering data to storage OneDrive - Swansea University ..."
Start-Sleep -Seconds 10

# Start of the copying procedure
foreach ($file in $files) {
    $dest = Join-Path -Path $f_copy_to -ChildPath $file.Name
    try {
        Start-BitsTransfer -Source $file.FullName -Destination $dest -Description "Copying $($file.Name)" -DisplayName "$f_copy_from -> $f_copy_to"
        Write-Host "Successfully copied $($file.Name)"
    }
    catch {
        Write-Host "Failed to copy $($file.Name): $_"
    }
}
# once the file copy is done we stop the
#Start-Sleep -Seconds 20
#Get-Process *python|Stop-Process
################################################################################
