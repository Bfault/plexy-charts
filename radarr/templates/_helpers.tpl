{{/* vim: set filetype=mustache: */}}
{{/*
Expand the name of the chart.
*/}}
{{- define "radarr.name" -}}
{{- default .Chart.Name .Values.nameOverride | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Create a default fully qualified app name.
We truncate at 63 chars because some Kubernetes name fields are limited to this (by the DNS naming spec).
If release name contains chart name it will be used as a full name.
*/}}
{{- define "radarr.fullname" -}}
{{- if .Values.fullnameOverride }}
{{- .Values.fullnameOverride | trunc 63 | trimSuffix "-" }}
{{- else }}
{{- $name := default .Chart.Name .Values.nameOverride }}
{{- if contains $name .Release.Name }}
{{- .Release.Name | trunc 63 | trimSuffix "-" }}
{{- else }}
{{- printf "%s-%s" .Release.Name $name | trunc 63 | trimSuffix "-" }}
{{- end }}
{{- end }}
{{- end }}

{{/*
Create chart name and version as used by the chart label.
*/}}
{{- define "radarr.chart" -}}
{{- printf "%s-%s" .Chart.Name .Chart.Version | replace "+" "_" | trunc 63 | trimSuffix "-" }}
{{- end }}


{{/*
Common labels
*/}}
{{- define "radarr.labels" -}}
helm.sh/chart: {{ include "radarr.chart" . }}
{{ include "radarr.selectorLabels" . }}
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
{{- define "radarr.selectorLabels" -}}
app.kubernetes.io/name: {{ include "radarr.name" . }}
app.kubernetes.io/instance: {{ .Release.Name }}
{{- end }}

{{/*
Return the appropriate apiVersion for ingress.
*/}}
{{- define "radarr.ingress.apiVersion" -}}
{{- if and ($.Capabilities.APIVersions.Has "networking.k8s.io/v1") (semverCompare ">=1.19-0" $.Capabilities.KubeVersion.Version) }}
{{- printf "networking.k8s.io/v1" }}
{{- else }}
{{- printf "networking.k8s.io/v1beta1" }}
{{- end }}
{{- end }}

{{/*
Return if ingress is stable.
*/}}
{{- define "radarr.ingress.isStable" -}}
{{- eq (include "radarr.ingress.apiVersion" .) "networking.k8s.io/v1" }}
{{- end }}

{{/*
Return if ingress supports ingressClassName
*/}}
{{- define "radarr.ingress.supportsIngressClassName" -}}
{{- or (eq (include "radarr.ingress.isStable" .) "true") (and (eq (include "radarr.ingress.apiVersion" .) "networking.k8s.io/v1beta1") (semverCompare ">=1.18-0" .Capabilities.KubeVersion.Version)) }}
{{- end }}

{{/*
Return if ingress supports PathType
*/}}
{{- define "radarr.ingress.supportsPathType" -}}
{{- or (eq (include "radarr.ingress.isStable" .) "true") (and (eq (include "radarr.ingress.apiVersion" .) "networking.k8s.io/v1beta1") (semverCompare ">=1.18-0" .Capabilities.KubeVersion.Version)) }}
{{- end }}