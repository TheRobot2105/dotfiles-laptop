{
  lib,
  stdenv,
  fetchgit,
  libevdev,
  python312,
  python312Packages,
  ninja,
  meson,
  inih,
  pkg-config,
}:
stdenv.mkDerivation {
  pname = "howdy";
  version = "v2.6.1";
  src = fetchgit {
    url = "https://github.com/boltgolt/howdy.git";
    sha256 = "sha256-y/BVj6DdnppIegAEm2FtrOdiqF23Q+U6v2EZ4A9H7iU=";
  };

  postPatch = ''
    substituteInPlace meson.options \
    --replace-fail "option('python_path', type: 'string', value: '/usr/bin/python', description: 'Set the path to the python executable')" "option('python_path', type: 'string', value: '${python312}/bin/python3.12', description: 'Set the path to the python executable')"       
  '';

  nativeBuildInputs = [
    libevdev
    python312
    #python312Packages.pip
    #python312Packages.setuptools
    #python312Packages.wheel
    ninja
    meson
    pkg-config
    inih
  ];

  buildPhase = ''

    meson setup build
    meson compile -C build
    meson install -C build 
  '';

  meta = with lib; {
    license = licenses.mit;
    description = "";
    homepage = "";
    maintainers = with maintainers; [ therobot2105 ];
  };
}
