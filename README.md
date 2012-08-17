chatta-osx
==========

Chatta is a hybrid OS X Text and Instant Messaging Application

* Build Requirements

 * Operating System: OS X 10.8 (Mountain Lion)
 * Development tools: XCode 4.4 and Command Line Tools

* Build Dependences

 * libxml2
 * libtidy

* Build Instructions

 1. Create new directory where you will be storing your build of `chatta-osx`. Open Terminal and type: `mkdir $HOME/projects/ck_project`

 1. Change directories to your newly created folder: `cd %HOME/projects/ck_project `

 1. Clone the `ChattaKit` repo: `git clone git@github.com:crazyideas/ChattaKit.git`

 1. Clone the `chatta-osx` repo: `git clone git@github.com:crazyideas/chatta-osx.git`

 1. Open Xcode, create a new Workspace (`File -> New -> Workspace` give it a name, then save it in `$HOME/projects/ck_project `.

 1. In the Navigator, right click and selected `Add Files to...` and navigate to `$HOME/projects/ck_project/ChattaKit` then select `ChattaKit.xcodeproj` and click `Add`.

 1. Once again right click in the Navigator right click and select `Add Files to...` and navigate to `$HOME/projects/ck_project/chatta-osx` then select `chatta-osx.xcodeproj` and click `Add`.

 1. Select `chatta-osx` and hit `Run`, chatta-osx should build and launch.
