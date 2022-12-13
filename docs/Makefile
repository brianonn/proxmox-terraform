all: docs

docs: docs.html

docs.md: ../main.tf ../variables.tf ../outputs.tf 
	docker run --rm --volume "$$(pwd)/..:/terraform-docs" -u $$(id -u) quay.io/terraform-docs/terraform-docs:0.16.0 markdown /terraform-docs > docs.md

docs.html: docs.md
	pandoc -f markdown -t html \
		 --embed-resources --standalone \
		 --css=pandoc.css \
		 --metadata title="Terraform Documentation for Proxmox VM creation" \
		 --output=docs.html \
		 docs.md


distclean:
	$(RM) docs.md docs.html
