** Work in Progress **

Rebuilding Docker Compose stack in Ansible to make keeping things up to date easier in the future.

To run everything:
```ansible-playbook docker_stacks.yml```

To run a single stack:
```ansible-playbook docker_stacks.yml -e "filename=grafana"```

Future enhancements:
* Ability to generate config files from stack specific templates
* Ability to add environment (and others) using either list or dict (using `{% if my_variable is mapping %}` to see whether the item is a dict or map)