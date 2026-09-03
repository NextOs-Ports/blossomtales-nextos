# Blossom Tales: The Sleeping King — universal PortMaster port (AArch64)

Native AArch64 port of the Android release of **Blossom Tales: The Sleeping King**
for Linux handhelds — NextOS, R36S/ArkOS-class, dArkOS, ROCKNIX, muOS, EmuELEC and
any firmware with PortMaster. A so-loader: the game's native libraries and the
MonoVM run on plain Linux, with no Android and no dex interpreter underneath.

**Language / Idioma:** [English](#english) · [Português](#português)

> ### ⚠️ Bring your own data · Traga os seus próprios dados
> This repository and its releases contain **no game data** — no APK, no Android
> libraries, no assets. You supply the copy you legally own and the port installs
> it on the device at first launch.
>
> Este repositório e as suas releases **não contêm dados do jogo**. Você fornece
> a sua própria cópia legal e o port a instala no aparelho na primeira abertura.

## Download

The packaged port is on the [Releases](../../releases/latest) page: download `blossomtales.zip` and
install it with PortMaster, or extract it at the root of your ROM collection.

| | |
|---|---|
| Game | Blossom Tales: The Sleeping King 1.0.0 (`com.FDGEntertainment.BlossomTales.gp`) |
| Engine | MonoGame on .NET for Android (MonoVM) |
| Architecture | AArch64 (`arm64-v8a`) |
| Graphics | OpenGL ES 2.0 |
| SDL | the firmware's own — none ships in the ZIP |
| Audio | system OpenAL; AAC soundtrack decoded in-process (minimp4 + FDK-AAC) |
| Port version | 1.4.0 |

## Install in three steps

1. Extract `blossomtales.zip` at the ROM root — `Blossom Tales.sh` lands in `ports/`, next to
   the `blossomtales/` folder.
2. Put your own Android copy of the game into `ports/blossomtales/gamedata/`
   (`.apk`, `.apkm`, `.apks`, `.xapk` or the splits `.zip`; the file name does not matter).
3. Open **Blossom Tales** from the Ports menu. The first launch validates your copy,
   installs it and starts the game.

Full instructions, including the reference identity of the accepted copy, are in
[`INSTALLATION.md`](INSTALLATION.md).

## Controls, briefly

**A** attack / talk / confirm · **B** use item (back in menus) · **X** use tool ·
**Y** menu · **L1/R1** cycle items · **L3** journal · **R3** map · **START** pause.
Left stick and D-pad move.

Every button is remappable in `NEXTOSCONTROLLERS.gptk` inside the port folder.
**SELECT + START on the same controller** exits cleanly, saving first.

## License · Licença

Port code and its licenses: see [Licenças](#licenças).
Blossom Tales: The Sleeping King is © Castle Pixel / FDG Entertainment. This port is
an independent project with no affiliation with, or endorsement by, the developers.

---

## English

**Blossom Tales: The Sleeping King** runs on Linux handhelds through a so-loader: the
game's Android native libraries are mapped into the process, the MonoVM / .NET for
Android is started, the JNI the game expects is answered, and MonoGame receives a GLES2
context created by the system SDL. There is no emulation, no Android running underneath
and no dex being interpreted.

### Architecture and compatibility

| Item | Value |
|---|---|
| Architecture | AArch64 |
| Required GLIBC | at most `GLIBC_2.27` (public ceiling: 2.30) |
| Graphics | OpenGL ES 2.0 |
| SDL | **the system's**, always; the package ships no `libSDL*` and never shadows the firmware's |
| Audio | system OpenAL |
| Resolution | whatever SDL reports; the port never pins a resolution |

### Audio: why the decoder is built in

The soundtrack is 43 `.m4a` files — AAC-LC, 48 kHz, stereo, in an MP4 container. An
earlier version of this port decoded them by calling the system `ffmpeg`/`ffprobe`. That
does not hold for a universal package: on a device without those tools the game opens
**silent**, and "opens without music" is a failure.

The decoder is now internal (`src/aac_decoder.c`): **minimp4** for the container and
**FDK-AAC** for the AAC, linked statically. No external process, no `system()`, no path
belonging to the machine's owner.

Output alignment subtracts the decoder's `outputDelay` **plus** the MP4 edit list's
`media_time`, respects the declared duration and drains the decoder at the end of the
track. Without that the track starts with ~58 ms of silence and ends 36 ms early —
audible as a seam on every loop. Measured file by file, the 43 tracks come out with the
**same sample count** as `ffmpeg` and a mean difference of ~6 LSB (−58 dB), which is
just rounding between decoders.

### Controls

Controls come from `NEXTOSCONTROLLERS.gptk` in the game folder and are **read at
runtime** (nxinput 0.10.2): edit the actions on the right to change buttons, `null`
disables a button and `native` keeps the original behavior. The valid action list is in
`adapter/adapter-contract.json`.

| Control | Action (gameplay) | Menu |
|---|---|---|
| A | player.attack (act / talk / confirm) | menu.accept |
| B | player.use_item | menu.back |
| X | player.use_tool | native |
| Y | player.open_menu | native |
| L1 / R1 | player.select_previous / player.select_next | native |
| L3 | player.open_journal | native |
| START | system.pause | native |
| SELECT | system.back | native |
| D-pad, sticks, L2/R2, R3 | native (R3 = pointer click / map) | native |

The right stick moves a pointer (P1) and R3 clicks; the pointer fades after 2 s. The
game's button glyphs follow the map's `FACE_LAYOUT` (retro = Nintendo labels, modern =
Xbox).

`SELECT + START` exits: the port delivers `onPause` (which writes the save) and only
then quits. SELECT on one controller and START on another never exit.

### Repository layout

| Path | What it is |
|---|---|
| `src/` | loader, shims and decoder sources |
| `build_buster.sh` | reproducible public build (Debian buster, glibc 2.28) |
| `Dockerfile.builder` | build image |
| `vendor/PINS.txt` | versions and SHA-256 of the third-party components |

See `INSTALLATION.md` for installation and `STUDY.md` for the technical study.

---

## Português

Runtime que roda a versão Android de **Blossom Tales: The Sleeping King** em
consoles portáteis Linux, pelo padrão PortMaster.

O pacote **não traz o jogo**. Os dados vêm da cópia legal do próprio usuário e
são extraídos no aparelho na primeira execução. Leia `INSTALLATION.md`.

## O que este port é

Um *so-loader*: ele mapeia as bibliotecas nativas Android do jogo no processo,
sobe a MonoVM / .NET for Android, responde a JNI que o jogo espera e entrega ao
MonoGame um contexto GLES2 criado pelo SDL do sistema. Não há emulação, não há
Android rodando por baixo e não há dex sendo interpretado.

## Arquitetura e compatibilidade

| Item | Valor |
|---|---|
| Arquitetura | AArch64 |
| GLIBC exigida | no máximo `GLIBC_2.27` (teto público da casa: 2.30) |
| Gráficos | OpenGL ES 2.0 |
| SDL | **a do sistema**, sempre; o pacote não traz `libSDL*` nem sombreia a do CFW |
| Áudio | OpenAL do sistema |
| Resolução | a que o SDL reportar; o port **não** crava resolução |

## Áudio: por que existe um decodificador embutido

A trilha são 43 arquivos `.m4a` — AAC-LC, 48 kHz, estéreo, em container MP4.
A versão anterior deste port, feita para um sistema específico, decodificava
chamando `ffmpeg`/`ffprobe` do sistema. Isso não vale para um pacote universal:
num aparelho sem essas ferramentas o jogo abre **mudo**, e "abre sem música" é
falha.

O decodificador agora é interno (`src/aac_decoder.c`): **minimp4** para o
container e **FDK-AAC** para o AAC, ligado estaticamente. Nenhum processo
externo, nenhum `system()`, nenhum caminho do dono da máquina.

O alinhamento da saída desconta o `outputDelay` do decodificador **mais** o
`media_time` da *edit list* do MP4, respeita a duração declarada e drena o
decodificador no fim da faixa. Sem isso a faixa começa com ~58 ms de silêncio e
termina 36 ms cedo — audível como costura a cada volta do loop. Medido arquivo
a arquivo: as 43 faixas saem com o **mesmo número de amostras** que o `ffmpeg`
e diferença média de ~6 LSB (−58 dB), que é só arredondamento entre
decodificadores.

## Controles

Os controles vêm do `NEXTOSCONTROLLERS.gptk` da pasta do jogo e são LIDOS EM
TEMPO DE EXECUÇÃO (nxinput 0.10.2): edite as ações à direita para trocar
botões; `null` desliga um botão; `native` deixa o comportamento original. A
lista de ações válidas está em `adapter/adapter-contract.json`. Padrão:

| Controle | Ação (gameplay) | Menu |
|---|---|---|
| A | player.attack (ação/falar/confirmar) | menu.accept |
| B | player.use_item | menu.back |
| X | player.use_tool | nativo |
| Y | player.open_menu | nativo |
| L1 / R1 | player.select_previous / player.select_next | nativo |
| L3 | player.open_journal | nativo |
| START | system.pause | nativo |
| SELECT | system.back | nativo |
| D-pad, analógicos, L2/R2, R3 | nativos (R3 = clique da seta / mapa) | nativos |

O analógico direito move uma seta (P1) e R3 clica; a seta some após 2 s.
Os ícones de botão do jogo seguem o `FACE_LAYOUT` do mapa (retro = rótulos
Nintendo, modern = Xbox).

`SELECT + START` encerra: o port entrega `onPause` (que grava o save) e só
então sai. SELECT num controle e START noutro NUNCA encerram.

## Estrutura

| Caminho | O que é |
|---|---|
| `src/` | fonte do loader, shims e decodificador |
| `build_buster.sh` | build público reproduzível (Debian buster, glibc 2.28) |
| `Dockerfile.builder` | imagem do build |
| `vendor/PINS.txt` | versões e SHA-256 dos componentes de terceiros |
| `extractor.json` | receita do NXExtract |
| `nxproject.json` | manifesto V4 do port |

## Build

```sh
./build_buster.sh          # -> blossomtales-nextos
```

O build roda dentro de um container Debian 10 para garantir o teto de GLIBC.
O FDK-AAC é baixado por URL fixa e conferido por SHA-256 antes de compilar
(`vendor/PINS.txt`).

## Licenças

Código do port: GPL-3.0-only (`LICENSE`). Terceiros embutidos e componentes do
sistema: `NOTICE.md` e `SBOM.md`.
