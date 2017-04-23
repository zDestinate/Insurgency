# Insurgency
These are sourcemod plugins for insurgency.<br>
Remember these are public plugins. There are some private one I don't share yet...<br>
Also mostly these plugins are for Coop Server.

 * <a href='#cmap-102'>CMap (1.0.2)</a>
 * <a href='#botcount-101'>Botcount (1.0.1)</a>
 * <a href='#limit-smoke-102'>Limit Smoke (1.0.2)</a>
 * <a href='#bot-flashbang-101'>Bot Flashbang (1.0.1)</a>
 * <a href='#spawn-protection-100'>Spawn Protection (1.0.0)</a><br><br>
 


### CMap (1.0.2)
CMap is use to change map. It a really simple plugin. I made this because someone saying the sm_map off from sourcemod not working in insurgency.<br>
Admins with flag b will able to use this command.<br>

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
(This is a reharsh version from jared ballou coop lobby overwrite)<br><br>

**Note:** When you first load your server, the plugin might not work. You will have to change map or reload the map one time to have it start working.<br>

#### Plugin
[plugins/botcount.smx](https://github.com/zWolfi/Insurgency/blob/master/plugins/botcount.smx?raw=true)

#### Source
[scripting/botcount.sp](https://github.com/zWolfi/Insurgency/blob/master/scripting/botcount.sp)


### Limit Smoke (1.0.2)
This is use to limit the amount of smoke player can carry. I made this one when I run vanilla server. It really useful for server that running COOP and not using custom theater.<br>
The reason I made this is to prevent player from abusing the smoke grenades making bots just standing still.<br>
Config file for this plugin will also auto create on run. It will locate in your cfg/sourcemod folder.<br>

#### Plugin
[plugins/limit_smoke.smx](https://github.com/zWolfi/Insurgency/blob/master/plugins/limit_smoke.smx?raw=true)

#### Source
[scripting/limit_smoke.sp](https://github.com/zWolfi/Insurgency/blob/master/scripting/limit_smoke.sp)

#### Command List
```
sm_ins_limit_smoke_enabled 1 (sets whether limit smoke are enabled)
sm_ins_limit_smoke_amount 1 (amount of smoke that player can bring at a time)
```


### Bot Flashbang (1.0.1)
This also for coop vanilla server that don't use custom theater file.<br>

What exactly this do?<br>
Basically it replace the bot smoke grenade into a flashbang grenade.<br>
If bot keep throwing smokes, players will just camp in the smoke. Bot won't able to see players but players able to see bot in smoke.<br>
Instead of throwing smokes giving player handicap, you make them throw flashbang.<br>

#### Plugin
[plugins/bot_flashbang.smx](https://github.com/zWolfi/Insurgency/blob/master/plugins/bot_flashbang.smx?raw=true)

#### Source
[scripting/bot_flashbang.sp](https://github.com/zWolfi/Insurgency/blob/master/scripting/bot_flashbang.sp)


### Spawn Protection (1.0.0)
This spawn protection plugin will prevent player from taking any damage right away after they spawn. Obviously, you know what exactly it do.<br>
Usually before the round start, there is a timer count down. But you also spawn before the round start. So the spawn protection will start count down. However, this plugin will add that count down timer to the spawn protection timer to prevent your spawn protection timer from running out before the round start.<br>

This also work for Coop. You don't have to worry about the bot going to have spawn protection because they won't!

#### Plugin
[plugins/SpawnProtection.smx](https://github.com/zWolfi/Insurgency/blob/master/plugins/SpawnProtection.smx?raw=true)

#### Source
[scripting/SpawnProtection.sp](https://github.com/zWolfi/Insurgency/blob/master/scripting/SpawnProtection.sp)
