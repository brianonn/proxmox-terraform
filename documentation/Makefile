all: docs

docs: documentation.html

documentation.md: ../main.tf ../variables.tf ../outputs.tf 
	docker run --rm --volume "$$(pwd)/..:/terraform-docs" -u $$(id -u) quay.io/terraform-docs/terraform-docs:0.16.0 markdown /terraform-docs > documentation.md

documentation.html: documentation.md
	pandoc -f markdown -t html \
		 --embed-resources --standalone \
		 --css=pandoc.css \
		 --metadata title="Terraform Documentation for Proxmox VM creation" \
		 --output=documentation.html \
		 documentation.md


distclean:
	$(RM) documentation.md documentation.html
