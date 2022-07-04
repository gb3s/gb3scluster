helm repo add jetstack https://charts.jetstack.io
helm repo update
helm upgrade \
  cert-manager jetstack/cert-manager \
  --namespace cert-manager \
  --create-namespace \
  --version v1.8.2 \
  --set installCRDs=true
  --install

helm repo add actions-runner-controller https://actions-runner-controller.github.io/actions-runner-controller
helm upgrade --install --namespace actions-runner-system --create-namespace --set authSecret.create=true \
  --set authSecret.github_app_id=216613 --set authSecret.github_app_installation_id=27073459 \
  --set authSecret.github_app_private_key="
  -----BEGIN RSA PRIVATE KEY-----
MIIEpQIBAAKCAQEA0m3CursfM//bq/BRZch9FdFxVdBjdkBWsfTKwPYyqWzPkHFY
NyVYA7Ulk/v5+rUIlSx4gBqh5PSOgU5Vrobow0CJCsAxWxFTAK7bxQBOm1v9gbKo
9xEbzTCY3JtSYI5s8LZhPN4/QPVHyJhHW4wQLcWOjbkk7csUdURL/tKINqNq9vFN
M2QbR/ERAl60ZCMsu8vJGRX6ut6aObmZsFd4mL8oXQmSVRDsE0WI844MPdMczcAh
aKqI3raCVDkBEyNvT3FoEg7/E8VpIHJOYvJ9aZAPuZLL21zU6PwVWv49SliECGwy
g9lspBSQpCgSQzJItQAlhwmFsi9Jnc6apS+B9wIDAQABAoIBAGFb60beINe8P3TT
4bVIB6e6mcdsfThPGE2Jxu10e4gsEfTwnDIXkxtUCqjnYod+jxQF2VLb/5+hDvYA
ul/fh34fM8jHl45c+5xLSt9g/v2emDIT6V02izhqja80Je8KtpjAqUiyQ23Yjnff
DNTsfufOieBEkzN6TGLdUJP78I3mQw0m5HoWpTH2psq8vjME5Zlb95sQOXYxka8C
rmlUrMh7EVpHhs+PKeW5xCxE3hQzZp662E15MO207pbtOTS3UwVz08zDQePBQFc2
JKtnSiQ+NJiUqDTZoSjUr6FvWk59nczSo14nLOVDC2oKitwBJ/Crl192ynkfhBPh
CWm27VECgYEA9cTNDvwGrwAEzPb5nmdGFJIaG1kBl7GJOuow7SRFEspQCwOq3UsQ
5Hw1ucYWyzgL3CmPM0Rhb4isH4ZEigb7EsmF98C8YAvJOmpjSWJtu3bxQhXWflPu
/fIbXYSKjwETOdw0L2HAbesz4krXZ1z1kFAcFgPh1qGpnyklQCcNe2sCgYEA2zBV
1rNHEp06udv8CKIlV4ge/KFd0TGHa/hIpjteAnn9w6Acy01BR4+8f1fOQv04yIAc
inKNxMQrJCTVAaBw50fxZ9YRKvPDevqPC74+XbhC59skmPXcdME77edhMYVme+na
+M88erVMZ4WwvPH9Q+t9E3Rg/lekxoqRxUDAYqUCgYEA5hMehHCbMSirVdW/SPMV
QBymJAPm4cNp3KVwuA/EOhr7Y9RDGHc1kTBWe1td61DEiY6+aBgTvv4LZFelwjFW
yfeuWokr0B44e18tI33pjB2FLYCUFB8vFLyZsapqrAUtonTqxZCVPFF7eNTnYfQ8
TqUwJcvsl6kvybgTD0N/85ECgYEAuzZFmuP1SIjSp/ylABq+Gk1BajXJk+vh5u5h
3tnGKgdYH8aZ0Wti3mR+c6XjnoP6BAaoWfgN7oo+7tgmtwT6ahCguDe24iDiTh/E
HhuX2SSQwMgEMkGM0oxZS5HdChcOube8N9eJqKVBZQpjMn7d+y0f34X/cj4Zlxqz
9u6fY6ECgYEAqFN2RfUVML/y+UAK4CxbYwczmPKmlAlOdPvg0Wtk0j9ci4lDZrwP
QIi4QUi6FaBxp6uwkdAhhqrB825FPvo4GOz8o2WrchXRmhMQohWQoWltUXxCVBae
IakKLa1s+9a+H/R51jaDcLpsezpBbAAGfCOWkAegUOiCCHZ7VWayTSQ=
-----END RSA PRIVATE KEY-----"
  --wait actions-runner-controller actions-runner-controller/actions-runner-controller