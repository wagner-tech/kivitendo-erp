package SL::Controller::Helper::RequirementSpec;

use strict;

use Exporter qw(import);
our @EXPORT = qw(init_visible_section);

use SL::DB::Manager::RequirementSpecItem;

sub init_visible_section {
  my ($self)       = @_;

  my $content_id   = $::form->{current_content_id};
  my $content_type = $::form->{current_content_type};

  return undef unless $content_id;
  return undef unless $content_type =~ m/section|function-block/;

  $self->visible_item(SL::DB::Manager::RequirementSpecItem->find_by(id => $content_id));
  return undef unless $self->visible_item;

  return $self->visible_section($self->visible_item->section);
}

1;
