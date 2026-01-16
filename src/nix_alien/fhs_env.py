from collections.abc import Iterable
from pathlib import Path
from typing import Optional

from . import _impl

FLAKE_TEMPLATE = "fhs_env_flake.template.nix"
MODULE = "fhs-env"


def create_fhs_env_drv_flake(
    program: str,
    silent: bool = False,
    additional_libs: Iterable[str] = (),
    additional_packages: Iterable[str] = (),
) -> str:
    return _impl.create_template_drv_flake(
        template=FLAKE_TEMPLATE,
        program=program,
        silent=silent,
        additional_libs=additional_libs,
        additional_packages=additional_packages,
    )


def create_fhs_env_flake(
    program: str,
    args: Iterable[str],
    destination: Path,
    recreate: bool = False,
    silent: bool = False,
    additional_libs: Iterable[str] = (),
    additional_packages: Iterable[str] = (),
    select_candidates: Optional[str] = None,
) -> None:
    return _impl.create_flake(
        template=FLAKE_TEMPLATE,
        program=program,
        args=args,
        destination=destination,
        recreate=recreate,
        silent=silent,
        additional_libs=additional_libs,
        additional_packages=additional_packages,
        select_candidates=select_candidates,
    )


def main(args=None):
    return _impl.main(
        module=MODULE,
        create_flake_fn=create_fhs_env_flake,
        args=args,
    )
