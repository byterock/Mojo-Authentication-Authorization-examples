package AA;
use Mojo::Base 'Mojolicious';


use Data::Dumper;
  
# This method will run once at server start
sub startup {
  my $self = shift;
  

  
  # Documentation browser under "/perldoc" (this plugin requires Perl 5.10)
  $self->plugin('PODRenderer');
  $self->mode('development');

  $self->plugin('authorization',{

    has_priv => sub {
       my $self = shift;
       my ($priv, $extradata) = @_;
       my $user = $self->current_user();
       return $user->can_i($priv);
    },
    
    is_role => sub {
      my $self = shift;
      my ($role, $extradata) = @_;
      my $user = $self->current_user();
      return 1
        if ($user->role() eq $role);
      return 0;
    },
    
    user_privs => sub {
      my $self = shift;
      my ($extradata) = @_;
      my $user = $self->current_user();
      return keys(%{$user->can()});
    },

    user_role => sub {
      my $self = shift;
      my ($extradata) = @_;
      my $user = $self->current_user();
      return $user->role();
    },
  });


  $self->plugin('authentication', {
      autoload_user=>1,
      load_user => sub {
        my $self = shift;
        my $uid  = shift;
        return $AA::Authn::LOGGED_IN{$uid}
          if ($AA::Authn::LOGGED_IN{$uid});
        return $uid;
        #$AA::Authn::LOGGED_IN{$uid}=undef;
        
        
        #return undef;
        # my ($first,$last,$role);
        # 
        # 
        # given ($uid) {
            # when (/fry/) {$first="Philip";$last="Fry";$role="dead";}
            # when (/bender/) {$first="Bender";$last="Rodríguez";$role="none";}
            # when (/hermes/) {$first="Hermes";$last="Conrad";$role="slug";}
        # };
        # warn(%AA::Authn::LOGGED_IN);
        # return {first=>$first,last =>$last,role=>$role};
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
        return $un
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
  $r->route('/logout')->to('authn#delete')->name('authn_delete');
  
  
  
  my $rn = $r->bridge->to('authn#check');
  $rn->route('/home')->to('example#home')->name('home');
  $rn->route('/slug')->to('example#slug')->name('slug');
  $rn->route('/drop')->over(has_priv => 'detatch')->to('example#drop')->name('drop');
  $rn->route('/die')->over(is =>'dead')->to('example#delete')->name('die');
 
 
  my $feed_only = $r->route('/feed')->over(has_priv => 'feed')->to('example#feed');
  
  foreach my $size ((qw(little some all))){
     $feed_only->route($size)->to("example#$size");
  }
  
  
  $rn->route('/control')->over(is =>'king')->to("example#control");
 
  #$r->route('/*everythingy')    ->to('authn#form');
  
 
  
}

1;
