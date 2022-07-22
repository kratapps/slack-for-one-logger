alias=okslack
alias_dev_org=okslack-dev

package_id=0337Q000000HIZo
version_name=1.1
version_id=04t7Q000000HlA1

scratch-org:
	sfdx force:org:create -s -a ${alias} -f config/project-scratch-def.json -d 30
	sfdx force:package:install -u ${alias} -r -w 60 -p 04t09000000vCa1 # One Logger
	sfdx force:package:install -u ${alias} -r -w 60 -p 04t5e000000vmwU # One Logger Utils
	sfdx force:source:push -u ${alias}

deploy-dev:
	sfdx force:source:deploy -u ${alias_dev_org} -p src/okslack --testlevel RunLocalTests
	
unit-test:
	sfdx force:apex:test:run --codecoverage --testlevel RunLocalTests --resultformat human -u ${alias}
	
unit-test-dev:
	sfdx force:apex:test:run --codecoverage --testlevel RunLocalTests --resultformat human -u ${alias}

git-tag:
	git tag -fa latest -m ${version_name}
	git tag -fa ${version_id} -m ${version_name}
	git tag -fa ${version_name} -m ${version_name}
	git push -f --tags
