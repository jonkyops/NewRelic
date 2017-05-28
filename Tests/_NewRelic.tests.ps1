$ModuleRoot = Resolve-Path "$PSScriptRoot\..\$ENV:BHProjectName"
$ModuleName = Split-Path $ModuleRoot -Leaf

Describe "General project validation: $ModuleName" {

    $Scripts = Get-ChildItem $ModuleRoot -Include *.ps1, *.psm1, *.psd1 -Recurse

    # TestCases are splatted to the script so we need hashtables
    $TestCase = $Scripts | ForEach-Object { @{file = $_} }         
    It "Script <file> should be valid powershell" -TestCases $TestCase {
        param($File)

        $File.fullname | Should Exist

        $Contents = Get-Content -Path $File.fullname -ErrorAction Stop
        $Errors = $null
        $null = [System.Management.Automation.PSParser]::Tokenize($Contents, [ref]$Errors)
        $Errors.Count | Should Be 0
    }

    It "Module '$ModuleName' can import cleanly" {
        { Import-Module (Join-Path $ModuleRoot "$ModuleName.psm1") -Force } | Should Not Throw
    }
}
