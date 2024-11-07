# Ensure Active Directory Module is imported
if (-not (Get-Module -ListAvailable -Name ActiveDirectory)) {
    Write-Host "Active Directory module not found. Please install RSAT."
    exit
}

Import-Module ActiveDirectory -ErrorAction Stop

# Define user details
$Username = "Alex"
$Password = ConvertTo-SecureString "bithuby1234" -AsPlainText -Force
$UserOU = "OU=Employees,DC=example,DC=com"
$ManagerEmail = "szymczakpatrykdawid@gmail.com"

try {
    # Create user account
    New-ADUser -Name $Username `
               -AccountPassword $Password `
               -Path $UserOU `
               -Enabled $true `
               -UserPrincipalName "$Username@szymczakpatrykdawidgmail.onmicrosoft.com" `
               -GivenName "Alex" `
               -Surname "Smith" `
               -DisplayName "Alex Smith" `
               -SamAccountName $Username `
               -ChangePasswordAtLogon $true

    Write-Host "User $Username created successfully."

    # Email details
    $SMTPServer = "smtp.gmail.com"
    $SMTPPort = 587
    $SMTPUsername = "szymczakpatrykdawid@gmail.com"
    $SMTPPassword = ConvertTo-SecureString "Dupa1234.!" -AsPlainText -Force  # Use an App Password here
    $Credential = New-Object System.Management.Automation.PSCredential($SMTPUsername, $SMTPPassword)

    $EmailBody = @"
Hello,

A new account for user '$Username' has been created. 
Temporary password: bithuby1234.

Please advise the user to change the password upon first login.

Best regards,
IT Team
"@

    # Send email notification
    Send-MailMessage -To $ManagerEmail `
                     -From $SMTPUsername `
                     -Subject "New Account Created: $Username" `
                     -Body $EmailBody `
                     -SmtpServer $SMTPServer `
                     -Port $SMTPPort `
                     -Credential $Credential `
                     -UseSsl

    Write-Host "Notification email sent to $ManagerEmail."
} catch {
    Write-Error "An error occurred: $_"
}