package WOD::TraitFor::Character::Template::Changeling;

use Moo::Role;

sub clarity { shift->morality(@_) }

1;
