@echo off
setlocal

echo Fetching upstream...
git fetch upstream
if errorlevel 1 (
    echo ERROR: git fetch upstream failed
    goto :fail
)

echo.
echo Switching to dev...
git checkout dev
if errorlevel 1 (
    echo ERROR: git checkout dev failed
    goto :fail
)

echo.
echo Merging upstream/dev into dev...
git merge upstream/dev
if errorlevel 1 (
    echo ERROR: git merge upstream/dev failed
    goto :merge_fail
)

echo.
echo Pushing dev to origin...
git push origin dev
if errorlevel 1 (
    echo ERROR: git push origin dev failed
    goto :fail
)

echo.
echo Switching to max-custom-dev...
git checkout max-custom-dev
if errorlevel 1 (
    echo ERROR: git checkout max-custom-dev failed
    goto :fail
)

echo.
echo Merging dev into max-custom-dev...
git merge dev
if errorlevel 1 (
    echo ERROR: git merge dev failed
    goto :merge_fail
)

echo.
echo Pushing max-custom-dev to origin...
git push origin max-custom-dev
if errorlevel 1 (
    echo ERROR: git push origin max-custom-dev failed
    goto :fail
)

echo.
echo Done.
goto :end

:merge_fail
echo.
echo Merge failed. You probably have a conflict to resolve.
echo After fixing conflicts, run:
echo   git add .
echo   git merge --continue
echo.
echo To back out of the current merge, run:
echo   git merge --abort
goto :end

:fail
echo.
echo Command failed. Check the Git output above.
goto :end

:end
endlocal
pause