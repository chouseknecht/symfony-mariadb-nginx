
.PHONY: build_from_scratch composer console clean

composer:
	docker exec -i -t ansible_symfony_1 $(MAKECMDGOALS)

console:
	docker exec -i -t ansible_symfony_1 cd /symfony/symfony && php bin/$(MAKECMDGOALS)

clean:
	@./ansible/clean.sh
	rm -rf dist/*
	rm -rf symfony

build_from_scratch: clean
	ansible-container build	

demo:
	@echo "Run the demo"
	@AC_DEMO_MODE=1; ansible-container --debug run
