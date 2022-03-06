<#
Directions:

Once you’ve accomplished the intermediate-level task, create a PowerShell script to display a WPF form.
The form should have a place where the user can enter a plaintext or encoded string and then buttons to
encode or decode. The encoded or decoded value should be displayed in the form and copied to the clipboard.
For bonus points, toggle upper and lower case when reversing the word. For example, ‘Shell’ should become ‘LLEHs.’
#>

# Form Global Variables
$font = "Arial"
$font10 = 10
$font14 = 14

# Enable GUI
Add-Type -AssemblyName System.Windows.Forms
[System.Windows.Forms.Application]::EnableVisualStyles()

$components = @(
    # WinForm
    @{Control = "Form"; SizeX = 302; SizeY = 260; BorderStyle = "FixedDialog"; VarName = "wf_Reverse"; Text = ""; StartPos = "CenterScreen"; Top = $false; }
    # Label
    @{Control = "Label"; Font = $font; FontSize = $font14; LocX = 60; LocY = 15;  VarName = "lb_Title"; Text = "String Manipulator"; Form = "wf_Reverse"; }
    # TextBox
    @{Control = "TextBox"; Font = $font; FontSize = $font10; LocX = 8; LocY = 80; SizeX = 270; SizeY = 20; VarName = "tb_Input"; MLine = $false; ReadOnly = $false; ScrollBar = "None"; Form = "wf_Reverse"; }
    @{Control = "TextBox"; Font = $font; FontSize = $font10; LocX = 8; LocY = 143; SizeX = 270; SizeY = 70; VarName = "tb_Output"; MLine = $true; ReadOnly = $true; ScrollBar = "Vertical"; Form = "wf_Reverse"; }
    # Button
    @{Control = "Button"; Font = $font; FontSize = $font10; LocX = 90; LocY = 108; SizeX = 120; SizeY = 30; VarName = "btn_ED"; Text = "Encode\Decode"; Form = "wf_Reverse"; }
    # CheckBox
    @{Control = "CheckBox"; Font = $font; FontSize = $font10; LocX = 8; LocY = 60; VarName = "cb_Switch"; Text = "UpperToLower\LowerToUpper"; Form = "wf_Reverse"; }
)

ForEach ($cp in $components) {
    # Create GUI components
    Switch ($cp.Control) {
        "Form" {
            Set-Variable -Name $cp.VarName -Value $(
                New-Object System.Windows.Forms.Form -Property @{
                    Size            = New-Object System.Drawing.Size($cp.SizeX,$cp.SizeY)
                    Text            = $cp.Text
                    FormBorderStyle = $cp.BorderStyle
                    StartPosition   = $cp.StartPos
                    TopMost         = $cp.Top
            })
            Break
        }
        "Label" {
            Set-Variable -Name $cp.VarName -Value $(
                New-Object System.Windows.Forms.Label -Property @{
                    Location    = New-Object System.Drawing.Point($cp.LocX,$cp.LocY)
                    Font        = New-Object System.Drawing.Font($cp.Font,$cp.FontSize)
                    Text        = $cp.Text
                    AutoSize    = $true
            })
            Break
        }
        "TextBox" {
            Set-Variable -Name $cp.VarName -Value $(
                New-Object System.Windows.Forms.TextBox -Property @{
                    Location    = New-Object System.Drawing.Point($cp.LocX,$cp.LocY)
                    Size        = New-Object System.Drawing.Size($cp.SizeX,$cp.SizeY)
                    Font        = New-Object System.Drawing.Font($cp.Font,$cp.FontSize)
                    Multiline   = $cp.MLine
                    ReadOnly    = $cp.ReadOnly
                    ScrollBars  = $cp.ScrollBar
            })
            Break
        }
        "Button" {
            Set-Variable -Name $cp.VarName -Value $(
                New-Object System.Windows.Forms.Button -Property @{
                    Location     = New-Object System.Drawing.Point($cp.LocX,$cp.LocY)
                    Font         = New-Object System.Drawing.Font($cp.Font,$cp.FontSize)
                    Size         = New-Object System.Drawing.Size($cp.SizeX,$cp.SizeY)
                    Image        = $cp.Image
                    Text         = $cp.Text
            })
            Break
        }
        "CheckBox" {
            Set-Variable -Name $cp.VarName -Value $(
                New-Object System.Windows.Forms.CheckBox -Property @{
                    Location    = New-Object System.Drawing.Point($cp.LocX,$cp.LocY)
                    Font        = New-Object System.Drawing.Font($cp.Font,$cp.FontSize)
                    Text        = $cp.Text
                    AutoSize    = $true
            })
            Break
        }
        Default { Break }
    }

    # Add compenents to specified forms
    Switch ($cp.Control) {
        "Form" {
            Break
        }
        Default {
            ((Get-Variable $cp.Form).Value).Controls.Add($(Get-Variable $cp.VarName).Value)
            Break
        }
    }
}

######################### EVENTS #########################
## Button Events #####################
$btn_ED.Add_Click({
    ButtonPress
})

Function ButtonPress {
    $u_input = $tb_Input.Text

    If ($cb_Switch.Checked) {
        $u_input = InverseLetters -Value $u_input
    }

    $output = $u_input | Get-Inverse
    $output | Set-Clipboard
    $tb_Output.Text = "$output`r`nCopied to clipboard!"
}

Function InverseLetters {
    [CmdletBinding()]
    param (
        [Parameter(ValueFromPipeline)]
        [string[]]$Value
    )

    $inverse = ""
    $Value = $Value.ToCharArray()
    ForEach ($letter in $Value) {
        If ($letter -cmatch "[A-Z]") {
            $letter = $letter.ToLower()
        } ElseIf ($letter -cmatch "[a-z]") {
            $letter = $letter.ToUpper()
        }

        $inverse += $letter
    }

    Return $inverse
}

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

[void]$wf_Reverse.ShowDialog()