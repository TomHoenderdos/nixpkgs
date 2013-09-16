{ stdenv, fetchgit, zlib, libjpeg_turbo, freetype, perl }:
 


stdenv.mkDerivation {
	name = "pdf-converter";
   

	src = fetchgit {
		url = "https://TomHoenderdos:cfJC112AGl@github.com/touch/PDF-Converter.git";
		rev = "3f22f44ce661c40b7aef21df575d26253bf4f793";	
	};
 	builder = ./builder.sh;
	buildInputs = [ zlib libjpeg_turbo freetype perl ];


	meta = {
		homepage = "https://github.com/touch/PDF-Converter";
    	description = "PDF Converter by Onlinetouch.";
    	license = "Private use";
	};    
}
