package AA::Authn;
use Mojo::Base 'Mojolicious::Controller';

# This action will render a template

sub form {
  my $self = shift;
}

sub login {
  my $self = shift;
  if ($self->authenticate($self->req->param('id') 
                  ,$self->req->param('pw')
                  ,{brain_slug=>$self->req->param('slug')})) {
    $self->redirect_to('home');
  }
  else {
    $self->redirect_to('authn_form');
  }
}

sub check {
  my $self = shift;
  $self->redirect_to('authn_form') and return 0 unless($self->is_user_authenticated);
  return 1;
}

sub delete {
  my $self = shift;
  $self->logout();
  $self->redirect_to('authn_form');
}
 
1;
