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
--set authSecret.github_app_private_key="-----BEGIN RSA PRIVATE KEY-----\
MIIEpQIBAAKCAQEAwqulLAWEF6zyScKaHwfHr6K94elE/Ro3KY+29LlVTFT3Bss8 \
q71F9+GsBPgwjcDICV0tqK/myBMWc/p9CGypXtYXX3QygxkgIlmXPav3RBVKZ/Mc \
kQETC8vRBXuVYH3ez3oibsNyVPjwASPtn3BvJd2VScSD98qya9qrc6puu0CEemKU \
X1TWhITnMQL2R5Ptu6/fPQpxo5UMMvBWJ4XS/5W0iiBcxSUOns+RZSi7ffUInmhN \
TdH7GjPvRyyENRdJgnidZpSt+Ak0Rn1in4tea4MSQ6v3FPMvQpwZZg4gwmirvQss \
Qm9zARqeJBp0ZznRNlWPM3NlKCotIaZdFh/KwwIDAQABAoIBAQCz95D0WIkchiNb \
s09ePogJxE78yfWgc5rpjlYaejf0IFxa6IrHTmyf0/5+faANfFqx5XVvjGazMopA \     
YCM1JZeS+COVeEu2TQUbHG4ocpFeXLxzyxnup+qericnhW+8S8EvV/77HS7WhWkD \
9N4Z1wy6GdaI4ucJrlcyRG7auIY0DryQ0P1GjaGHXc2/1OigEMpMjuXllKf1HN68 \
97OLbrm0n6n55tRlPsKKWOmesggnDzYP4jo/ek6+OxVlr0n73PbkGpiD5MddLVcw \
EMRbjJQr7hKvZMMgu7KAGgaJgK9EpXZLT+6nRfEv0XdBO6S147msIxA+bnFw8jHT \
tbbEsryRAoGBAO3ufooN6c9sVlNlf/oMDQIczIxo78xBkZ56xyLPhvv1Lh4t26YA \ 
d7//2s7Eo8uV+mGedVDpV+L+SnLX3YS35YaAi8WnGzT83sT9BCjnap6l7GnRHdyw \
g7JuLiSjzgPQuQfdu6mQ6VJn5U3IQcViwVMEjnwLIbY+t9y6qSBz12HbAoGBANF0 \
IjYeprF32sr0NiMl3cH/6/ze4oGLawnbz/nyQKyc1gjvr827jLN+9+vDI41p0mn9 \
aJSaTiZaxM68mpYYlMD4esCGAj/mveSWwDJPl/N3cbncwKtstZ1KJRvVGC9GwXrO \
qoL2h4yg4xwdJa6cDXEeHTPLy00qbNjyzH/4o1M5AoGBANtCjuXWEIMPiTXtMVRS \
SqKJu44hHeqS+gibiGtx5yjFNqylAecmQzRyKUemOnNgUI4pIl9fyZfrUtwmRYMK \
nL+oMiYA6reX2AqcR3sSV1S//u88wFIhcBu8IVWuhilJ7VlsYoXOftVr3Qoi40ls \
yk8gwdVZxMVXYsRMV5MKbY9FAoGBAIOp+juFBwo2Kn48B7AOhJkH9GOQBFikuFOJ \
LvKS2x7mtBEIAr5T8D2BSf2VPEsPw2pHFq+bVBb+JgtDOfWyXAf16swNMWrT9Hi2 \
XvkBWaZ9ZisM3ryj6IKIck1NphdJ5iP5t+v9ZvX6yOkKVX6usDB0Wq0Npa3LRoMW \
FYE4XgrZAoGAQyzKOUpax3gZRwr1yPs34hFD30ePPkb/IA94vq1xqfVnITDXVVFX \
KMiMk7n4YxuKMBMCTlOjBbs4GeFNUlT8gre+zV2YCVbmW6KlUombkBhHTgvYg5bI \
IzxO+5yKA0agaB+0rZ6xPNsK+Y7ALT5CkG5XqOoc+6p0OaL7ukrEmkQ= \
-----END RSA PRIVATE KEY----- \"