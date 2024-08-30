param ($targetDirectory, $fileExtension, [int] $deleteFilesOlderThanNDays)

$usageHelp = "Please specify the following parameters:
    -targetDirectory: The directory where the files are located
    -fileExtension: The file extension to be deleted
    -deleteFilesOlderThanNDays: The number of days after which the files will be deleted
    Example: dof.ps1 'C:\targetDirectory' 'tmp' 7"

Write-Output "$targetDirectory $fileExtension $deleteFilesOlderThanNDays"

if ($targetDirectory -eq $null -or $targetDirectory -eq "") {
    Write-Output "Target directory is not specified"
    Write-Output $usageHelp
    return
    return
}

if ($fileExtension -eq $null -or $fileExtension -eq "") {
    Write-Output "File extension is not specified"
    Write-Output $usageHelp
    return
}

if ($deleteFilesOlderThanNDays -eq $null -or $deleteFilesOlderThanNDays -eq "" -or $deleteFilesOlderThanNDays -le 0) {
    Write-Output "Delete files older than N days is not specified"
    Write-Output $usageHelp
    return
}

# Удаление файлов по их расширению, время создания которых больше N дней
# $targetDirectory = "C:\targetDirectory"

# Укажите расширение файлов, которые необходимо удалить
# $fileExtension = "tmp"

# Укажите путь, по которому будут храниться сжатые лог файлы
# $fileExtension = "C:\logarchives"

# Файлы, старше N дней подлежат обработке и последующему удалению
# $deleteFilesOlderThanNDays = 7


# # Поиск файлов с расширением .fileExtension и их последующее удаление
$filesForDeletionArray = Get-ChildItem $targetDirectory -Filter *.$fileExtension | Where-Object { $_.LastWriteTime -lt (Get-Date).AddDays(-$deleteFilesOlderThanNDays) }

$filesRemoved = 0
$filesNotRemoved = 0

foreach ($fileForDelete in $filesForDeletionArray) {
    
    $sourceFileName = Join-Path -Path $fileForDelete.Directory.FullName -ChildPath $fileForDelete

        if (Test-Path -Path $sourceFileName) {
            Write-Output "File  $sourceFileName  ready for removing..."
            try {
                Remove-Item -Path $sourceFileName -Force
                Write-Output "$sourceFileName has been removed"
                $filesRemoved++
            }
            catch {
                Write-Output "Error during file $sourceFileName deletion"
                $filesNotRemoved++
            }
        }
        else {
            Write-Output "File $sourceFileName not found"
        }
    }

Write-Output "Total files removed: $filesRemoved"
Write-Output "Total files not removed: $filesNotRemoved"