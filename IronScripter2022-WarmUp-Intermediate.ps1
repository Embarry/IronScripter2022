<#
Directions:

Your challenge is based on the Beginner exercise. Take a sentence like,
“This is how you can improve your PowerShell skills,” and write PowerShell code
to display the entire sentence in reverse with each word reversed. You should be
able to encode and decode text. Ideally, your functions should take pipeline input.
#>

Function Get-Inverse {
    [CmdletBinding()]
    param (
        [Parameter(ValueFromPipeline)]
        [string[]]$Value
    )

    $Value = $Value.ToCharArray()
    [array]::Reverse($Value)

    Return -join($Value)
}

$output = “This is how you can improve your PowerShell skills,” | Get-Inverse
Write-Output $output

$output = $output | Get-Inverse
Write-Output $output