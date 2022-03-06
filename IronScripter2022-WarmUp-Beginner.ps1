<#
Directions:

Write PowerShell code to take a string like ‘PowerShell’ and display it in reverse.
Your solution can be a simple script or function.
#>

Function Get-Inverse {
    [CmdletBinding()]
    param (
        [string[]]$Value
    )

    $Value = $Value.ToCharArray()
    [array]::Reverse($Value)

    Return -join($Value)
}

Get-Inverse -Value "PowerShell"
