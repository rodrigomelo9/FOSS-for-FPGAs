from pathlib import Path

project = 'Getting started with FOSS for FPGAs'
copyright = '2020, Rodrigo A. Melo, licensed under CC BY 4.0'
author = 'Rodrigo A. Melo (RAM)'
release = 'master'

extensions = ['recommonmark']

html_theme_options = {
    'logo_only': True,
    'home_breadcrumbs': False,
    'vcs_pageview_mode': 'blob',
}

html_context = {}
ctx = Path(__file__).resolve().parent / 'context.json'
if ctx.is_file():
    html_context.update(loads(ctx.open('r').read()))

html_theme_path = ["."]
html_theme = "_theme"
