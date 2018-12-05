function Reset-BuiltinLocalAdmin
{
	param
	(
		[parameter(Position = 0, Mandatory = $true)]
		[string]$username,
		[parameter(Position=1,Mandatory = $true)]
		[string]$password
		
	)
	
	Invoke-Command -ComputerName $computer.name {(net user $username $password)}
}