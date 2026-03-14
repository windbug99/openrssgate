from setuptools import find_packages, setup


setup(
    name="openrssgate",
    version="0.1.1",
    packages=find_packages(),
    install_requires=[
        "typer==0.16.1",
        "httpx==0.28.1",
    ],
    entry_points={
        "console_scripts": [
            "openrssgate=openrssgate.main:_run",
        ]
    },
)
