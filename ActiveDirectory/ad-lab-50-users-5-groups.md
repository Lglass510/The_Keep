[← Active Directory labs](./README.md)

# AD Lab: 50 Users and 5 Security Groups

> **Status: evidence pending.** I ran this lab before the [bulk onboarding lab](./README.md). Screenshots and output from that session aren't in this repository yet, so this page only records what the lab covered. It will be filled in from the evidence, not from memory.

## What the lab covered

- 50 user accounts created in Active Directory
- 5 security groups, with those users assigned as members

That is the whole claim until the evidence below is added. Group names, OU layout, the method used (ADUC, PowerShell, CSV import) and any problems hit along the way will be written up from the screenshots.

## Evidence to add

Any one of these from the domain where the lab ran:

1. **User count:** `(Get-ADUser -Filter * -SearchBase "<OU the 50 users are in>").Count`
2. **Groups and member counts:**

   ```powershell
   Get-ADGroup -Filter * -SearchBase "<OU the 5 groups are in>" |
       ForEach-Object { [pscustomobject]@{ Group = $_.Name; Members = (Get-ADGroupMember $_).Count } } |
       Format-Table -AutoSize
   ```

3. **ADUC screenshot** of the OU that holds the 5 groups, plus one group's **Members** tab
4. The CSV or script used to create the accounts, if it still exists

If the VM is gone, a screenshot taken during the original session works too.

## Related

- [Domain build](./domain-build.md)
- [Bulk onboarding: 206-record CSV, 10 managers, 2 groups](./README.md)
