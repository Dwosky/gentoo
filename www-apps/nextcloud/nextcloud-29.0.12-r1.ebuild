# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit webapp

DESCRIPTION="Personal cloud that runs on your own server"
HOMEPAGE="https://nextcloud.com/"
SRC_URI="https://download.nextcloud.com/server/releases/${P}.tar.bz2"

S=${WORKDIR}/${PN}

LICENSE="AGPL-3"
KEYWORDS="amd64 ~arm ~arm64 ~x86"

IUSE="+curl +imagemagick mysql postgres +sqlite"
REQUIRED_USE="|| ( mysql postgres sqlite )"

RDEPEND="dev-lang/php[curl?,filter,gd,hash(+),intl,json(+),mysql?,pdo,posix,postgres?,session,simplexml,sqlite?,truetype,xmlreader,xmlwriter,zip]
	imagemagick? ( dev-php/pecl-imagick )
	virtual/httpd-php"

pkg_setup() {
	webapp_pkg_setup
}

src_install() {
	webapp_src_preinst

	insinto "${MY_HTDOCSDIR}"
	doins -r .
	keepdir "${MY_HTDOCSDIR}"/data

	webapp_serverowned -R "${MY_HTDOCSDIR}"/apps
	webapp_serverowned -R "${MY_HTDOCSDIR}"/data
	webapp_serverowned -R "${MY_HTDOCSDIR}"/config
	webapp_configfile "${MY_HTDOCSDIR}"/.htaccess

	webapp_postinst_txt en "${FILESDIR}"/php-argon2-en.txt

	webapp_src_install
}
