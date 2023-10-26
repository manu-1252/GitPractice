// Use .apex files to store anonymous Apex.
// You can execute anonymous Apex in VS Code by selecting the
//     apex text and running the command:
//     SFDX: Execute Anonymous Apex with Currently Selected Text
// You can also execute the entire file by running the command:
//     SFDX: Execute Anonymous Apex with Editor Contents

Id tempvar = 'a1Q56000009aK2AEAU';
System.debug(tempvar.getSObjectType().getDescribe().getName());
System.debug('My name is ' + tempvar);