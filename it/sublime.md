# How to prepare sublime

It's better [configure VS Code](vscode.md) because sublime plugins for ansible is out of date.

Download [sublime text 3](https://www.sublimetext.com/3)

## Package Control

please visit [packagecontrol.io](https://packagecontrol.io/installation):

* run console (<code>ctrl+`</code>)
* insert code actual on [packagecontrol.io](https://packagecontrol.io/installation):

```python
import urllib.request,os,hashlib; h = '6f4c264a24d933ce70df5dedcf1dcaee' + 'ebe013ee18cced0ef93d5f746d80ef60'; pf = 'Package Control.sublime-package'; ipp = sublime.installed_packages_path(); urllib.request.install_opener( urllib.request.build_opener( urllib.request.ProxyHandler()) ); by = urllib.request.urlopen( 'http://packagecontrol.io/' + pf.replace(' ', '%20')).read(); dh = hashlib.sha256(by).hexdigest(); print('Error validating download (got %s instead of %s), please try manual install' % (dh, h)) if dh != h else open(os.path.join( ipp, pf), 'wb' ).write(by)
```

## plugin install

* `cmd + shift + p` for mac or `ctr + shift + p` for windows
* type `Package Control: Install Package`
* type package name

## plugin remove

* `cmd + shift + p` for mac or `ctr + shift + p` for windows
* type `Package Control: Remove Package`
* type package name

### sublime linter

* `ctrl + shift + p` or `cmd + shift + p`
* install package
* SublimeLinter

### sublime Jinja2

* `ctrl + shift + p` or `cmd + shift + p`
* install package
* Jinja2

### sublime rubocop

 [style guide](https://github.com/bbatsov/ruby-style-guide)

* install ruby (windows only) [download](https://rubyinstaller.org/downloads/)
* install rubocop gem

for mac os or linux

```bash
sudo gem install rubocop
```

for windows

```bash
gem install rubocop --http-proxy=http://some.proxy.example.com:3128
```

* install [SublimeLinter-rubocop](https://packagecontrol.io/packages/SublimeLinter-rubocop)
  * `ctrl + shift + p` or `cmd + shift + p`
  * install package
  * SublimeLinter-rubocop

### sublime shellcheck

[https://github.com/koalaman/shellcheck](https://github.com/koalaman/shellcheck)

* install shell check
  * for mac os `brew install shellcheck`
  * for centos `yum -y install epel-release ; yum install ShellCheck`
  * for windows [download](https://storage.googleapis.com/shellcheck/shellcheck-latest.zip) & add to PATH
* install [SublimeLinter-shellcheck](https://packagecontrol.io/packages/SublimeLinter-shellcheck)
  * `ctrl + shift + p` or `cmd + shift + p`
  * install package
  * SublimeLinter-shellcheck

### sublime yaml lint

* install [SublimeLinter-contrib-yaml-lint](https://packagecontrol.io/packages/SublimeLinter-contrib-yaml-lint)
  * `ctrl + shift + p` or `cmd + shift + p`
  * install package
  * SublimeLinter-contrib-yaml-lint

```bash
gem install yaml-lint
```

### sublime applysyntax

it is needed for ansible lint

* install [ApplySyntax](https://github.com/facelessuser/ApplySyntax)
  * `ctrl + shift + p` or `cmd + shift + p`
  * install package
  * ApplySyntax

```bash
Sublime Text -> Preferences -> Package Settings -> ApplySyntax -> Settings - User
```

```json
    "syntaxes": [{
        "name": "Ansible/Ansible",
        "rules": [
          {"file_name": ".*/tasks/.*.yml$"},
          {"file_name": ".*/handler/.*.yml$"},
          {"file_name": ".*/*_vars/.*.yml$"},
          {"file_name": ".*/roles/.*.yml$"},
          {"file_name": ".*/playbooks/.*.yml$"},
          {"file_name": ".*/.*ansible.*/.*.yml$"},
          {"file_name": ".*/.*explotation.*/.*.yml$"},
          {"file_name": ".*/.*provision.*/.*.yml$"}
        ]
      }]
```

### sublime yaml

install yaml lint

```bash
pip install yamllint --proxy http://some.proxy.example.com:3128
```

* install [SublimeLinter-contrib-yamllint](https://github.com/thomasmeeus/SublimeLinter-contrib-yamllint)
  * `ctrl + shift + p` or `cmd + shift + p`
  * install package
  * SublimeLinter-contrib-yamllint

### sublime ansible
[https://github.com/mliljedahl/SublimeLinter-contrib-ansible-lint](https://github.com/mliljedahl/SublimeLinter-contrib-ansible-lint)

* install [python](https://www.python.org/ftp/python/3.7.0/python-3.7.0a4-amd64.exe)
* install ansible-lint (I've failed install it on windows :-( only macos & linux )

```bash
pip install ansible-lint --proxy http://some.proxy.example.com:3128
```

* install [SublimeLinter-contrib-ansible-lint](https://packagecontrol.io/packages/SublimeLinter-contrib-ansible-lint)
  * `ctrl + shift + p` or `cmd + shift + p`
  * install package
  * SublimeLinter-contrib-ansible-lint

### sublime pylint

install pylint

```bash
pip install pylint --proxy http://some.proxy.example.com:3128
```

* install [SublimeLinter-pylint](https://github.com/SublimeLinter/SublimeLinter-pylint)
  * `ctrl + shift + p` or `cmd + shift + p`
  * install package
  * SublimeLinter-pylint

## Spell checking

By default Sublime text has only EN dictionary. For other languages you need dictionaries. You can download it [here](https://github.com/titoBouzout/Dictionaries)

Press `F6` for enable/disable spell checking

## Markdown в Sublime

Sublime text 3 has it by default. however I advise to improve it.

### MarkdownEditing
[MarkdownEditing](https://packagecontrol.io/packages/MarkdownEditing)

* close all `*.md` files
 `ctrl + shift + p` or `cmd + shift + p`
* install package
* MarkdownEditing
* Create/open markdown file
* Open syntax preferences `Preferences/Settings - Syntax Specific`, add:

```json
{
    "word_wrap": true,
    "wrap_width": 120,
    "color_scheme": "Packages/MarkdownEditing/MarkdownEditor.tmTheme"
}
```

## sublime settings

* for mac (`cmd + ,`)
* for windows `preferences -> settings`

```json
{
  "color_scheme": "Packages/User/SublimeLinter/Monokai (SL).tmTheme",
  "default_encoding": "UTF-8",
  "default_line_ending": "unix",
  "dictionary": "Packages/Russian-English Bilingual.dic",
  "ensure_newline_at_eof_on_save": true,
  "font_size": 11,
  "ignored_packages":
  [
    "Markdown",
    "SublimeLinter-pyyaml",
    "Vintage"
  ],
  "rulers":
  [
    80
  ],
  "spell_check": true,
  "tab_size": 2,
  "translate_tabs_to_spaces": true,
  "trim_trailing_white_space_on_save": true,
  "word_wrap": "true"
}
```

#### Hints

* Via `Goto anything` (`Cmd+p` or `ctrl + p`) you can fast switch throw:
  * open files/projects
  * `@` navigate by headers
  * `:` line number

### Table Editor

[Table Editor](https://packagecontrol.io/packages/Table%20Editor)

### Markdown preview

[Markdown Preview](https://packagecontrol.io/packages/Markdown%20Preview)

#### SublimeLinter-annotations

## WSL Integration

1. Enable WSL `Enable-WindowsOptionalFeature -Online -FeatureName Microsoft-Windows-Subsystem-Linux` .
2. Checkout [repo](https://github.com/ultral/sublime_wsl_helpers.git) .
3. Add the `helpers` dir from the repo to the `PATH` variable.
4. Run `sudo install_me.sh` from the repo inside WSL.
