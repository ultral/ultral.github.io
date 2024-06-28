---
redirect_from: "/make-cm-not-bash.html"
---
# Make configuration management not bash

[Russian version](make-cm-not-bash-ru.md)

Why do we need configuration management ?

Some years ago system administrators thought that servers are their pets. World is changing. Servers are cattle.

If we think that our infrastructure is code, then we should not reinvent the wheel. There are a lot of good practices exist:

* [Write tests](ansible-testing-en.md).
* Don't produce "write only" code. Vast majority of time we read code instead of write.
* Do not reinvent the wheel, Use & improve existing patterns/ roles / cookbooks / ...
* No man is an island. Only team can create production ready product

Let us talk about BASH. It is awesome & magnificent script language isn't it? But real issue is that it is extremely hard to create stable, upscale & supportable bash scripts. You must find out the high-qualified engineers for that task. Configuration management solutions (i.e. ansible) allow create ordinary code. It allows hiring cheaper or faster.

Configuration management does not mean that you reduce count of string in your code, it means create model of your infrastructure and split it into some layers.

## Bash

Let us take a look at extremely simple example:

* Get all files from current directory.
* Copy the files into another directory with modified name.

The first idea is:

```bash
for i in * ; do cp $i /some/path/$i.bak ; done
```

Pretty good. However what if filename contains _space_? We are clever guys, we use quotes:

```bash
for i in * ; do cp "$i" "/some/path/$i.bak" ; done
```

Are we finished? Nope! What if the directory is empty? Globing fails in this case.

```bash
find . -type f -exec mv -v {} dst/{}.bak \;
```

Have we finished? Not yet... We forgot that filename might contain `\n` character.

```bash
touch x
mv x  "$(printf "foo\nbar")"
find . -type f -print0 | xargs -0 mv -t /path/to/target-dir
```

It is only one of billions examples. Have you ever heard that bash has _hash_ structure?

```bash
#!/bin/bash

function print_animals() {
  local local_animals

  eval "declare -A local_animals="${1#*=}

  for sound in "${!local_animals[@]}" ; do
    echo "$sound - ${local_animals[$sound]}"
  done
}
declare -A animals
animals["moo"]="cow"
animals["woof"]="dog"

print_animals "$(declare -p animals)"
```

## Conclusion

Configuration management allows do decrease entrance level in particular parts of system, tasks. It means that you do not need to have only gurus in your projects/teams. It is enough to have some gurus who understand whole picture and understand how to split it into easy tasks. In case of bash, everyone in your team must understand that it is cunning  thing. *Make configuration management not bash*
