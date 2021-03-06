# Laevis

Laevis is a simple gzDoom mod, with high compatibility, where your weapons grow more powerful with use.

Based on the damage you do, weapons will gain XP, and upon leveling up, will gain permanent bonuses.

It is designed for maximum compatibility, and supports weapon/enemy replacements and total conversions. It also has special integration with [Lazy Points](https://forum.zdoom.org/viewtopic.php?f=105&t=66565) and [Legendoom](https://forum.zdoom.org/viewtopic.php?t=51035).

Most settings are configurable through the gzDoom options menu and through cvars, so you can adjust things like the level-up rate and the amount of bonus damage to suit your taste.

## Installation & Setup

Add `libtooltipmenu-<version>.pk3` and `Laevis-<version>.pk3` to your load order. It doesn't matter where, as long as `libtooltipmenu` loads first.

The first time you play, check your keybindings for "Laevis - Display Info" and, if you're using Legendoom, "Laevis - Cycle Legendoom Weapon Effect" to make sure they're acceptable. You may also want to check the various settings under "Options - Laevis Mod Options".

That's all -- if equipping a weapon and then pressing the "display info" key (default I) in game brings up the Laevis status screen, you should be good to go.

## Mod Compatibility

This should be compatible with every IWAD and pretty much every mod, including weapon/enemy replacements and total conversions. It relies entirely on event handlers and runtime reflection, so as long as the player's guns are still subclasses of `Weapon` it should behave properly.

It has been tested (although not necessarily extensively) with:
- Doom, Doom 2, Heretic, and Chex Quest
- Ashes 2063
- DoomRL Arsenal
- Hedon Bloodrite
- Hideous Destructor
- LegenDoom & LegenDoomLite
- MetaDoom
- Trailblazer

Some mods have specific integration features or compatibility concerns; these are detailed below.

### Legendoom

If you have Legendoom installed, legendary weapons can gain new Legendoom effects on level up. Only one effect can be active at a time, but you can change effects at any time. Weapons can hold a limited number of effects; if you gain a new effect and there's no room for it, you'll be prompted to choose an effect to delete. (Make sure you choose the effect you want to **get rid of**, not one of the ones you want to keep!)

When using a Legendoom weapon, you can press the "Cycle Legendoom Weapon Effect" key to cycle through effects, or manually select an effect from the "Laevis Info" screen.

There are a lot of settings for this in the mod options, including which weapons can learn effects, how rapidly effects are learned, how many effect slots weapons have, etc. If you want to play with Legendoom installed but turn off integration with Laevis, set `Gun Levels per Legendoom Effect` to 0/Disabled in the settings.

### Score mods (including LazyPoints & MetaDoom)

Laevis has optional integration with mods that award points for actions such as kills. To enable this, turn on `Earn XP based on player score` in the mod settings. As long as it's on, you will earn XP equal to the points you score, rather than equal to the damage you deal. This should work with any mod that uses the `pawn.score` property to record points, but Lazy Points and MetaDoom are the only ones it's actually been tested with.

Laevis is balanced around a rough idea of 1 damage dealt -> 1 XP gained, which score mods don't necessarily follow, so the `XP gain multiplier for score mods` setting is available to tweak the conversion ratio. Recommended settings are:

- **LazyPoints**: 0.4. LP uses the same 1:1 conversion ratio, but awards bonus points for kills, kill combos, items, and secrets, with an additional bonus for kills while above 50% or 100% health.
- **MetaDoom**: 0.2-0.6. This is hard to tune because MD awards points for kills (not damage) in amounts that range from about the same to more than twice as much as you'd get from Laevis or LazyPoints, depending on the enemy. It also awards huge score bonuses (5-10k) for all kills/secrets/items, which in early levels can account for 5-10x as many points as your kills are worth, but become proportionally less valuable as the levels get larger. Set it lower for relatively sparse levels, higher for slaughtermaps.

### Universal Pistol Start

Laevis works by storing upgrade information in an item in the player's inventory. If this item gets removed all of your levels and upgrades will disappear. If you want to lose your weapons but keep your upgrades, make sure that `Keep Inventory Items` is enabled in the UPS settings.

### DoomRL Arsenal

This works fine in general, but building an assembly out of a weapon will reset it to level 0 and clear all upgrades on it, even if the upgrade binding mode is to set to `weapon with inheritance` or `weapon class` (because the assembly is not just a different weapon but an entirely different weapon class from the base weapon you used to assemble it).

## FAQ

### Why "Laevis"?

It's named after *Lepidobatrachus laevis*, aka the Wednesday Frog, which consumes anything smaller than itself and grows more powerful thereby.

I have also considered renaming it "Gun Bonsai".

### What do the upgrades do?

See the end of this file.

### Doesn't this significantly unbalance the game in the player's favour?

Yep! You might want to pair it with a mod like *Champions* or *Colourful Hell* to make things a bit spicier, if, unlike me, you are actually good at Doom. (Or you can pair it with *Russian Overkill*, load up Okuplok, and go nuts.)

### Can I use parts of this in my mod?

Go nuts! It's released under the MIT license; see COPYING.md for details. See also the "modding notes" section.

### Can I add Laevis integration to my mod?

See "modding notes" below.

## Known Issues

- XP is assigned to the currently wielded weapon at the time the damage is dealt, so it possible for XP to be assigned to the wrong weapon if you switch weapons while projectiles are in flight.
- When using Legendoom, it is possible to permanently downgrade (or, in some cases, upgrade) weapons by changing which effect is active on them before dropping them.
- The distinction between projectile and hitscan weapons is guesswork and may in some cases be incorrect.
- Most effects will trigger only on shots that hit a monster, e.g. HE Rounds will not detonate if you shoot a wall.
- Piercing Shots may interfere with the detonation of exploding shots like rockets.
- Upgrade-specific sound effects (at the moment just the HE and fragmentation sounds) may not play when using iwads other than `DOOM2.WAD`.

## Modding Notes

The ZScript files included in this mod are not loadable as-is; they need to be preprocessed with `zspp`, which is included. The easiest way to do this is simply to run `make` and then retrieve the compiled pk3 from the `release` directory. In addition to `make` itself you will need `find` and `luajit` (for the zscript preprocessor) and the ImageMagick `convert` command (to generate the HUD textures).

You can also simply download a release pk3, unzip it, and edit the preprocessed files.

### Reusable Parts

The `GenericMenu`, `StatusDisplay`, and other menu classes are useful examples of how to do dynamic interactive menu creation in ZScript, and how to use a non-interactive OptionsMenu to create a status display.

If you want to use the option menu tooltips, look at [libtooltipmenu](../libtooltipmenu/) instead.

### Adding new Laevis upgrades

See `BaseUpgrade.zs` for detailed instructions. The short form is: you need to subclass `TFLV_Upgrade_BaseUpgrade`, override some virtual methods, and then register your new upgrade class(es) on mod startup, probably in `StaticEventHandler.OnRegister()`.

### Fiddling with Laevis's internal state

Everything you're likely to want to interact with is stored in the `TFLV_PerPlayerStats` (held in the `PlayerPawn`'s inventory) and the `TFLV_WeaponInfo` (one per gun, stored in the PerPlayerStats). Look at the .zs files for those for details on the fields and methods available.

