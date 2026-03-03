# Places
- [Sounds & UI Images](#sounds--ui-images)
  - [packageasset://](#packageasset)
  - [workspaceasset://](#workspaceasset)
# Sounds & UI Images
As a dev whos using this script now, you dont need to use `getcustomasset()` to try to get the file.
<br>
This does not currently work on decals and textures. We will add on those soon.
<br>
The allowed ones currently are Sound, ImageLabel and ImageButton.
<br>
This script uses custom PROTOCOLS.
<br>
There's 2 protocols this mod puts into sounds and ui images.
## packageasset://
`packageasset://` lets you use the assets in packages.
<br>
It works like this in example:
<br>
```lua
ImageLabel.Image = "packageasset://123456/image.png"
```
<br>

To use the packageasset, you need to install a package first. Go to [Codes](/..#codes) to learn how to use the module and look at the packages in the folder [RBLX](/../RBLX) which does not have readme.md. The 6 digits on the last of the name of a file is a package ID.
<br>
## workspaceasset://
`workspaceasset://` lets you use anything in your workspace folder.
<br>
The workspace folder is a folder that is on your computer, which your executor auto creates to save data in exploits.
<br>
It works like this in example:
<br>
```lua
ImageLabel.Image = "workspaceasset://image.png"
```
<br>
I will add more info on the page soon! :D

### Pages
[1](/../../tree/main) 2
