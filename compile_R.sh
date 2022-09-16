#!/opt/local/bin/bash

# -- Original author: Christopher Eeles
if [[ "$OSTYPE" =~ darwin.* ]]
then
    cmd="xcode-select -p"
    $cmd > /dev/null 2>&1 
    exit_status=$?
    if [ ! $exit_status -eq 0 ]
    then
        echo 'Xcode Command Line Tool (CLT) is required to install R.'\
             '\nIf you already have Xcode installed on your Mac, run:'\
             '\nsudo xcode-select -s /Applications/Xcode.app/Contents/Developer'\
             '\nOr install the CLT with the following lines:'\
             '\nxcode-select --install'\
             '\nsudo xcode-select --switch /Library/Developer/CommandLineTools'
        exit 1
    fi
    if [ ! -d /Applications/MacPorts ]
    then
        echo 'This script only works with MacPorts for now.'\
             'Brew users are welcome to contribute.'
        exit 1
    fi
else
    echo 'This script is intended for MacOS. '\
         '\nTo compile on Linux Debian distro, please refer to:'\
         'https://github.com/ChristopherEeles/R_utilities'
    exit 1
fi

# -- parse command line args
SOURCE='https://cran.r-project.org/src/base/R-latest.tar.gz'
VERSION='latest'
while [[ $# -gt 0 ]]; do
    key="$1"
    case $key in
        -v|--version)
            VERSION="$2"
            case $VERSION in
                devel)
                    SOURCE='https://stat.ethz.ch/R/daily/R-devel.tar.gz'z
                    ;;
                patched)
                    SOURCE='https://stat.ethz.ch/R/daily/R-patched.tar.gz'
                    ;;
                *)
                    echo 'Valid options for the -v/--version parameter are ' \
                        '\n"devel" for the development version or "patched" ' \
                        '\nfor the previous release. If you want R "release",' \
                        '\n exclude the -v/--version parameter since that is' \
                        'the default for this script.'
                    ;;
            esac
            shift # past argument
            shift # past value
            ;;
        *)
            echo "The only valid option is for this script is -v/--version."
            exit 1
            ;;
    esac
done

# -- install R compilation dependencies
## TODO: Generalize this to work with brew
echo "Installing required dependencies"
sudo port selfupdate

sudo port -N install gcc12
sudo port select --set gcc mp-gcc12

sudo port -N install \
    gettext \
    libtool \
    jpeg \
    libpng \
    giflib \
    cairo \
    poppler \
    texinfo \
    intltool

echo "Dependencies installed!"

# -- install gfortran
echo "Installing Fortran a-arm64 for macOS"
sudo mkdir -p /opt/R/arm64
sudo chown $USER /opt/R/arm64
curl -O https://mac.r-project.org/tools/gfortran-12.0.1-20220312-is-darwin20-arm64.tar.xz
tar fxz gfortran-12.0.1-20220312-is-darwin20-arm64.tar.xz -C /
if echo $0 | grep -q "zsh"
then
    echo 'export PATH=$PATH:/opt/R/arm64/gfortran/bin' >>"$HOME"/.zprofile
else
    sh=$(echo $0 | sed 's/-//')
    echo 'export PATH=$PATH:/opt/R/arm64/gfortran/bin' >>"$HOME"/."$sh"_profile
fi

##-- install r-base-dev
echo "Installing r-base-dev"
git clone https://github.com/R-macos/recipes.git
./recipes/build.sh r-base-dev
if [ ! -f /opt/R/arm64/include/libintl.h ]
then
    ln -s /opt/local/include/libintl.h /opt/R/arm64/include/libintl.h
fi
if [ ! -f /opt/R/arm64/lib/libintl.dylib ]
then
    ln -s /opt/local/lib/libintl.dylib /opt/R/arm64/lib/libintl.dylib
fi
if [ ! -f /opt/R/arm64/lib/libintl.8.dylib ]
then
    ln -s /opt/local/lib/libintl.8.dylib /opt/R/arm64/lib/libintl.8.dylib
fi
if [ ! -f /opt/R/arm64/lib/libintl.a ]
then
    ln -s /opt/local/lib/libintl.a /opt/R/arm64/lib/libintl.a
fi

# -- download the correct R version
echo "Downloading R-$VERSION source code..."
curl -O $SOURCE
tar -xzvf R-"$VERSION".tar.gz
echo "Done"

# -- configure and make the R source files
R_DIR=$(tar -tzf R-"$VERSION".tar.gz | head -1 | cut -f1 -d"/")
echo "Switching into $R_DIR directory..."
cd "$R_DIR" || exit 1
echo "In $(pwd)!"
echo "Configuring installation..."

BIN_PATH="/opt/R/arm64/gfortran/bin"
CC=$(find "$BIN_PATH" -name '*gcc')
CXX=$(find "$BIN_PATH" -name '*g++')
FC=$(find "$BIN_PATH" -name '*-gfortran')
# TODO: Change LDFLAGS and CFLAGS
./configure \
    "LDFLAGS=-L/opt/R/arm64/gfortran/lib -L/opt/R/arm64/lib" \
    "CFLAGS=-I/opt/R/arm64/include -I/opt/R/arm64/gfortran/include" \
    CPPFLAGS="-D__ACCELERATE__" \
    CC="$CC -framework Foundation -lobjc" \
    CXX="$CXX" \
    FC="$FC" \
    F77="$FC" \
    --x-libraries=/opt/X11/lib \
    --x-includes=/opt/X11/include \
    --prefix=/opt/R/"$R_DIR" \
    --enable-memory-profiling \
    --enable-R-shlib \
    --with-tcltk \
    --with-blas \
    --with-lapack \
    --with-readline \
    --with-x \
    --with-cairo \
    --with-libpng \
    --with-jpeglib \
    --with-libtiff
echo "Making $R_DIR..."
make

# -- install the R source files
echo "Installing from source..."
sudo make install
echo "Done"

# -- update the system symlinks to the version just installed
echo "Creating symlinks"
if [ -f /usr/local/bin/R ]
then
    sudo rm /usr/local/bin/R
    sudo ln -s /opt/R/"$R_DIR"/bin/R /usr/local/bin/R
fi
if [ -f /usr/local/bin/Rscript ]
then
    sudo rm /usr/local/bin/Rscript
    sudo ln -s /opt/R/"$R_DIR"/bin/Rscript /usr/local/bin/Rscript
fi
echo "Done!"

# -- check if the installation succeeded
echo "Testing installation was succesful:"
/opt/R/"$R_DIR"/bin/R --version || exit 1
echo "Successful is above returned a version number!"

echo "Cleaning up..."
cd ..
rm -r R-*
#rm gfortran-12.0.1-20220312-is-darwin20-arm64.tar.xz
echo "Finished cleaning up!"

exit 0
