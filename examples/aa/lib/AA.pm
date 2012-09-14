package AA;
use Mojo::Base 'Mojolicious';



# This method will run once at server start
sub startup {
  my $self = shift;

  # Documentation browser under "/perldoc" (this plugin requires Perl 5.10)
  $self->plugin('PODRenderer');
  $self->mode('development');

  $self->plugin('authentication', {
      autoload_user=>1,
      load_user => sub {
        my $self = shift;
        my $uid  = shift;
        my ($first,$last);
        given ($uid) {
            when (/fry/) {$first="Philip";$last="Fry"}
            when (/bender/) {$first="Bender";$last="Rodríguez"}
            when (/hermes/) {$first="Hermes";$last="Conrad"}
        };
        return {first=>$first,last =>$last};
      },
      validate_user => sub {
        my $self = shift;
        my $un = shift || '';
        my $pw = shift || '';
        my $extra = shift || {};
        use Authen::Simple::DBI;
        
        my $authDB = Authen::Simple::DBI->new(
                     dsn => 'DBI:Oracle:XE',
                     username => 'HR',
                     password => 'HR',
                     statement => 'SELECT password FROM brain_slug WHERE slug_id = ?'
        );
        return $un;
          if ($authDB->authenticate($un,$pw));
        return undef;
      },
    }
  );

  # Routes
  my $r = $self->routes;
  # Normal route to controller
  $r->route('/welcome')->to('example#welcome');
  
  $r->route('/login')  ->via('get') ->to('authn#form')->name('authn_form');
  $r->route('/login')  ->via('post')->to('authn#login');
  
 # $r->route('/home')->over(authenticated => 1)->to('example#home')->name('home');
  
 # $r->route('/(*)')    ->to('authn#form');
  
  my $rn = $r->bridge->to('authn#check');
  $rn->route('/home')->to('example#home')->name('home');
  $rn->route('/slug')->to('example#slug')->name('home');
  $r->route('/logout')->to('authn#delete')->name('authn_delete');
  #
}

1;
