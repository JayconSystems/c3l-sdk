# C3 Listener Firmwares

## First time setup

1. Fetch or Build the Container

    ~~~
    docker build -t c3l-sdk
    docker run -it --rm -v $PWD:/home/openwrt/openwrt c3l-sdk
    ~~~
   *or*

   `docker run -it --rm -v $PWD:/home/openwrt/openwrt jayconsystems/c3l-sdk`

2. Initialize the container (only needed the first time)

    ~~~
    ./scripts/feeds update -a
    ./scripts/feeds install bluez-libs expat glib2 dbus c3listener libical
    ~~~~
	
3. Select a build target
    
    `cp whitebox.config .config`
   
    *or*
   
    `cp chiwawa.config .config`
   
4. Build
    ~~~
    make defconfig
    make
    ~~~

## Subsequent Use

1. Start container

    `docker run -it --rm -v $PWD:/home/openwrt/openwrt c3l-sdk`

2. Update c3 software 

   `./scripts/feeds update -a`
   
3. Build

   `make`
   
## Openwrt Update

~~~ 
git pull git://git.openwrt.org/openwrt.git master`
git rebase master`
~~~

*fix any CONFLICTS*

`make`
