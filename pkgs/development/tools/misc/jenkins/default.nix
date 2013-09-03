{ stdenv, fetchurl, jre, wget }:
 
stdenv.mkDerivation {
	name = "Jenkins-1.529";
	builder = ./builder.sh;

	src = fetchurl {
		url = http://mirrors.jenkins-ci.org/war/1.529/jenkins.war;
		sha256 = "1qhklrizxgp5iccqqyv2xn46mc4y5jm8c61fg99350kl1vsbp845";
	};

	buildInputs = [ "" ];

    inherit jre;

	meta = {
		homepage = "http://jenkins-ci.org";
    	description = "Jenkins CI, An extendable open source continuous integration server.";
    	license = "Creative Commons Attribution 3.0 Unported";
	};    
}
