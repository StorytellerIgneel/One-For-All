# Default target
all: git

# Target to ask for a commit message
ask_for_message:
	@powershell -Command "Write-Host 'Enter commit message: '; $$input = Read-Host; Set-Content -Path commit_message.txt -Value $$input"

# Target to perform git operations
git: ask_for_message
	@powershell -Command "$$commit_message = Get-Content -Path commit_message.txt; git add .; git commit -m '$$commit_message'; git push"
