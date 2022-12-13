
SECRETS     = secrets.env
SECRETSTMPL = secrets.env.sample
REGISTRY    = registry.terraform.io
SAVEDPLAN   = terraform.tfplan

.PHONY: start
start: $(SECRETS)

.PHONY: init
init:
	terraform init

.PHONY: plan
plan: $(SECRETS)
	terraform plan -out $(SAVEDPLAN)

.PHONY: apply
apply: $(SECRETS)
	terraform apply $(SAVEDPLAN)

docs: README.html variables.tf main.tf
	$(MAKE) -C docs

.PHONY: secret secrets
secret secrets: $(SECRETS)

$(SECRETS):
	@ sed '/PM_/p;d;' $(SECRETSTMPL) > $(SECRETS)
	@ echo "Edit the file 'secrets.env'"
	@ echo "   See also: secrets-template.env"
	@ false

.PHONY: clean realclean distclean
clean:
	$(RM) terraform.tfstate*
	$(RM) examples/*/terraform.tfstate*
	$(RM) terraform.tfplan

realclean: clean
	$(RM) -r .terraform.* .terraform/

distclean: realclean
	$(RM) $(SECRETS)
	$(RM) README.html
	$(MAKE) -C docs distclean

README.html: README.md
	pandoc -f markdown -t html \
		--embed-resources --standalone \
		--css=docs/pandoc.css \
		--metadata title="Proxmox VM creation with Terraform" \
		--output=README.html \
		README.md
