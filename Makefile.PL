use 5.8.1;
use ExtUtils::MakeMaker;
WriteMakefile(
    'NAME'	    => 'Devel::Pointer::PP',
    'VERSION_FROM'  => 'PP.pm',
    'PREREQ_PM'	    => { 'B' => '1.01' },
    'ABSTRACT_FROM' => 'PP.pm',
);
