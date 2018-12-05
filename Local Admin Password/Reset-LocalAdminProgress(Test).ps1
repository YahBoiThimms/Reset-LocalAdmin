<#	
	.NOTES
	===========================================================================
	 Created with: 	SAPIEN Technologies, Inc., PowerShell Studio 2018 v5.5.155
	 Created on:   	12/4/2018 1:57 PM
	 Created by:   	thimmb
	 Organization: 	
	 Filename:     	
	===========================================================================
	.DESCRIPTION
		Resets the local administrator password on all workstations within a Specific AD OU
#>

$ModuleRoot = $PSScriptRoot

$FunctionList = Get-ChildItem -Path $ModuleRoot\Functions -Filter *.ps1 -Recurse


foreach ($File in $FunctionList)
{
	. $File.FullName
}

$OUPath = (Get-ModuleConfig).OU
$Network = (Get-Moduleconfig).Sitecode
$Computers = Get-ADComputer -Filter * -Searchbase $OUPath
$Position = 0
$Total = $Computers.count


foreach ($computer in $computers)
{
	
	Try
	{
		Invoke-Command -ComputerName $Computer.name -ScriptBlock ('$ModuleRoot\config\netuser.cmd') -ErrorAction Stop
		Write-Progress -Activity "Resetting Local Administrator Passwords on workstations in $Network" -CurrentOperation $computer.name -PercentComplete (($Position/$total) * 100)
		$Position++
	}
	Catch
	{
		$Computer.name | Out-File "$ModuleRoot\FailFile.txt" -append
	}
}