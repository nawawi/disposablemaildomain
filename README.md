# Disposable E-mail domain

List of Disposable Email domain

## Maintaining List
1. Append new domain into list-raw.txt
2. Sorting duplicate file in list-raw.txt
```console
$ sort -u list-raw.txt > list-raw.temp && mv list-raw.temp list-raw.txt
```
3. Verify list
```console
$ php verifymx.php list-raw.txt new-list.txt
```
4. Replace new-list.txt to list-active.txt
```console
$ mv new-list.txt list-active.txt
```
