package AA::Example;
use Mojo::Base 'Mojolicious::Controller';

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
}

# sub slug {
  # my $self = shift;
    # 
# }

1;
