

# PnP PowerShell
# powershell/documentation/*

function Process-PnPPowerShellDocs
{

    $pnppsDocs = Join-Path -Path $currentLocation -ChildPath "pnp-powershell/documentation"
    Write-Host "Processing PnP PowerShell Path: $($pnppsDocs)"
    $pnppsBaseSitePath = "https://pnp.github.io/powershell/cmdlets"
    $pnppsDocsFiles = Get-ChildItem -Path $pnppsDocs
    $pnppsDocRows = @()

    Write-Host "$($pnppsDocsFiles.Length) found"
    
    $pnppsDocsFiles | Foreach-Object {

        $fileTargetName = $_.Name.Replace(".md",".html")
        $cmdletName = $_.Name.Replace(".md","")

        $cmdHelp = [PSCustomObject]@{
            cmd = $cmdletName
            helpUrl = "$($pnppsBaseSitePath)/$($fileTargetName)"
        }

        $pnppsDocRows += $cmdHelp
    }


    $pnppsDocRows | ConvertTo-Json | Out-File "$($outputPath)\powershell.help.json" -Force

    Write-Host "PnP PowerShell cmdlets documentation generated"
}


# SPO Management Shell
# office-docs-powershell\sharepoint\sharepoint-ps\sharepoint-online
function Process-SPOManagementShellDocs
{

    $spomsDocs = Join-Path -Path $currentLocation -ChildPath "OfficeDocs-SharePoint-PowerShell\sharepoint\sharepoint-ps\Microsoft.Online.SharePoint.PowerShell"
    Write-Host "Processing SPO Management Shell Path: $($spomsDocs)"
    $spomsBaseSitePath = "https://learn.microsoft.com/powershell/module/microsoft.online.sharepoint.powershell"
    $spomsDocsFiles = Get-ChildItem -Path $spomsDocs
    $spomsDocRows = @()

    Write-Host "$($spomsDocsFiles.Length) found"
    
    $spomsDocsFiles | Foreach-Object {

        $cmdletName = $_.Name.Replace(".md","")

        $cmdHelp = [PSCustomObject]@{
            cmd = $cmdletName
            helpUrl = "$($spomsBaseSitePath)/$($cmdletName)"
        }

        $spomsDocRows += $cmdHelp
    }


    $spomsDocRows | ConvertTo-Json | Out-File "$($outputPath)\spoms.help.json" -Force

    Write-Host "SPO Management Shell cmdlets documentation generated"
}

# CLI for Microsoft 365
function Process-CliForM365Docs
{

    $clim365Docs = Join-Path -Path $currentLocation -ChildPath "cli-microsoft365\docs\docs\cmd"
    Write-Host "Processing CLI for Microsoft 365 Path: $($clim365Docs)"
    $clim365BaseSitePath = "https://pnp.github.io/cli-microsoft365/cmd"
    $clim365DocsFiles = Get-ChildItem -Path $clim365Docs -Recurse -Filter *.mdx
    $clim365DocRows = @()

    Write-Host "$($clim365DocsFiles.Length) found"
    
    $clim365DocsFiles | Foreach-Object {

        $parentName = $_.Directory.Parent.Name
        $cmdletName = $_.Name.Replace(".mdx","")
        $cmdletPath = $_.Name.Replace(".mdx","/")
        
        $helpUrl = "$($cmdletPath)"
        $finalCmdName = "m365 $($cmdletName.Replace("-"," "))"

        # Directory
        if($parentName -ne "docs"){
            $helpUrl = "$($parentName)/$($cmdletName)"

            if($cmdletName -like "*-*"){
                $parts = $cmdletName.Split("-")
                $helpUrl = "$($parentName)/$($parts[0])/$($cmdletName)"
            }

            # Cmdlet Name
            if($parentName -eq "cmd"){
                $finalCmdName = "m365 $($cmdletName.Replace("-"," "))"
            }else{
                $finalCmdName = "m365 $($parentName) $($cmdletName.Replace("-"," "))"
            }
        }
        
        $cmdHelp = [PSCustomObject]@{
            cmd = $finalCmdName
            helpUrl = "$($clim365BaseSitePath)/$($helpUrl)".Replace("cmd/cmd","cmd")
        }

        $clim365DocRows += $cmdHelp
    }

    $clim365DocRows | ConvertTo-Json | Out-File "$($outputPath)\cli.help.json" -Force

    Write-Host "CLI for Microsoft 365 cmdlets documentation generated"
}

# For optimatization - only use help where cmdlet is used

# To refresh functions use . .\Get-HelpJson.ps1 in cmd window
$currentLocation = "C:\git\readonly\script-samples-help\"
$outputPath = "$(Get-Location)\assets\help"

Process-PnPPowerShellDocs
Process-SPOManagementShellDocs
Process-CliForM365Docs