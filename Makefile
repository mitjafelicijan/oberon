stack:
	docker compose -f stack.yaml up --no-deps --build --remove-orphans --force-recreate