To get the stats, use the static `TFLV_PerPlayerStats.GetStatsFor(pawn)`. The stats are created in the `PlayerSpawned` event, so this should always succeed in normal gameplay unless something has happened to wipe the player's inventory.

Getting weapon info is slightly more complicated; `WeaponInfo` objects are created on-demand, within a tick of the weapon being wielded for the first time, so even if the player is carrying a weapon it may not have an info object. You have a number of options for getting the info object.

These are safe to call from UI code, but can return null:
- `stats.GetInfoForCurrentWeapon()` is fastest but only returns the info for the player's currently equipped weapon.
- `stats.GetInfoFor(wpn)` will get the info for an arbitrary weapon, but only if the info object already exists; it won't return info for a weapon the player has not yet wielded.

This is not UI-safe, but is more flexible:
- `stats.GetOrCreateInfoFor(wpn)` will return existing info for `wpn` if any exists; if not, it will (if the game settings permit this) attempt to re-use an existing `WeaponInfo` for another weapon of the same type. If both of those fail it will create, register, and return a new `WeaponInfo`. Note that calling this on a `Weapon` that is not in the player's inventory will *work*, in the sense that a `WeaponInfo` will be created and returned, but isn't particularly useful unless you subsequently add the weapon to the player's inventory.

If you have an existing `WeaponInfo` and want to stick it to a new weapon, perhaps to transfer upgrades, you can do so by calling `info.Rebind(new_weapon)`. Note that this removes its association with the old weapon entirely -- the "weapon upgrades are shared by weapons of the same class" option is actually implemented by calling `Rebind()` every time the player switches weapons.

# Upgrade List

This is a list of all the upgrades in the game and their effects and prerequisites. Upgrades have brief in-game descriptions, but this list often has more details.

## General Upgrades

General-purpose player and weapon upgrades.

### Agonizer *(Melee only)*

Hitting an enemy flinches them for 2/5ths of a second. More levels increase the duration.

### Armour *(Player only)*

Reduces incoming damage by 1 point per level. Cannot reduce it below 2.

