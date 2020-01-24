%global debug_package %{nil}

Name:           pvtbox
Version:        %{_pkg_version}
Release:        %{_pkg_release}
Summary:        Pvtbox is a high-speed tool for Peer-2-peer file transfer
License:        Pvtbox terms and conditions
Group:          Applications/Internet
URL:            https://pvtbox.net
Source0:        app.zip
Source1:        service.zip
Source2:        xfiles.tar.xz
AutoReqProv:    no
%if %{defined suse_version}
#Requires:       python3-base python3-pyside2 libcurl4
Requires:       libcurl4
%else
#Requires:       python36-libs libcurl
Requires:       libcurl
%endif
Obsoletes:      none
Provides:       pvtbox

%description
Peer-2-peer file transfer
 Pvtbox is a high-speed tool which provides with an opportunity to transfer files from one device to another without storing them on intermediate servers.
 .
 Stylish and user-friendly design in combination with powerful functionality will make it easier for you to solve everyday tasks.
 .
 Features:
 .
 - Fast file transfer directly from one device to another.
 Photos, videos, music, documents and any other types of files are transferred by 1 click and only between your devices.
 .
 - Confidentiality
 When you install Pvtbox, all data stores nowhere else but, on your devices, (PC, Mac, server, tablet, Smartphone, etc.).
 From now on, you are the only owner of your personal information.
 .
 - High-Grade Security
 Pvtbox has a built-in end-2-end encryption, (RSA, ECDSA or TLS 2048-bit keys), meaning that data, when being transmitted across networks, cannot be intercepted, wiretapped or substituted in any way.
 .
 - The speed, size and number of files are not limited.
 Use the traffic-handling capacity of your network most effectively.
 .
 - Backup photos from your Smartphone to a PC.
 And to any other device as well, whether it is another Smartphone, server, etc.
 .
 - Secure File Sharing and Collaboration
 Share your files and folders with other users, work together with them on common documents.
 .
 Protect your data. Speed up your Business. Get Private. Get Pvtbox!

%prep
rm -rf app
rm -rf service
unzip %{SOURCE0}
unzip %{SOURCE1}
tar xf %{SOURCE2}

%build

%install
mkdir -p -m0755 %{buildroot}/opt/pvtbox
cp -rf %{_builddir}/app/* %{buildroot}/opt/pvtbox
cp -rf %{_builddir}/service/* %{buildroot}/opt/pvtbox

cd %{buildroot}/opt/pvtbox
#%{_sourcedir}/create_symlinks_2.sh
cd %{_builddir}

cp --remove-destination -rf %{_builddir}/xfiles/* %{buildroot}


%post
# Setup repos
DISTRO_ID=$(grep -Po '^ID="?\K(\w+)' /etc/os-release)
case $DISTRO_ID in
"opensuse")
{
if [ -d "/etc/zypp/repos.d/" ]; then
REPO_FILE="/etc/zypp/repos.d/pvtbox.repo"
cat > "$REPO_FILE" << DATA
[pvtbox]
name=pvtbox
type=rpm-md
baseurl=https://installer.pvtbox.net/master/opensuse/amd64/
enabled=1
autorefresh=1
gpgkey=https://installer.pvtbox.net/pvtbox.net.gpg
gpgcheck=1
DATA
fi
} ;;
*)
{
REPO_FILE="/etc/yum.repos.d/pvtbox.repo"
cat > "$REPO_FILE" << DATA
[pvtbox]
name=pvtbox
type=rpm-md
baseurl=https://installer.pvtbox.net/master/centos/amd64/
enabled=1
autorefresh=1
gpgkey=https://installer.pvtbox.net/pvtbox.net.gpg
gpgcheck=1
DATA
} ;;
esac

# Import public gpgkey
KEY_EXISTS=1
rpm -q gpg-pubkey-9ac1a7fd-5ae9abe1 > /dev/null 2>&1 || KEY_EXISTS=0

if [ $KEY_EXISTS -ne 1 ]; then
KEY_FILE=$(mktemp /tmp/pvtbox.asc.XXXXXX || : )
if [ -n "$KEY_FILE" ]; then
    cat > "$KEY_FILE" << KEY_DATA
-----BEGIN PGP PUBLIC KEY BLOCK-----
Version: rpm-4.11.2 (NSS-3)

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
4bA=
=7Pd0
-----END PGP PUBLIC KEY BLOCK-----
KEY_DATA

mv /var/lib/rpm/.rpm.lock /var/lib/rpm/.rpm.lock_ || true
if [ $DISTRO_ID = "opensuse" ]; then
    mv /var/lib/rpm/Packages /var/lib/rpm/Packages_
    cp /var/lib/rpm/Packages_ /var/lib/rpm/Packages
fi
rpm --import $KEY_FILE 2>&1 || true
if [ $DISTRO_ID = "opensuse" ]; then
    rm -f /var/lib/rpm/Packages_
fi
mv /var/lib/rpm/.rpm.lock_ /var/lib/rpm/.rpm.lock || true
rm $KEY_FILE || true
fi
fi

# Extract plugins for file managers
tar xf /opt/pvtbox/fmplugins.tar.gz --no-overwrite-dir -C /


%postun
# Remove plugins for file managers
rm -f /usr/lib64/thunarx-2/pvtbox-thunar-menu.so
rm -f /usr/lib64/thunarx-3/pvtbox-thunarx-3-menu.so
rm -f /usr/lib64/nautilus/extensions-3.0/pvtbox-nautilus-menu.so
rm -f /usr/lib64/qt5/plugins/pvtbox-dolphin-menu.so
rm -f /usr/share/kservices5/pvtbox-dolphin-menu.desktop


%files
/opt
/usr

%changelog
* Mon May  6 2019 - axbu
- First packaging
