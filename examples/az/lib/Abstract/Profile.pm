package Abstract::Profile;

use strict;
use warnings;
use DBD::Oracle;

our $VERSION = '0.01';


sub new {
    my $class = shift;
    my $self = {};
    bless( $self, ( ref($class) || $class ) );
    $self->_initialize(@_);
    return $self;
}


sub _initialize {

  my $self = shift;
  
  my ($opt) = @_;
  my $dbh = DBI->connect('dbi:Oracle:XE','hr','hr');
  my $sth = $dbh->prepare('select first_name,
                                  middle_name,
                                  last_name,
                                  role 
                             from brain_slug 
                            where slug_id=:p_id');
  $sth->bind_param(':p_id', $opt->{id});
  $sth->execute();
  my @new_slug =  $sth->fetchrow();
  return $self
    unless(scalar(@new_slug));
  $self->id($opt->{id});
  $self->first($new_slug[0]);
  $self->middle($new_slug[1]);
  $self->last($new_slug[2]);
  $self->role($new_slug[3]);
  
  $sth = $dbh->prepare('select can
                   from SLUG_ROLE_CAN 
                  where role=:p_role');
  $sth->bind_param(':p_role', $self->role());
  $sth->execute();
  my $i_can ={};
  while (my @row=$sth->fetchrow()) {
     $i_can->{$row[0]}=1;     
  }
  $self->can($i_can); 
  #$self->can({detatch=>1,attach=>1,control=>1,feed=>1});
  
  
  return $self;
  
}

sub id {
  my $self = shift;

  if (@_) {
    $self->{id} = shift;
    return 1;
  }
  return $self->{id};

};

sub can {
  my $self = shift;

  if (@_) {
    $self->{can}{HASH} = shift;
    return 1;
  }
  return $self->{can}{HASH};

};

sub can_i {
  my $self   = shift;
  my ($action) = @_;
  return $self->{can}->{HASH}->{$action};
}

sub role {
  my $self = shift;
  if (@_) {
    $self->{role} = shift;
    return 1;
  }
  return $self->{role};
};

sub first {
  my $self = shift;
  if (@_) {
    $self->{first} = shift;
    return 1;
  }
  return $self->{first};
};

sub middle {
  my $self = shift;
  if (@_) {
    $self->{middle} = shift;
    return 1;
  }
  return $self->{middle};
};
sub last {
  my $self = shift;
  if (@_) {
    $self->{last} = shift;
    return 1;
  }
  return $self->{last};
};

1;
