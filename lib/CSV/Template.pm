
package CSV::Template;

use strict;
use warnings;

use HTML::Template;

our $VERSION = '0.01';

use base "HTML::Template";

sub output {
    my ($self) = @_;
    my $output = $self->SUPER::output();
    # remove any blank lines
    # intentional blank lines 
    # should have one comma in them
    return join "\n" => grep {
            !/^\s*?$/
           } split /\n/ => $output;
}

1;

__END__

=head1 NAME

CSV::Template - A CSV templating module derived from HTML::Template

=head1 SYNOPSIS

  use CSV::Template;

  my $csv = CSV::Template->new(filename => "t/test.tmpl");

  $csv->param(report_title => "My Report");
  $csv->param(report_data => [
          { a1 => 1, b1 => 2, c1 => 3 },
          { a2 => 2, b2 => 4, c2 => 6 },
          { a3 => 3, b3 => 6, c3 => 9 },
          ]);

  print $csv->output();

=head1 DESCRIPTION

This is really just a subclass of B<HTML::Template> that does some minor post processing of the output. Since B<HTML::Template> really just operates on plain text, and not HTML specifically, it dawned on me that there is no reason why I should not use B<HTML::Template> (and all my B<HTML::Template> friendly data structures) to generate my CSV files as well. 

Now this is by no means a full-features CSV templating system. Currently it serves my needs which is to display report output in both HTML (with B<HTML::Template>) and in CSV (to be viewed in Excel). 

=head1 METHODS

It is best to refer to the B<HTML::Template> docs, we only implement one method here.

=over 4

=item output

We do some post processing of the normal B<HTML::Template> output here to make sure our display comes out correctly, by basically removing any totally blank lines from our output.

The reason for this is that when writing code for a template it is more convient to do this:

  E<lt>TMPL_LOOP NAME="test_loop"E<gt>
  E<lt>TMPL_VAR NAME="one"E<gt>,E<lt>TMPL_VAR NAME="two"E<gt>,E<lt>TMPL_VAR NAME="three"E<gt>,
  E<lt>/TMPL_LOOPE<gt>

Than it is to have to do this:

  E<lt>TMPL_LOOP NAME="test_loop"E<gt>E<lt>TMPL_VAR NAME="one"E<gt>,E<lt>TMPL_VAR NAME="two"E<gt>,E<lt>TMPL_VAR NAME="three"E<gt>,
  </TMPL_LOOPE<gt>

The first example would normally leave an extra line in the output as a consequence of formating our template code the way we did. The second example avoids that problem, but at the sacrifice of clarity (in my opinion of course). 

To remedy this problem, I decided that any empty lines should be removed from the output. If you desire a blank line in your output, then simply put a single comma on that line. Excel should see and understand this as a blank line (at least my copy does).

=back

=head1 CAVEAT

This module makes no attempt to handle strings with embedded commas, that is the responsibilty of the template author. Personally I recommend quoting all strings in your output, just to be safe. More advanced string handling for parameters is on my L<TO DO> list.

=head1 TO DO

This is really just a quick fix for now, it serves my current needs. But that is not to say that I cannot see the possibilites for more features.

=over 4

=item Add "width" features

It would be nice if we could pad lines to a constant width, so that all the lines were of equal length. This would be useful when using this to prepare files for insertion into a database, etc. It shouldnt be too hard to accomplish.

=item Add string handling features

In a CSV file, strings with embedded comma's must be quoted properly so as not to confuse the CSV reader. This also raises the issue of quoting strings, which themselves have embedded quotes. I would like to handle this in the code, so the template author and creater of the data-structure do not have to. Unfortunately I don't know enough yet about the inner workings of HTML::Template to do that, so it will have to wait.

=back

=head1 BUGS

None that I am aware of. Of course, if you find a bug, let me know, and I will be sure to fix it. 

=head1 CODE COVERAGE

I use B<Devel::Cover> to test the code coverage of my tests, below is the B<Devel::Cover> report on this module test suite. 

 ---------------------------- ------ ------ ------ ------ ------ ------ ------
 File                           stmt branch   cond    sub    pod   time  total
 ---------------------------- ------ ------ ------ ------ ------ ------ ------
 /CSV/Template.pm              100.0    n/a    n/a  100.0  100.0   47.4  100.0
 t/10_CSV_Template_test.t      100.0    n/a    n/a  100.0    n/a   52.6  100.0
 ---------------------------- ------ ------ ------ ------ ------ ------ ------ 
 Total                         100.0    n/a    n/a  100.0  100.0  100.0  100.0
 ---------------------------- ------ ------ ------ ------ ------ ------ ------ 

Keep in mind this module only overrides one method in HTML::Template, so there is not much to cover here.

=head1 SEE ALSO

=over 4

=item HTML::Template

This module is a subclass of HTML::Template, so if you want to know how to use it you will need to refer to that module's excellent documentation.

=back

There are also a number of other CSV related modules out there, here are a few that I looked at while trying to solve the issue that lead to the creation of this module.

=over 4

=item Excel::Template

This module is an effort to use HTML::Template data structures to generate Excel files. I looked at this module, but it is much more than I needed, so I created this. That said, if your needs are more complex than CSV::Template can solve, I suggest looking into this module.

=item DBD::CSV

This was very much overkill for my needs, but maybe not for yours.

=item Tie::CSV_File

This uses C<tie>, which I am not a fan of, to map arrays of arrays to a CSV file. It would not handle my HTML::Template data structures, but if that is not a requirement of your, give it a look.

=back

=head1 AUTHOR

stevan little, E<lt>stevan@iinteractive.comE<gt>

=head1 COPYRIGHT AND LICENSE

Copyright 2004 by Infinity Interactive, Inc.

L<http://www.iinteractive.com>

This library is free software; you can redistribute it and/or modify
it under the same terms as Perl itself. 

=cut

