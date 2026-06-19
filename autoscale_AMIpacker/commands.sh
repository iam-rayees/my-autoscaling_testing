## For Windows systems:
packer.exe validate --var-file=packer.auto.pkrvars.hcl packer.pkr.hcl

packer.exe inspect --var-file=packer.auto.pkrvars.hcl packer.pkr.hcl

packer.exe build --var-file=packer.auto.pkrvars.hcl packer.pkr.hcl

## For Linux systems:
packer init packer.pkr.hcl

packer validate --var-file=packer.auto.pkrvars.hcl packer.pkr.hcl

packer inspect --var-file=packer.auto.pkrvars.hcl packer.pkr.hcl

packer build --var-file=packer.auto.pkrvars.hcl packer.pkr.hcl

