SOURCES = \
    src/graphics.asm \
    src/player_missile.asm \
    src/main.asm \
    src/player_graphics.asm \
    src/level_1.asm \
    src/level_2.asm \
    src/level_3.asm \
    src/game_over.asm \
    audio/songs/game_song.asm \
    tools/hUGEDriver.asm \
    audio/audio.asm

INC_FILES = $(shell find src -type f -name '*.inc')
TLM_FILES = $(shell find src -type f -name '*.tlm')
CHR_FILES = $(shell find src -type f -name '*.chr')

OBJECTS = $(patsubst %.asm,build/%.o,$(SOURCES))

.PHONY: all clean

all: game.gb

game.gb: $(OBJECTS)
	rgblink --dmg --tiny --map game.map --sym game.sym -o game.gb $(OBJECTS)
	rgbfix -v -p 0xFF game.gb

build/%.o: %.asm $(INC_FILES) $(TLM_FILES) $(CHR_FILES)
	@mkdir -p $(dir $@)
	rgbasm -I include -I audio -I audio/songs -I tools -o $@ $<

clean:
	rm -rf build
	rm -f game.gb game.map game.sym
