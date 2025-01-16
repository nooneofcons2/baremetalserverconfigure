.PHONY: allplaybooks

allplaybooks:
	@ansible-playbook -i inventory all-playbooks.yml --ask-vault-pass