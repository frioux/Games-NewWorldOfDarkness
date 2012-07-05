package WOD::TraitFor::Character::Template::Changeling;

use Moo::Role;
use Sub::Quote 'quote_sub';

sub clarity { shift->morality(@_) }

has wyrd => (
   is => 'rw',
   lazy => 1,
   default => quote_sub q{ 1 },
);

has glamour => (
   is => 'rw',
   lazy => 1,
   default => quote_sub q{
      use POSIX 'ceil';
      ceil($_[0]->max_glamour / 2)
   },
);

our @max_attr_skill_contract_from_wyrd = (
   undef,
   5,
   5,
   5,
   5,
   5,
   6,
   7,
   8,
   9,
   10,
);

our @max_glamour_per_turn_from_wyrd = (
   undef,
   1,
   2,
   3,
   4,
   5,
   6,
   7,
   8,
   10,
   15,
);

our @max_glamour_from_wyrd = (
   undef,
   10,
   11,
   12,
   13,
   14,
   15,
   20,
   30,
   50,
   100
);

sub max_glamour { $max_glamour_from_wyrd[$_[0]->wyrd] }
sub max_glamour_per_turn { $max_glamour_per_turn_from_wyrd[$_[0]->wyrd] }

around _reconstruct => sub {
   my ($orig, $self ) = @_;

   $self->wyrd($self->_original_args->{wyrd})
      if exists $self->_original_args->{wyrd};

   $self->$orig
};

1;