### Beam *(Hitscan only)*

Replaces the weapon's normal attack with a perfectly accurate beam that does reduced damage but goes through enemies. Increased level increases the damage dealt, with diminishing returns.

### Bouncy Shots *(Projectile only)*

Shots bounce off walls. Higher levels increase the number of bounces and decrease the amount of velocity lost on bounce. At level 3, shots bounce off enemies as well.

### Dark Harvest *(Melee only)*

Killing an enemy grants you health and armour equal to 5% of its max health. Unlike the health/armour leech upgrades, this ignores normal health/armour limits and can boost you even beyond Megasphere levels.

### Damage *(No restrictions)*

As a player upgrade, increases *all* damage you deal by 5% per level. As a weapon upgrade, increases damage dealt by *that weapon* by 10% per level. In either case it will always add at least one point of damage per level to each of your attacks.

### Explosive Death *(Ranged only)*

Killing an enemy causes an explosion dealing 20% of (its health + the amount you overkilled it by). Increasing the level increases the damage (with diminishing returns), increases the blast radius (linearly), and reduces the damage you take from the blast.

### Fast Shots *(Projectile only)*

Projectiles move 50% faster per level.

### Fragmentation Shots *(Projectile only)*

On impact, projectiles release a ring of hitscan attacks. Increasing the upgrade level adds more fragments; damage is based on the base damage of the shot. These can't self-damage.

### HE Rounds *(Hitscan only)*

Creates a small explosion on hit doing 40% of the original attack damage. More levels increase the damage and blast radius, and reduce the damage you take from your own explosions.

### Homing Shots *(Projectile only)*

Projectiles home in on enemies. Higher levels will lock on from further away and be more maneuverable when homing.

### Piercing Shots *(Projectile only)*

Shots go through enemies (but not walls). Each level allows shots to go through one additional enemy. Note that most shots will hit enemies multiple times as they pass through, so this also acts as a damage bonus.

### Resistance *(Player only)*

Reduces incoming damage by 5%. This has diminishing returns as you take more levels of it.

### Scavenge Blood *(Player only)*

When killed, enemies drop a health bonus worth 1% of their max health.

### Scavenge Lead *(Player only)*

When killed, enemies drop a random ammo item matching a type of ammo you already have. Note that cheats like `give ammo` will confuse it by giving you ammo from other IWADs, but in normal play it should only give you ammo you've already found prior examples of.

### Scavenge Steel *(Player only)*

When killed, enemies drop an armour bonus worth 2% of their max health.

### Shield *(Melee only, max two levels)*

Reduces incoming damage by 50% (at level 1) or 75% (at level 2).

### Submunitions *(Weapon only)*

Killing an enemy releases a pile of bouncing explosives. Damage depends on level and how much you overkilled the enemy by; increasing level also increases the number of submunitions.

### Swiftness *(Melee only)*

Killing an enemy gives you a brief moment of time freeze (and some brief slow-mo as it wears off). Killing multiple enemies in rapid succession will extend the duration, as will increasing the level of Swiftness.

# Elemental Upgrades

Elemental upgrades add powerful debuffs and damage-over-time effects to your attacks. They work a bit differently from other upgrades. Each element has four associated upgrades:

- a basic upgrade that activates that elemental status effect on the weapon
- an intermediate upgrade that improves the status effect in a different way than just leveling up the base upgrade
- two *mastery upgrades* that add a powerful new effect, only one of which can be chosen on each weapon; one is designed for AoE combat, the other for tackling individual hard targets.

Higher-rank skills cannot exceed the level of lower-rank ones, and lower-rank skills need to be at least level 2 to unlock higher-rank ones, so the earliest you can get a mastery on a weapon is level 5.

Each weapon can only have two different elements on it. When you choose your first elemental upgrade, that element is "locked in" until you choose a mastery upgrade for it. At that point you can (if you wish) choose a second element next time it levels up.

Note that unlike the non-elemental upgrades, elemental AoE effects like `Acid Spray` and `Putrefaction` will never harm the player.

## Fire

Fire does more damage the more health the target has, and "burns out" once they're below 50% health. If an enemy that has "burned out" heals, it will start taking fire damage again, making this particularly effective against modded enemies with regeneration or self-healing. More stacks cause it to do the damage faster (but do not increase the total damage dealt). Once an enemy has fire stacks it never loses them; they just become dormant once it drops below the health threshold.

More powerful attacks apply more fire stacks, so it should be good on all weapons.

### Burning Inscription *(Fire basic upgrade)*

Shots cause enemies to ignite. Higher levels apply fire stacks faster.

### Searing Heat *(Fire intermediate upgrade)*

Reduces the threshold at which fire burns out by 20% (so one level takes it from 50% to 40%). This can be stacked but has diminishing returns.

