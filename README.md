# Insurgency
Mod for insurgency sourcemod.

 * <a href='#CMap-102'>CMap (1.0.2)</a>
 * <a href='##botcount-101'>Botcount (1.0.1)</a><br><br>


### CMap (1.0.2)
CMap is use to change map. It a really simple plugin. I made this because someone saying the sm_map off from sourcemod not working in insurgency.<br>
Admins with flag b will able to use this command.

#### Plugin
[plugins/CMap.smx](https://github.com/zWolfi/Insurgency/blob/master/plugins/CMap.smx?raw=true)

#### Source
[scripting/CMap.sp](https://github.com/zWolfi/Insurgency/blob/master/scripting/CMap.sp)

#### Command List
```
cmap <map name> <gamemode>
changemap <map name> <gamemode>
```

#### Example
```
cmap sinjar_coop checkpoint
changemap sinjar_coop checkpoint

cmap sinjar hunt
```


### Botcount (1.0.1)
Botcount plugin is use to fix the coop bot count issue that not scaling with the amount of players in the latest patch.<br>
There is no config file for this.<br>
All you have to do is download and put it in your plugins folder and have it load then it finish.<br>
Would be better if you set `mp_coop_lobbysize` in your `server.cfg` to let this plugin know how many players is going to be in your server. This is just optional.<br>
(This is a reharsh version from jared ballou coop lobby overwrite)<br>

**Note:** When you first load your server, the plugin might not work. You will have to change map or reload the map one time to have it start working.

#### Plugin
[plugins/botcount.smx](https://github.com/zWolfi/Insurgency/blob/master/plugins/botcount.smx?raw=true)

#### Source
[scripting/botcount.sp](https://github.com/zWolfi/Insurgency/blob/master/scripting/botcount.sp)
