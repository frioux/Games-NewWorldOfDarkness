package WOD::TraitFor::Character::Merit::FleetOfFoot2;

use Moo::Role;

# how do we factor prerequisites into this?

around speed => sub {
   my ($orig, $self, @rest) = @_;

   $self->$orig(@rest) + 2
};

1;
