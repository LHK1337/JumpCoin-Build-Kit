# JumpCoin-Build-Kit

# Required (installed by the script via apt-get)
gcc,
make,
git,
wget,
curl,
(qt4-dev-tools, libqt4-dev, libqt4, qmake)


run with

```
curl https://raw.githubusercontent.com/LHK1337/JumpCoin-Build-Kit/master/build.sh | bash
```


# Optional
enable boost 1.58 compilation:
  edit build.sh ->
    uncomment all lines,
    remove "libboost1.58-all-dev" from line 2
