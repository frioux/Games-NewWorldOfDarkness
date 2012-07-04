package WOD::Character;

use Moo;
require Role::Tiny;
use Sub::Quote 'quote_sub';
use List::Util;

sub power_attributes { qw(intelligence strength presence) }

sub finesse_attributes { qw(wits dexterity manipulation) }

sub resistance_attributes { qw(resolve stamina composure) }

sub mental_attributes { qw(intelligence wits resolve) }

sub physical_attributes { qw(strength dexterity stamina ) }

sub social_attributes { qw(presense manipulation composure ) }

# Vanilla stats

has name => (
   required => 1,
   is => 'rw',
);

has age        =>  ( is => 'rw' );
has player     =>  ( is => 'rw' );
has concept    =>  ( is => 'rw' );
has vice       =>  ( is => 'rw' );
has virtue     =>  ( is => 'rw' );
has chronicle  =>  ( is => 'rw' );
has faction    =>  ( is => 'rw' );
has group_name =>  ( is => 'rw' );

has size => (
   is => 'rw',
   default => quote_sub q{ 5 },
);

sub speed { $_[0]->str + $_[0]->dex + 5 }
sub initiative_mod { $_[0]->dex + $_[0]->comp }
sub initiative { 1 + int(rand(10)) + $_[0]->initiative_mod }
sub defense { List::Util::min($_[0]->dex, $_[0]->wits) }

has armor => (
   is => 'rw',
   default => quote_sub q{ 0 },
);

sub max_health { $_[0]->stamina + $_[0]->size }
has health => (
   is => 'rw',
   lazy => 1,
   default => quote_sub q{ $_[0]->max_health },
);

sub max_willpower { $_[0]->resolve + $_[0]->composure }
has willpower => (
   is => 'rw',
   lazy => 1,
   default => quote_sub q{ $_[0]->max_willpower },
);

# Attributes

has $_  => (
   is => 'rw',
   default => quote_sub q{ 1 },
) for qw(
   intelligence
   strength
   presence
   wits
   dexterity
   manipulation
   resolve
   stamina
   composure
);

sub untrained_mental_skill { -3 }

sub mental_skills {
   qw(
   academics
   computer
   crafts
   investigation
   medicine
   occult
   politics
   science
   )
}

sub untrained_physical_skill { -1 }

sub physical_skills {
   qw(
   athletics
   brawl
   drive
   firearms
   larceny
   stealth
   survival
   weaponry
   )
}

sub untrained_social_skill { -1 }

sub social_skills {
   qw(
   animal_ken
   empathy
   expression
   intimidation
   persuasion
   socialize
   streetwise
   subterfuge
   )
}

# Skills

has $_  => (
   is => 'rw',
   default => quote_sub q{ 0 },
) for qw(
   academics
   computer
   crafts
   investigation
   medicine
   occult
   politics
   science
   athletics
   brawl
   drive
   firearms
   larceny
   stealth
   survival
   weaponry
   animal_ken
   empathy
   expression
   intimidation
   persuasion
   socialize
   streetwise
   subterfuge
);

has skill_specialties => (
   is => 'rw',
   default => quote_sub q{ {} },
);

sub int { goto \&intelligence }
sub str { goto \&strength }
sub pres { goto \&presence }
# wits
sub dex { goto \&dexterity }
sub manip { goto \&manipulation }
# resolve
sub stam { goto \&stamina }
sub comp { goto \&composure }

has merits => (
   is => 'rw',
   default => quote_sub q{ {} },
);

sub _roles {
   my $self = shift;

   my $merits = $self->merits;
   map $self->_merit_to_rolename($_, $merits->{$_}), keys %$merits
}

sub from_data_structure {
   my ($class, $ds) = @_;

   my $ret = $class->new(
      name => $ds->{name},
      skill_specialties => $ds->{skill_specialties},
      merits => $ds->{merits},
      %{$ds->{attributes}},
      %{$ds->{skills}},
   );

   my $changed = 1;
   while ($changed) {
      $changed = 0;
      for my $role ($ret->_roles) {
         unless ($ret->does($role)) {
            Role::Tiny->apply_roles_to_object($ret, $role);
            $changed = 1
         }
      }
   }

   return $ret
}

sub _merit_to_rolename {
   my ($self, $merit, $dots) = @_;

   return "WOD::TraitFor::Character::Merit::" .
      join '', (map ucfirst, split /\s+/, $merit ), $dots
}

sub dice_for_attribute {
   my ( $self, $attribute ) = @_;

   return $self->$attribute
}

sub untrained_value_for_skill {
   my ( $self, $skill ) = @_;

   if (List::Util::first { $skill eq $_ } $self->mental_skills) {
      return $self->untrained_mental_skill
   } elsif (List::Util::first { $skill eq $_ } $self->physical_skills) {
      return $self->untrained_physical_skill
   } elsif (List::Util::first { $skill eq $_ } $self->social_skills) {
      return $self->untrained_social_skill
   }
}

sub dice_for_skill {
   my ( $self, $skill, $useful_specialties ) = @_;

   if (my $val = $self->$skill) {
      for my $specialty (@$useful_specialties) {
         $val += 2 if List::Util::first { $specialty eq $_ }
            @{$self->skill_specialties->{$skill}}
      }
      return $val
   } else {
      return $self->untrained_value_for_skill($skill)
   }
}

sub dice_pool {
   my ($self, $args) = @_;
   my $attributes = $args->{attributes} || [];
   my $skills     = $args->{skills} || [];
   my $mods       = $args->{mods} || [];

   return List::Util::max(
      List::Util::sum(
         ( map $self->dice_for_attribute($_), @$attributes ),
         ( map $self->dice_for_skill(%$_), @$skills ),
         @$mods,
      ),
      1
   )
}

1;
