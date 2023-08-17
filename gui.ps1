Add-Type -AssemblyName PresentationFramework
[void][Reflection.Assembly]::LoadWithPartialName('Microsoft.VisualBasic')
$path = [Microsoft.VisualBasic.Interaction]::InputBox('Enter platform-tools path: ', 'Android Hard Bricker')
$isValidPath = Test-Path -Path $path
if ($isValidPath -ne $true) {
    [System.Windows.MessageBox]::Show('Invalid platform-tools path!', 'Error!', 'OK', 'Error')
}
else {
    if ([System.Windows.MessageBox]::Show('Are you sure you want to brick th', 'ARE YOU SURE!', 'YesNo', 'Warning') -eq 'Yes') {
        
    }
}
