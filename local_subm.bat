@echo off

python %SystemDrive%\work\anaceo\Trisconta\gitsubs.py d

echo.
echo Updating all from 'master' branch:
git submodule foreach --recursive "(git remote -v ; git checkout master; git pull; echo ___^; echo ...)"
