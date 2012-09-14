package AA::Example;
use Mojo::Base 'Mojolicious::Controller';
use Data::Dumper;
# This action will render a template
sub welcome {
  my $self = shift;
   $self->logout();
  # Render template "example/welcome.html.ep" with message
  $self->render(message => 'Welcome to the Mojolicious Web Framework!');
}

sub home {
  my $self = shift;
  my $user = $self->current_user();
  $self->stash('first' => $user->{'first'});
  #$self->stash('user' => $user);
}

 
sub all {
    my $self = shift;
    my $slurp_count=1;
    $self->stash('slurp_count'=>5);
    $self->render('example/feed');
 }
 
 sub little {
    my $self = shift;
        $self->stash('slurp_count'=>1);
     $self->render('example/feed');
 }


 sub some {
    my $self = shift;
    $self->stash('slurp_count'=>2);
    $self->render('example/feed');
 }

   
sub delete {
   my $self = shift;
   $self->logout();
   $self->render('example/dead');
}

1;

