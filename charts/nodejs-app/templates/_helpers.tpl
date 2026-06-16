{{- define "nodejs-app.name" -}}
{{- .Chart.Name }}
{{- end }}

{{- define "nodejs-app.fullname" -}}
{{- printf "%s-%s" .Release.Name .Chart.Name | trunc 63 | trimSuffix "-" }}
{{- end }}
