// Generic class for DoT effects.
// Subclasses should implement GetParticleColour(), GetParticleZV(), and GetDamage().
// All of these are called every 7 tics (5 times/second) to draw particle effects
// and apply damage.
// They can also override TickDot(), which is the superfunction that calls
// GetDamage().
#namespace TFLV::Upgrade;
#debug on

class ::Dot : Inventory {
  Default {
    DamageType "None";
    Inventory.Amount 1;
    Inventory.MaxAmount 0x7FFFFFFF;
    +INCOMBAT; // Laevis recursion guard
  }

  States {
    Dot:
      TNT1 A 0 SpawnParticles();
      TNT1 A 7 TickDot();
      LOOP;
  }

  override void PostBeginPlay() {
    if (!owner) { Destroy(); return; }
    SetStateLabel("Dot");
  }

  void SpawnParticles() {
    for (uint i = 0; i < 9; i++) {
      SpawnOneParticle(GetParticleColour(), GetParticleZV());
    }
  }

  void SpawnOneParticle(string colour, double zv) {
    owner.A_SpawnParticle(
      colour, SPF_FULLBRIGHT,
      30, 10, 0, // lifetime, size, angle
      // position
      random(-owner.radius, owner.radius), random(-owner.radius, owner.radius), random(0, owner.height),
      0, 0, zv, // v
      0, 0, zv); // a
  }

  virtual void TickDot() {
    if (!owner || owner.bKILLED) {
      Destroy();
      return;
    }
    owner.DamageMobj(
      self, self.target, GetDamage(), self.DamageType,
      DMG_NO_ARMOR | DMG_NO_PAIN | DMG_THRUSTLESS | DMG_NO_ENHANCE);
  }

  virtual uint GetDamage() {
    ThrowAbortException("Subclass of ::Dot did not implement GetDamage()!");
    return 0;
  }

  virtual string GetParticleColour() {
    ThrowAbortException("Subclass of ::Dot did not implement GetParticleColour()!");
    return "black";
  }

  virtual double GetParticleZV() {
    ThrowAbortException("Subclass of ::Dot did not implement GetParticleZV()!");
    return 0;
  }
}
