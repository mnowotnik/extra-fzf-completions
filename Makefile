
TARGETS=docker kubectl jira

all: $(TARGETS)

clean:
	rm -f zsh/* bash/*

$(TARGETS): %: bash/%-fzf-completion.bash zsh/%-fzf-completion.zsh

bash/%-fzf-completion.bash: src/%.tmpl.sh src/process.sh
	rm -f $@
	bash src/process.sh $< $* bash > $@

zsh/%-fzf-completion.zsh: src/%.tmpl.sh src/process.sh
	rm -f $@
	bash src/process.sh $< $* zsh > $@
