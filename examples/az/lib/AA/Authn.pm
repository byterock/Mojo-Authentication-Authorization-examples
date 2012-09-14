package AA::Authn;
use Mojo::Base 'Mojolicious::Controller';
use  Abstract::Profile;
# This action will render a template
use Data::Dumper;

our %LOGGED_IN = ();
  



sub form {
  my $self = shift;
}

sub login {
  my $self = shift;
  if ($self->authenticate($self->param('id') 
                         ,$self->param('pw')
                         ,{brain_slug=>$self->param('slug')})) {
                           
    my $profile = Abstract::Profile->new({id=>$self->param('id')});
    use Data::Dumper;
    warn("xx=".Dumper($profile));
    $LOGGED_IN{$profile->id()} = $profile;
    $self->redirect_to('home');

  }
  else {
    $self->redirect_to('authn_form');
  }
}

sub check {
  my $self = shift;
  if ($self->is_user_authenticated() and $LOGGED_IN{$self->session('auth_data')}){
    return 1;
  }
  $self->logout();
  $self->redirect_to('authn_form');
  #$self->redirect_to('authn_form') and return 0 unless($self->is_user_authenticated);
  return 0;
}

sub delete {
  my $self = shift;

  my $user = $self->current_user();
  $LOGGED_IN{$self->session('auth_data')}=undef;
  $self->logout();
  $self->redirect_to('authn_form');
  
}
 
1;
