{stdenv, fetchurl, unzip, makeWrapper, python, jdk}:

stdenv.mkDerivation {
  name = "titanium-mobilesdk-2.1.4.v20121109124659";
  src = if (stdenv.system == "i686-linux" || stdenv.system == "x86_64-linux") then fetchurl {
    url = http://builds.appcelerator.com.s3.amazonaws.com/mobile/2_1_X/mobilesdk-2.1.4.v20121109124659-linux.zip;
    sha1 = "381eb4b06b5a261ddf336c52d4714e5626142697";
  }
  else if stdenv.system == "x86_64-darwin" then fetchurl {
    url = http://builds.appcelerator.com.s3.amazonaws.com/mobile/2_1_X/mobilesdk-2.1.4.v20121109124659-osx.zip;
    sha1 = "1cef5803f0c7b7bb35feb88d3f91bbb191e3953e";
  }
  else throw "Platform: ${stdenv.system} not supported!";
  
  buildInputs = [ unzip makeWrapper ];
  
  buildCommand = ''
    mkdir -p $out
    cd $out
    yes y | unzip $src
    
    # Fix shebang header for python scripts
    
    find . -name \*.py | while read i
    do
        sed -i -e "s|#!/usr/bin/env python|#!${python}/bin/python|" $i
    done
   
    # Zip files do not support timestamps lower than 1980. We have to apply a few work-arounds to cope with that
    # Yes, I know it's nasty :-)
    
    cd mobilesdk/*/*/android
    
    sed -i -f ${./fixtiverify.sed} builder.py
    sed -i -f ${./fixselfruntimev8.sed} builder.py
    sed -i -f ${./fixnativelibs.sed} builder.py
    
    # Patch some executables
    
    ${if stdenv.system == "i686-linux" then
      ''
        patchelf --set-interpreter ${stdenv.gcc.libc}/lib/ld-linux.so.2 titanium_prep.linux32
      ''
      else if stdenv.system == "x86_64-linux" then
      ''
        patchelf --set-interpreter ${stdenv.gcc.libc}/lib/ld-linux-x86-64.so.2 titanium_prep.linux64
      ''
      else ""}
    
    # Wrap builder script
    
    wrapProgram `pwd`/builder.py \
      --prefix PYTHONPATH : ${python.modules.sqlite3}/lib/python*/site-packages \
      --prefix PATH : ${jdk}/bin \
      --prefix JAVA_HOME : ${jdk}
  '' + stdenv.lib.optionalString (stdenv.system == "x86_64-darwin") ''
    # 'ditto' utility is needed to copy stuff to the Xcode organizer. Dirty, but this allows it to work.
    sed -i -e "s|ditto|/usr/bin/ditto|g" $out/mobilesdk/osx/*/iphone/builder.py
  '';
}
