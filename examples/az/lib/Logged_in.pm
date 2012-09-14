package AA::Logged_in;


use 5.006;
use strict;
use warnings;

our $VERSION = '0.01';

sub new {
    my $class = shift;
    my $self = {};
    bless( $self, ( ref($class) || $class ) );
    return( $self );
}



sub Logged_in{
   
  my $self = shift;
  my ($index) = @_;
      unless ($index) {
         if ($self->{logged_in}{HASH}){
            return(wantarray ? %{$self->{logged_in}{HASH}}:scalar(%{$self->{logged_in}{HASH}}));
          }
          
      }
      if (ref($index) eq 'HASH') {
         unless (scalar(%{$index})){
            $self->{logged_in}{HASH}={};
               }
               else {
            $self->validate_logged_in($index)
                if $self->can('validate_logged_in');
                  if ($self->{logged_in}{HASH}){
                    $self->{logged_in}{HASH}={%{$self->{logged_in}{HASH}},%{$index}};
            }
            else {
                                $self->{logged_in}{HASH}=	$index;
            }
         }
         return(wantarray ? %{$self->{logged_in}{HASH}}:scalar(%{$self->{logged_in}{HASH}}));
      }
      if (scalar(\@_)){
         my %ret=();
         foreach my $key (\@_){
            last if(!$key);
            next if (!exists($self->{logged_in}{HASH}{$key} ) );
            $ret{$key} = $self->{logged_in}{HASH}{$key};
         }
         return(wantarray ? %ret : scalar(%ret));
       }
};
1;