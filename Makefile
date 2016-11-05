
.PHONY: build build_from_scratch composer console clean demo run

composer:
	docker exec -i -t ansible_symfony_1 /symfony/ansible/composer.sh $(filter-out $@, $(MAKECMDGOALS)) 

console:
	docker exec -i -t ansible_symfony_1 /symfony/ansible/console.sh $(filter-out $@, $(MAKECMDGOALS)) 

clean:
	@./ansible/clean.sh
	rm -rf dist/*
	rm -rf symfony

build:
	ansible-container build

build_from_scratch: clean
	ansible-container build	

demo:	
	@echo "Run the demo"
	rm -rf dist/*
	rm -rf symfony
	@AC_DEMO_MODE=1; ansible-container --debug run

run:
	ansible-container run

run_prod:
	ansible-container run --production
