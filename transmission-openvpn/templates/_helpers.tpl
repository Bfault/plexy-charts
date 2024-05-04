{{/* vim: set filetype=mustach: */}}
{{/*
Expand the name of the charts.
*/}}
{{- define "transmission-openvpn.name" -}}
{{- default .Chart.Name .Values.nameOverride | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Create a default fully qualified app name.
We truncate at 63 chars because some Kubernetes name fields are limited to this (by the DNS naming spec).
If release name contains chart name it will be used as a full name.
*/}}
{{- define "transmission-openvpn.fullname" -}}
{{- if .Values.fullnameOverride }}
{{- .Values.fullnameOverride | trunc 63 | trimSuffix "-" }}
{{- else }}
{{- $name := default .Chart.Name .Values.nameOverride }}
{{- if contains $name .Release.Name -}}
{{- .Release.Name | trunc 63 | trimSuffix -}}
{{- else }}
{{- printf "%s-%s" .Release.Name $name | trunc 63 | trimSuffix "-" }}
{{- end }}
{{- end }}
{{- end }}

{{/*
Create chart name and version as used by the chart label.
*/}}
{{- define "transmission-openvpn.chart" -}}
{{- printf "%s-%s" .Chart.Name .Chart.Version | replace "+" "_" | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Common labels
*/}}
{{- define "transmission-openvpn.labels" -}}
helm.sh/chart: {{ include "transmission-openvpn.chart" . }}
{{ include "transmission-openvpn.selectorLabels" . }}
{{- if or .Chart.AppVersion .Values.image.tag }}
app.kubernetes.io/version: {{ mustRegexReplaceAllLiteral "@sha.*" .Values.image.tag "" | default .Chart.AppVersion | quote }}
{{- end }}
app.kubernetes.io/managed-by: {{ .Release.Service }}
{{- with .Values.extraLabels }}
{{ toYaml . }}
{{- end }}
{{- end }}

{{/*
Selector labels
*/}}
{{- define "transmission-openvpn.selectorLabels" -}}
app.kubernetes.io/name: {{ include "transmission-openvpn.name" . }}
app.kubernetes.io/instance: {{ .Release.Name }}
{{- end -}}

{{/*
Return the appropriate apiVersion for ingress.
*/}}
{{- define "transmission-openvpn.ingress.apiVersion" -}}
{{- if and ($.Capabilities.APIVersions.Has "networking.k8s.io/v1") (semverCompare ">=1.19-0" $.Capabilities.KubeVersion.Version) }}
{{- printf "networking.k8s.io/v1" }}
{{- else }}
{{- printf "networking.k8s.io/v1beta1" }}
{{- end }}
{{- end }}

{{/*
Return if ingress is stable.
*/}}
{{- define "transmission-openvpn.ingress.isStable" -}}
{{- eq (include "transmission-openvpn.ingress.apiVersion" .) "networking.k8s.io/v1" }}
{{- end }}

{{/*
Return if ingress supports ingressClassName
*/}}
{{- define "transmission-openvpn.ingress.supportsIngressClassName" -}}
{{- or (eq (include "transmission-openvpn.ingress.isStable" .) "true") (and (eq (include "transmission-openvpn.ingress.apiVersion" .) "networking.k8s.io/v1beta1") (semverCompare ">=1.18-0" .Capabilities.KubeVersion.Version)) }}
{{- end }}

{{/*
Return if ingress supports PathType
*/}}
{{- define "transmission-openvpn.ingress.supportsPathType" -}}
{{- or (eq (include "transmission-openvpn.ingress.isStable" .) "true") (and (eq (include "transmission-openvpn.ingress.apiVersion" .) "networking.k8s.io/v1beta1") (semverCompare ">=1.18-0" .Capabilities.KubeVersion.Version)) }}
{{- end }}