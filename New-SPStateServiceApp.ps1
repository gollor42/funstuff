#############################################################################
# Name: New-SPStateServiceApp.ps1
# Author: Rob Zook
# Company: University of Kansas Hospital
# Description: Creates a new State Service Application for workflows and applications
#############################################################################
[CmdletBinding()]
param([string]$name, [switch]$help)

function GetHelp() {


$HelpText = @"

NAME: New-SPStateServiceApp
DESCRIPTION: Does some stuff

PARAMETERS: 
-name			Name of New State Service


SYNTAX:

New-SPStateServiceApp -Name "Basic State Service Application"

Creates a new State Service Application for workflows and applications.

New-SPStateServiceApp -help

Displays the help topic for the script

"@
$HelpText

}

function New-SPStateServiceApp([string] $Name)
{
	"Creating new State Service: ["+$Name+"]"
	$serviceApp = New-SPStateServiceApplication -Name $Name
	"Creating database for new State Service: ["+$Name+"]"
	$hostName = [System.Net.Dns]::GetHostName()
	$dbName = "SP_"+$hostName+"_"+$Name.Replace(" ","")+"_DB"
	New-SPStateServiceDatabase -Name $dbName -ServiceApplication $serviceApp
	"Creating proxy for new State Service: ["+$Name+"]"
	$proxyName = $Name+" AppProxy"
	New-SPStateServiceApplicationProxy -Name $proxyName -ServiceApplication $serviceApp -DefaultProxyGroup
}

if($help) { GetHelp; Continue }
elseif($name)
{
	New-SPStateServiceApp -Name $name
}
else { GetHelp }
