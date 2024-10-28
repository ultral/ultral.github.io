# Подключаем NTFS на запись в Mac OS X Yosemite 10.10

*Date: 2014-12-22*

С недавних пор по воле судеб стал обладателем Mac OS X Yosemite 10.10 и столкнулся с неприятной особенностью, что не могу записывать на внешний диск отформатированный под ntfs. Написал небольшую инструкцию, вдруг кому пригодится. Если интересно, прошу под кат.

Я в курсе про [tuxera](http://www.tuxera.com/community/ntfs-3g-download/) и про [paragon](http://www.paragon.ru/home/ntfs-mac/), но вот не хочется платить за софтину, которая необходима очень редко и  можно собрать из исходников.

Думаю все у нас тут люди не глупые собрались, и понимают что нижеприведенную инструкцию вы будете использовать на свой страх и риск.

На данный момент квест выглядит примерно так:

1. Устанавливаем Xcode из Appstore
необходимо будет потом запустить, чтобы установились компоненты и принять соглашение или

```bash
xcodebuild -license
```

2. Доставляем тулзы

```bash
xcode-select --install
```

3. Устанавливаем [macports](https://www.macports.org/install.php)

4. Апдейт портов

```bash
sudo port -v selfupdate
```

5. Ставим драйвер

```bash
sudo port install ntfs-3g
```

6. Ставим последнюю подписанную версию [osxfuse](https://osxfuse.github.io/2014/06/09/OSXFUSE-2.7.0.html)
стоит пояснить, этот шаг изначально не планировался, но сообщение вида `/Library/Filesystems/osxfusefs.fs/Support/osxfusefs.kext failed to load - (libkern/kext) not loadable (reason unspecified); check the system/kernel logs for errors or try kextutil(8)` внесло коррективы

7. Подменяем osxfuse

```bash
sudo mv /opt/local/Library/Filesystems/osxfusefs.fs /opt/local/Library/Filesystems/osxfusefs.fs_ports
sudo ln -s /Library/Filesystems/osxfusefs.fs /opt/local/Library/Filesystems/osxfusefs.fs
```

8. Тестовое монтирование в моем случае

```bash
sudo umount /Volumes/backup/
mkdir /Volumes/backup
sudo ntfs-3g -o uid=501 -o gid=20 /dev/disk2s1 /Volumes/backup/
```

Свой  uid и gid можно используя команду id.

## Итог

Из минусов отмечу, что finder при ручном монтировании не отображает в боковой панели диск, не очень приятно.
Еще я пробовал подменять `/System/Library/Filesystems/ntfs.fs/Contents/Resources/mount_ntfs` на свой скрипт, который монтирует диск, что бы минимизировать действия в консоле, но как-то не прижилось.

Надо признаться, выглядит немного дико и сложно, чтобы скопировать файл на флэшку, может у кого есть более красивое решение?

## UPD
забавно получается… когда монтирую ntfs с опцией nobrowse — разрешает писать, но не отображается в finder в панели слева, без этой опции — только на чтение доступно… проверил на 2 маках. где логика?

* http://habrahabr.ru/post/246517/#comment_8191275
* http://habrahabr.ru/post/246517/#comment_8191149