### Conflagration *(Fire mastery)*

Burning enemies with enough stacks on them will pass a proportion of their stacks on to nearby enemies. Higher levels of Conflagration will transfer more stacks and do so in a wider range, as will adding more stacks to the victim.

### Infernal Kiln *(Fire mastery)*

Attacking a burning enemy gives you a stacking bonus to attack and defence that gradually wears off once you stop.

## Poison

Poison is a weak and short-lived damage-over-time effect, but adding more stacks increases both the duration and the damage per second. Both have diminishing returns, but with no upper bound.

The amount of stacks applied is independent of weapon damage, so it's best used with rapid-fire weapons like the chaingun and plasma rifle.

### Venomous Inscription *(Poison basic upgrade)*

Shots poison enemies. Leveling up the upgrade increases how many stacks are applied per attack.

### Weakness *(Poison intermediate upgrade)*

Poisoned enemies do diminished damage. Each stack reduces damage by 1%, with diminishing returns. Leveling this up increases the amount damage is reduced by per stack, although it can never be reduced below 1.

### Putrefaction *(Poison mastery)*

Killing a poisoned enemy causes it to explode in a cloud of poison gas, poisoning everything nearby. Enemies with more poison stacks on them when they die will spread more poison. Leveling this up increases the proportion of poison that gets spread.

### Hallucinogens *(Poison mastery)*

Once an enemy has enough poison stacks on it to eventually kill it, it fights on your side until it dies. Enemies affected by hallucinogens get a damage bonus from Weakness rather than a damage penalty.

## Acid

Acid stacks are slowly converted into damage on a 1:1 basis, but the less health the target has and the more acid stacks they have, the faster this happens.

Acid stacks have a soft cap based on the damage dealt by the attack that inflicted them, so they're best used with weapons that have high per-shot damage like the rocket launcher and SSG. (For shotguns, the total damage of all the pellets that hit is used, not the per-pellet damage.)

### Corrosive Inscription *(Acid basic upgrade)*

Shots poison enemies. The amount of acid applied, and the cap, is 50% of the damage dealt, increased by another 50% per level.

### Concentrated Acid *(Acid intermediate upgrade)*

Each level increases the threshold at which acid damage starts accelerating by 10%, and the ratio at which acid stacks are converted into damage by 10%. Both have diminishing returns.

### Acid Spray *(Acid mastery)*

Attacks that exceed the acid softcap for the target will splash acid onto nearby enemies instead. Spray range and the level of the applied acid depends on your level of Acid Spray. The amount of acid applied depends on how much you've exceeded the softcap by and how much acid you applied in that attack; both doing more damage and exceeding the softcap by more will increase the splash amount.

### Embrittlement *(Acid mastery)*

Enemies with acid stacks on them take 1% more damage from all sources per stack. Enemies with low enough HP die instantly; the threshold is based on the number of acid stacks and your Concentrated Acid and Embrittlement levels.

## Lightning

Lightning does no additional damage on its own, but paralyzes targets. Stacks are applied based on weapon damage and capped based on skill level, so it should be effective with both rapid-fire and single-shot guns.

### Shocking Inscription *(Lightning basic upgrade)*

Shots paralyze enemies (in addition to doing their normal amount of damage). Paralysis is softcapped at 1 second per upgrade level.

### Revivification *(Lightning intermediate upgrade)*

Slain enemies have a chance of coming back as ghostly minions. The chance of coming back increases with both the number of lightning stacks and the level of Revivification; the latter also gives revived minions a bonus to damage and armour. You can freely walk through your minions (so they can't block important doorways), and while they are capable of friendly fire they will never do more than 1 damage to you. (They take full damage from your attacks, however.)

### Chain Lightning *(Lightning mastery)*

Slain enemies release a burst of chain lightning that arcs between targets. Chain length is based on upgrade level; chain damage is based on how much health the dead enemy had, how many lightning stacks it had on it, and how many enemies are caught in the chain in total. It cannot arc to you.

### Thunderbolt *(Lightning mastery)*

Once you sufficiently exceed the lightning softcap on a target, it is struck by lightning, taking damage based on its max health and your level of Thunderbolt, with a bonus based on how many lightning stacks it has. This clears all lightning stacks on the target.

## Elemental Sythesis Powers

Once you have two elemental masteries on a weapon, you have a chance for one of these upgrades -- **Elemental Beam**, **Elemental Blast**, or **Elemental Wave** -- to show up. Each of these copies the elemental effects on whatever enemy you're attacking to other nearby enemies. Only the basic version of the element is copied -- for example, copied lightning won't proc **Thunderbolt** -- but this can still be quite powerful.
