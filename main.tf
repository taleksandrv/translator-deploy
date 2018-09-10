provider "kubernetes" {}

provider "template" {}


#
# Kubernetes namespace
#

resource "kubernetes_namespace" "translator" {
  metadata {
    labels {
      mylabel = "${var.namespace}"
    }
    name = "${var.namespace}"
  }
}


#
# Kubernetes replica controller for the backend application
#

resource "kubernetes_replication_controller" "translator_back" {
  metadata {
    name      = "${var.back_deployment}"
    namespace = "${kubernetes_namespace.translator.metadata.0.name}"
    labels {
      app = "${var.back_deployment}"
    }
  }
  spec {
    selector {
      app = "${var.back_deployment}"
    }
    template {
      container {
        image = "${var.back_docker_image}:${var.version_back_docker_image}"
        name  = "${var.back_deployment}"
        env {
          name = "TOKEN_YA"
          value_from {
            secret_key_ref {
              name  = "${kubernetes_secret.yandex_token.metadata.0.name}"
              key   = "token"
            }
          }
        }
      }
    }
  }
}


#
# Kubernetes service for the backend application
#

resource "kubernetes_service" "translator_back" {
  metadata {
    name = "${var.back_deployment}"
    namespace = "${kubernetes_namespace.translator.metadata.0.name}"
  }
  spec {
    selector {
      app = "${kubernetes_replication_controller.translator_back.metadata.0.labels.app}"
    }
    session_affinity = "ClientIP"
    port {
      port = "${var.back_port}"
    }
    type = "NodePort"
  }
}


#
# Kubernetes replica controller for the UI application
#

resource "kubernetes_replication_controller" "translaror_ui" {
  metadata {
    name      = "${var.ui_deployment}"
    namespace = "${kubernetes_namespace.translator.metadata.0.name}"
    labels {
      app = "${var.ui_deployment}"
    }
  }
  spec {
    selector {
      app = "${var.ui_deployment}"
    }
    template {
      container {
        image = "${var.ui_docker_image}:${var.version_ui_docker_image}"
        name  = "${var.ui_deployment}"
        env {
          name  = "TRANSLATE_SRV"
          value = "${data.template_file.back_addr.rendered}"
        }
      }
    }
  }
}


#
# Get the backend service add
#

data "template_file" "back_addr" {
  template = "http://$${host}.$${namespace}.svc.cluster.local:$${port}"
  vars {
    host      = "${kubernetes_service.translator_back.metadata.0.name}"
    namespace = "${kubernetes_namespace.translator.metadata.0.name}"
    port      = "${kubernetes_service.translator_back.spec.0.port.0.port }"
  }
}


#
# Kubernetes service for the UI application
#

resource "kubernetes_service" "translator_ui" {
  metadata {
    name = "${var.ui_deployment}"
    namespace = "${kubernetes_namespace.translator.metadata.0.name}"
  }
  spec {
    selector {
      app = "${kubernetes_replication_controller.translaror_ui.metadata.0.labels.app}"
    }
    session_affinity = "ClientIP"
    port {
      port = "${var.ui_port}"
    }
    type = "NodePort"
  }
}


#
# Put to the Kubernetes secret yandex token
#

resource "kubernetes_secret" "yandex_token" {
  metadata {
    name      = "yandex-token"
    namespace = "${kubernetes_namespace.translator.metadata.0.name}"
  }
  data {
    token = "${var.yandex_token}"
  }
}
