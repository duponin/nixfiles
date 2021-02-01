{ rustPlatform, fetchFromGitHub, stdenv, alsaLib, cairo, gdk-pixbuf, glib, gtk3
, pango, pkg-config, wrapGAppsHook, ... }:
rustPlatform.buildRustPackage rec {
  pname = "czkawka";
  version = "2.3.0";

  src = fetchFromGitHub {
    owner = "qarmin";
    repo = pname;
    rev = version;
    sha256 = "15j34crx4yxdqs1v87z58nddqqsn9c8mawmb9m8s3mx0narsamk6";
  };

  buildInputs = [ alsaLib cairo gdk-pixbuf gtk3 pango ];
  nativeBuildInputs = [ glib pkg-config wrapGAppsHook ];

  cargoSha256 = "157j3pq8b8p3c90lnbrk4sil8mjdzw9fw5nikfp6n0v9j18r93rv";

  meta = with stdenv.lib; {
    description =
      "Multi functional app to find duplicates, empty folders, similar images etc. ";
    homepage = "https://github.com/qarmin/czkawka";
    license = licenses.mit;
  };
}
