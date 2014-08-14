#!/bin/bash
TR="tr -d ',:\"'"
GROUPS="`aws iam list-groups | grep GroupName | awk '{ print $2 }' | tr -d '"'`"
echo $GROUPS
for group in "$GROUPS"; do
	POLICIES="`aws iam list-group-policies --group-name $group | grep -E '^        ' | $TR`"
	for policy in $POLICIES; do
		echo aws iam get-group-policy --group-name $group --policy-name $policy
	done
done
