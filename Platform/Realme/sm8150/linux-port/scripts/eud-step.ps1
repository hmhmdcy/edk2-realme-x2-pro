param([string]$Port, [string]$Hex = '', [int]$Repeat = 1,
      [int]$Seconds = 20, [string]$Out, [string]$Ack = '')
$ErrorActionPreference = 'Stop'
$sp = [System.IO.Ports.SerialPort]::new($Port,115200,'None',8,'One')
$sp.ReadTimeout = 100
$sp.WriteTimeout = 500
$sp.DtrEnable = $true
$sp.RtsEnable = $true
$raw = [System.IO.File]::Open($Out, 'Create', 'Write', 'Read')
try {
    $sp.Open()
    $frame = [byte[]]@($Hex.Split(' ', [System.StringSplitOptions]::RemoveEmptyEntries) |
        ForEach-Object { [Convert]::ToByte($_,16) })
    $timer = [System.Diagnostics.Stopwatch]::StartNew()
    $sent = 0
    $ackedAt = $null
    $pending = [System.Collections.Generic.List[byte]]::new()
    $decoded = [System.Text.StringBuilder]::new()
    while ($timer.Elapsed.TotalSeconds -lt $Seconds) {
        $available = $sp.BytesToRead
        if ($available -gt 0) {
            $buf = [byte[]]::new($available)
            $n = $sp.Read($buf,0,$available)
            $raw.Write($buf,0,$n)
            $raw.Flush()
            $pending.AddRange([byte[]]$buf[0..($n-1)])
            while ($pending.Count -ge 2) {
                $length = [int]$pending[1]
                if ($pending[0] -ne 0x90 -or $length -eq 0 -or $length -gt 64) {
                    $pending.RemoveAt(0)
                    continue
                }
                if ($pending.Count -lt $length + 2) { break }
                [void]$decoded.Append([System.Text.Encoding]::ASCII.GetString(
                    $pending.GetRange(2,$length).ToArray()))
                $pending.RemoveRange(0,$length+2)
            }
            if ($Ack -and $sent -gt 0 -and $null -eq $ackedAt -and
                $decoded.ToString().Contains($Ack)) {
                Write-Output "ACK: $Ack; stop retries"
                $ackedAt = $timer.ElapsedMilliseconds
                $sent = $Repeat
            }
        }
        if ($null -ne $ackedAt -and $timer.ElapsedMilliseconds -ge $ackedAt + 2000) { break }
        if ($frame.Length -gt 0 -and $sent -lt $Repeat -and
            $timer.Elapsed.TotalSeconds -ge (3 + 3 * $sent)) {
            if ($sent -eq 0) { [void]$decoded.Clear() }
            $sp.Write($frame,0,$frame.Length)
            $sp.BaseStream.Flush()
            $sent++
            Write-Output "TX $sent at $($timer.ElapsedMilliseconds)ms: $Hex"
        }
        Start-Sleep -Milliseconds 5
    }
} finally {
    try { if ($sp.IsOpen) { $sp.Close() } } finally {
        $sp.Dispose()
        $raw.Dispose()
    }
    Write-Output "Closed $Port; capture $Out"
}
