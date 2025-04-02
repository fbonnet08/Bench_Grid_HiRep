Import-Module BitsTransfer
function My-Copy-File {
    param( $from, $to)
    Write-Host $from
    Write-Host $to
    $fileSize = (Get-Item -Path $from).Length
    $ffile = [io.file]::OpenRead($from)
    #$tofile = [io.file]::OpenWrite($to)
    Write-Progress -Activity "Copying file" -status "$from -> $to" -PercentComplete 0
    $ncount = 3
    try {
        [byte[]]$buff = new-object byte[] 4096
        [long]$total = [int]$count = 0            #Start-Sleep -Seconds 1
        do {
            $count = $ffile.Read($buff, 0, $buff.Length)
            #$tofile.Write($buff, 0, $count)
            $total += $count
            if ($total % 1mb -eq 0) {
                Write-Progress -Activity "Copying file" -status "$from -> $to" `
                   -PercentComplete ([long]($total * 100 / $ffile.Length))
            }
        } while ($count -gt 0) }
    finally {
        #$ffile.Dispose()
        #$tofile.Dispose()
        Write-Progress -Activity "Copying file" -Status "Ready" -Completed
    }
}
################################################################################
# Getting the data from the copymounting the drives
Write-Host "Launching python script ---> Bench_Grid_HiRep.py ..."
################################################################################
# Sombrero plot generation
#start powershell {python .\Bench_Grid_HiRep.py --sombrero_action=Sombrero_weak --simulation_size=small}
#start powershell {python .\Bench_Grid_HiRep.py --sombrero_action=Sombrero_weak --simulation_size=large}
#start powershell {python .\Bench_Grid_HiRep.py --sombrero_action=Sombrero_weak --simulation_size=small-large}

# BKepper plot generation
start powershell {python .\Bench_Grid_HiRep.py --bkeeper_action=BKeeper_run_gpu --simulation_size=small}
start powershell {python .\Bench_Grid_HiRep.py --bkeeper_action=BKeeper_run_gpu --simulation_size=large}
start powershell {python .\Bench_Grid_HiRep.py --bkeeper_action=BKeeper_run_gpu --simulation_size=small-large}

# Waiting for process to finish
#Wait-Process -InputObject $s1
################################################################################
