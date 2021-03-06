#!/usr/bin/env perl
use Mojolicious::Lite;




plugin 'authentication', {
    autoload_user=>1,
    load_user => sub {
        my $self = shift;
        my $uid  = shift;
        return $uid;
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
};


get '/home' => sub {
  my $self = shift;
  $self ->redirect_to('welcome')
    unless($self->is_user_authenticated());
};

get '/welcome' => sub {
  my $self = shift;
  $self->logout();
  $self->render('index');
  
};

post '/login' => sub {
    
  my $self = shift;
  if ($self->authenticate($self->req->param('id') 
                  ,$self->req->param('pw')
                  ,{brain_slug=>$self->req->param('slug')})) {
    $self->redirect_to('home');
  }
  else {
    $self->redirect_to('welcome');
  }
};

app->start;
__DATA__

@@ layouts/default.html.ep
<!DOCTYPE html>
<html>
  <head><title><%= title %></title></head>
  <body><%= content %></body>
</html>

@@ index.html.ep
% layout 'default';
% title 'Welcome';

Welcome to Authorization

<form action="/login" method="post">
<table>
<tr> <td> User </td> <td> <input type="text" name="id" /> </td> </tr>
<tr> <td> Password </td> <td> <input type="password" name="pw" /> <input type="hidden" name="slug" value="yes"></td> </tr>
</table>

<input type="submit" name="mysubmit" value="Click!" />

</form>

@@ home.html.ep
% layout 'default';
% title 'home';


lets all go to the brain slug planet!


@@ layouts/default.html.ep
<!DOCTYPE html>
<html>
  <head><title><%= title %></title></head>
  <body><%= content %></body>
</html>
