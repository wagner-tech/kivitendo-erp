package SL::mebil::ERiC;

#####################################################
# Abhängigkeit: libinline-perl
# diese Datei ist im falschen Zweig 
#####################################################
use File::Copy qw(copy);
use strict;
use Inline C => Config => BUILD_NOISY => 1, MYEXTLIB => '/home/mebil/workspace_cpp/mERiC/Debug/libmERiC.so';
use Inline C => <<'C_END';

int validate (char*, char*);
int senddata (char*, char*, char*, char*);

int c_validate(char* datenart, char* xml_file) {
      int r = validate(datenart, xml_file);
      return r;
}
int c_submit(char* datenart, char* xml_file, char* certificate_path, char* PIN) {
      int r = senddata(datenart, xml_file, certificate_path, PIN);
      return r;
}

C_END

sub new {
	# parameter: 1) type of data: xmlfile must be named: <datatype>.xml
	#            2) xml file name
	#            3) path to certificate
	#            4) password
	my $my_data = {
		datatype         => $_[1],
		xml_file         => $_[2],
		certificate_path => $_[3],
		PIN              => $_[4]};
	bless $my_data;
	return $my_data;
}

sub validate {
	my $self = shift;
	
	# open xml file for reading
	open (FILE, "$self->{xml_file}") or die "cannot open $self->{xml_file}";
	
	# check encoding
	my $encod = <FILE>;
	if ($encod =~ /UTF-8/) {
		open (OUT, ">:encoding(iso-8859-1)", "data.xml");
		print OUT "<?xml version=\"1.0\" encoding=\"ISO-8859-15\"?>\n";
		my $line;
		while ($line = <FILE>) {
			print OUT $line;
		}
		close (OUT);
		close (FILE);
		
	}
	elsif ($encod =~ /8859-15/) {
		close (FILE);
	    copy "$self->{xml_file}", "data.xml";
	}
	else {
		die "unknown encoding $encod";
	}		

	# call ERiC lib
	return c_validate($self->{datatype}, "data.xml");
}

sub submit {
	my $self = shift;

	# call ERiC lib
	return c_submit($self->{datatype}, "data.xml", $self->{certificate_path}, $self->{PIN});
}

1;
