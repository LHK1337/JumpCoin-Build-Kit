# JumpCoin-Build-Kit

# Required (installed by the script via apt-get)
- gcc
- make
- git
- wget
- curl
- (qt4-dev-tools, libqt4-dev, libqt4, qmake)


***Run with***

```
curl https://raw.githubusercontent.com/LHK1337/JumpCoin-Build-Kit/master/build.sh | bash
```
    

# Raspbian image [\[Download\]](https://github.com/LHK1337/JumpCoin-Build-Kit/raw/master/RaspbianStretch_Jumpcoin_051218.tar.xz)
Raspbian (stretch) image with:
- [x] preinstalled/preconfigured jumpcoind, jumpcoin-qt, jumpcoin-cli
- [x] jumpcoind autostart with screen
- [x] dhcp/ssh enabled
- [x] raspbian default creds (pi:raspberry)

Installation:
- Extract img
- burn img to sd
- setup network
- boot pi
- change password ($ passwd)
- run $ raspi-config
- Expand Filesystem
- enjoy
