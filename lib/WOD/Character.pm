package WOD::Character;

use Moo;

has intelligence => (
   required => 1,
   is => 'rw',
);

has strength => (
   required => 1,
   is => 'rw',
);

has presence => (
   required => 1,
   is => 'rw',
);

has wits => (
   required => 1,
   is => 'rw',
);

has dexterity => (
   required => 1,
   is => 'rw',
);

has manipulation => (
   required => 1,
   is => 'rw',
);

has resolve => (
   required => 1,
   is => 'rw',
);

has stamina => (
   required => 1,
   is => 'rw',
);

has composure => (
   required => 1,
   is => 'rw',
);

has name => (
   required => 1,
   is => 'rw',
);

sub int { goto \&intelligence }
sub str { goto \&strength }
sub pres { goto \&presence }
# wits
sub dex { goto \&dexteriy }
sub manip { goto \&manipulation }
# resolve
sub stam { goto \&stamina }
sub comp { goto \&compusure }

sub from_data_structure {
   my ($class, $ds) = @_;

   $class->new(
      name => $ds->{name},
      %{$ds->{attributes}},
   )
}

1;
