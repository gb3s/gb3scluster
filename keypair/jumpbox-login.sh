#!/bin/sh

ResourceGroupName="gb3s-bastion"
BastionName="gb3s-bastion"
TargetVMPort="22"
LocalMachinePort="8081"
VMResourceId="/subscriptions/4dc1bd33-fef6-413d-aa31-bc639452a449/resourceGroups/gb3s-jump/providers/Microsoft.Compute/virtualMachines/gb3s-jumpbox"

az network bastion ssh --name $BastionName --resource-group $ResourceGroupName --target-resource-id $VMResourceId --auth-type "password" --username "gbabes"              