#namespace TFLV::Upgrade;
#debug off

class ::ExplosiveShots : ::BaseUpgrade {
  override ::UpgradePriority Priority() { return ::PRI_EXPLOSIVE; }

  override void OnDamageDealt(Actor pawn, Actor shot, Actor target, int damage) {
    DEBUG("ExplosiveShots::OnDamageDealt damage=%d shot=%s", damage, shot.GetClassName());
    DEBUG("Pawn position: [%d,%d,%d]", pawn.pos.x, pawn.pos.y, pawn.pos.z);
    DEBUG("Shot position: [%d,%d,%d]", shot.pos.x, shot.pos.y, shot.pos.z);
    let boom = ::ExplosiveShots::Boom(shot.Spawn("::ExplosiveShots::Boom", shot.pos));
    DEBUG("Boom position = [%d,%d,%d]", boom.pos.x, boom.pos.y, boom.pos.z);
    boom.special1 = Priority();
    boom.target = pawn;
    boom.damage = damage * level * 0.4;
    boom.radius = 64 + 16 * level;
  }

  override bool IsSuitableForWeapon(TFLV::WeaponInfo info) {
    return info.IsHitscanWeapon() && !info.weapon.bMELEEWEAPON;
  }
}

class ::ExplosiveShots::Boom : Actor {
  uint level;
  uint damage;
  uint radius;

  Default {
    // +PROJECTILE; can't set this in zscript?
    +NOBLOCKMAP;
    +NOGRAVITY;
    +MISSILE;
    +NODAMAGETHRUST;
    DamageType "Extreme";
  }

  override int DoSpecialDamage(Actor target, int damage, Name damagetype) {
    if (target == self.target) {
      return 1;
    }
    return damage;
  }

  States {
    Spawn:
      TNT1 A 1;
      TNT1 A 0 A_Explode(damage, radius, XF_HURTSOURCE|XF_NOSPLASH);
      TNT1 A 0 A_AlertMonsters();
      // TODO: include a suitable sound effect
      TNT1 A 0 A_StartSound("imp/shotx", CHAN_WEAPON, CHANF_OVERLAP, 1, 0.5);
      TNT1 A 0 A_StartSound("imp/shotx", CHAN_7, CHANF_OVERLAP, 0.1, 0.01);
      LFBX ABC 7 Bright;
      STOP;
  }
}
