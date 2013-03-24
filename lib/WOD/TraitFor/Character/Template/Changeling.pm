package WOD::TraitFor::Character::Template::Changeling;

use Moo::Role;
use Sub::Quote 'quote_sub';
use Role::Tiny;

sub clarity { shift->morality(@_) }

has seeming => (
   is => 'rw',
   required => 1,
);

has kith => (
   is => 'rw',
   required => 1,
);

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

sub _seeming_to_rolename {
   my ($self, $seeming) = @_;

   return "WOD::TraitFor::Character::Template::Changeling::Seeming::" .
      join '', (map ucfirst, split /\s+/, $seeming )
}

sub _kith_to_rolename {
   my ($self, $seeming, $kith) = @_;

   return "WOD::TraitFor::Character::Template::Changeling::Kith::" .
      ( join '', (map ucfirst, split /\s+/, $seeming ) ) . '::' .
      ( join '', (map ucfirst, split /\s+/, $kith ) )
}

around _reconstruct => sub {
   my ($orig, $self ) = @_;

   $self->wyrd($self->_original_args->{wyrd})
      if exists $self->_original_args->{wyrd};

   #$self->seeming($self->_original_args->{seeming})
      #or die 'seeming is required for changelings!';
   #Role::Tiny->apply_roles_to_object(
      #$self, $self->_seeming_to_rolename($self->seeming)
   #);

   #$self->kith($self->_original_args->{kith})
      #or die 'kith is required for changelings!';
   #Role::Tiny->apply_roles_to_object(
      #$self, $self->_kith_to_rolename($self->seeming, $self->kith)
   #);

   $self->$orig
};

1;
