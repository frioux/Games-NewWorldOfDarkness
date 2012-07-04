package WOD::TraitFor::Character::Template::Changeling;

use Moo::Role;
use Sub::Quote 'quote_sub';

sub clarity { shift->morality(@_) }

has wyrd => (
   is => 'rw',
   lazy => 1,
   default => quote_sub q{ 1 },
);

around _reconstruct => sub {
   my ($orig, $self ) = @_;

   $self->wyrd($self->_original_args->{wyrd})
      if exists $self->_original_args->{wyrd};

   $self->$orig
};

1;
