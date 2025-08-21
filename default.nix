{
  lib,
  python3,
  fetchFromGitHub,
}:

python3.pkgs.buildPythonApplication rec {
  pname = "pulsemeeter";
  version = "2.0.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "theRealCarneiro";
    repo = "pulsemeeter";
    rev = "v${version}";
    hash = "sha256-hmQI+E6WmYOK7oN7zTmshFZgJ0UiN2KdZ6ZiXwxRpNs=";
  };

  build-system = [
    python3.pkgs.babel
    python3.pkgs.setuptools
  ];

  dependencies = with python3.pkgs; [
    pulsectl
    pulsectl-asyncio
    pydantic
    pygobject
  ];

  pythonImportsCheck = [
    "pulsemeeter"
  ];

  meta = {
    description = "A pulseaudio and pipewire audio mixer inspired by voicemeeter";
    homepage = "https://github.com/theRealCarneiro/pulsemeeter";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ ];
    mainProgram = "pulsemeeter";
  };
}
