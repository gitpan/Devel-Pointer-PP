package Devel::Pointer::PP;

use 5.8.1;
use strict;
use warnings;
use base 'Exporter';
use B;

use vars qw(@SVCLASSNAMES @EXPORT $VERSION);

BEGIN {
    $VERSION = '1.00';
    @EXPORT = qw(address_of
		 deref
		 unsmash_sv
		 unsmash_av
		 unsmash_hv
		 unsmash_cv);
    @SVCLASSNAMES =
        map "B::$_",
        qw( NULL
            IV
            NV
            RV
            PV
            PVIV
            PVNV
            PVMG
            BM
            PVLV
            AV
            HV
            CV
            GV
            FM
            IO );
}

sub address_of {
    return @_ ? 0 + \ $_[0] : ();
}

BEGIN {
    for (qw(unsmash_sv
            unsmash_av
            unsmash_hv
            unsmash_cv
            deref)) {
        no strict 'refs';
        *$_ = sub {
            my $address = 0 + shift;
            my $o = bless \ $address, 'B::SV';
            my $type = $o->SvTYPE;
            bless $o, $SVCLASSNAMES[$type];
            return $o->object_2svref;
        };
    }
}

1;
__END__

=head1 NAME

Devel::Pointer::PP - Fiddle around with pointers

=head1 SYNOPSIS

  use Devel::Pointer::;
  $a = address_of($b);   # a = &b;
  $b = ${deref($a)};        # b = *a;

  $a = unsmash_sv(0+$scalar_ref);
  @a = unsmash_av(0+$array_ref);
  %a = unsmash_hv(0+$hash_ref);
  &a = unsmash_cv(0+$code_ref); 
  # Yes, you can do that. You get the idea.

  $c = deref(-1);        # *(-1), and the resulting segfault.

=head1 DESCRIPTION

The primary purpose of this is to turn a smashed reference
address back into a value. Once a reference is treated as
a numeric value, you can't dereference it normally; although
with this module, you can.

Be careful, though, to avoid dereferencing things that don't
want to be dereferenced.

=head2 EXPORT

All of the above

=head1 AUTHOR

Joshua b. Jore C<jjore@cpan.org>

Simon Cozens wrote the XS version and then some loony put an object_2svref
method into perl 5.8.1's B module and enabled me to rewrite the thing in
pure perl.

=head1 SEE ALSO

L<Devel::Pointer>, L<Devel::Peek>, L<perlref>, L<B::Generate> 

=cut
