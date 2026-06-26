{
  lib,
  ast-grep,
  difftastic,
  fetchFromGitHub,
  makeWrapper,
  onnxruntime,
  python3Packages,
  rustPlatform,
  scc,
}:
python3Packages.buildPythonApplication rec {
  pname = "headroom-ai";
  version = "0.27.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "headroomlabs-ai";
    repo = "headroom";
    rev = "v${version}";
    hash = "sha256-059AC105XH6BOnHvQjC3EueUL3Z6t1fD29fHqHkkmX0=";
  };

  cargoDeps = rustPlatform.fetchCargoVendor {
    inherit src;
    hash = "sha256-gd5eh1gL2wJTjKMQN2DSjSGFfDiUzC+jIJVjBYU+mJ8=";
  };

  nativeBuildInputs = [
    makeWrapper
    rustPlatform.cargoSetupHook
    rustPlatform.maturinBuildHook
  ];

  buildInputs = [
    onnxruntime
  ];

  ORT_LIB_PATH = "${onnxruntime}/lib";
  ORT_PREFER_DYNAMIC_LINK = "1";

  postPatch = ''
    substituteInPlace headroom/cli/wrap.py \
      --replace-fail 'cmd = [sys.executable, "-m", "headroom.cli", "proxy", "--port", str(port)]' \
                     'cmd = [shutil.which("headroom") or sys.argv[0], "proxy", "--port", str(port)]'

    substituteInPlace headroom/install/runtime.py \
      --replace-fail 'return [sys.executable, "-m", "headroom.cli", "proxy", *manifest.proxy_args]' \
                     'return [*resolve_headroom_command(), "proxy", *manifest.proxy_args]'
  '';

  dependencies = with python3Packages; [
    click
    fastapi
    fastembed
    h2
    httpx
    litellm
    magika
    mcp
    numpy
    onnxruntime
    openai
    opentelemetry-api
    opentelemetry-exporter-otlp-proto-http
    opentelemetry-sdk
    pydantic
    rich
    sqlite-vec
    tiktoken
    transformers
    uvicorn
    watchdog
    websockets
    zstandard
  ];

  pythonRemoveDeps = [
    "ast-grep-cli"
  ];

  # Headroom 0.27.0 asks for litellm >= 1.86.2, while nixos-26.05 currently
  # carries 1.83.14. Headroom imports litellm lazily for non-core providers.
  pythonRelaxDeps = [
    "litellm"
  ];

  makeWrapperArgs = [
    "--prefix"
    "PATH"
    ":"
    (lib.makeBinPath [
      ast-grep
      difftastic
      scc
    ])
    "--prefix"
    "LD_LIBRARY_PATH"
    ":"
    "${onnxruntime}/lib"
  ];

  doCheck = false;

  pythonImportsCheck = [
    "headroom"
    "headroom._core"
    "headroom.cli"
  ];

  meta = {
    description = "Context optimization layer for LLM applications";
    homepage = "https://github.com/headroomlabs-ai/headroom";
    license = lib.licenses.asl20;
    mainProgram = "headroom";
    platforms = lib.platforms.linux;
  };
}
